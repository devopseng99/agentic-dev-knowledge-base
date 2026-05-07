---
title: "errgroup vs WaitGroup vs Channels: Pick the Right Concurrency Primitive"
url: "https://dev.to/gabrielanhaia/errgroup-vs-waitgroup-vs-channels-pick-the-right-concurrency-primitive-d7e"
author: "Gabriel Anhaia"
category: "code-optimization"
---
# errgroup vs WaitGroup vs Channels: Pick the Right Concurrency Primitive
**Author:** Gabriel Anhaia  **Published:** May 5, 2026

## Overview
A real production bug where errgroup.WithContext cancelled 999 successfully translated documents because one failed, wasting cloud resources. Go provides three distinct concurrency tools, each answering a different question about work distribution. "Pick the primitive that matches the work."

## Key Concepts

### The Three Primitives

**sync.WaitGroup**: Counter with Add(n), Done(), and Wait(). Signals when N goroutines finish. Does not propagate errors, cancel work, or transfer values.

**errgroup.Group**: Extends WaitGroup by adding error capture and context cancellation. When using WithContext, first non-nil error cancels the derived context. Best for fail-fast semantics.

**Channels**: Transfer value ownership between goroutines with optional buffering. Enable select-based cancellation. Support back-pressure through blocking sends.

### Decision Matrix
1. Partial results acceptable on failure? Yes -> WaitGroup + errors.Join. No -> errgroup.WithContext
2. Do goroutines exchange values or run independently? Exchange values -> channel. Run side-by-side returning errors -> errgroup. Run side-by-side with disjoint writes -> WaitGroup
3. Back-pressure required? Yes -> channel with chosen buffer size. No -> fan-out primitive

## Key Code Examples

```go
// Case A: Batch Translation (WaitGroup - partial results OK)
func TranslateAll(ctx context.Context, ids []string,
    fn func(context.Context, string) (string, error)) ([]Result, error) {
    out := make([]Result, len(ids))
    var wg sync.WaitGroup
    wg.Add(len(ids))

    for i, id := range ids {
        go func(i int, id string) {
            defer wg.Done()
            text, err := fn(ctx, id)
            out[i] = Result{ID: id, Text: text, Err: err}
        }(i, id)
    }
    wg.Wait()

    var errs []error
    for _, r := range out {
        if r.Err != nil { errs = append(errs, r.Err) }
    }
    return out, errors.Join(errs...)
}
```

```go
// Case B: Parallel API Calls (errgroup - fail fast)
func Search(ctx context.Context, q string) (Hits, error) {
    g, gctx := errgroup.WithContext(ctx)
    var h Hits

    g.Go(func() error { ds, err := searchDocs(gctx, q); h.Docs = ds; return err })
    g.Go(func() error { ps, err := searchPeople(gctx, q); h.People = ps; return err })
    g.Go(func() error { pr, err := searchProjects(gctx, q); h.Projects = pr; return err })
    g.Go(func() error { ts, err := searchTags(gctx, q); h.Tags = ts; return err })

    if err := g.Wait(); err != nil { return Hits{}, err }
    return h, nil
}
```

```go
// Case C: Rate-Limited Worker Pool (channels - back-pressure)
func Run(ctx context.Context, in <-chan Job, workers int, rps int,
    do func(context.Context, Job) error) error {
    tick := time.NewTicker(time.Second / time.Duration(rps))
    defer tick.Stop()

    gated := make(chan Job)
    go func() {
        defer close(gated)
        for j := range in {
            select {
            case <-tick.C:
            case <-ctx.Done(): return
            }
            select {
            case gated <- j:
            case <-ctx.Done(): return
            }
        }
    }()

    errs := make(chan error, workers)
    done := make(chan struct{})

    for i := 0; i < workers; i++ {
        go func() {
            for j := range gated {
                if err := do(ctx, j); err != nil { errs <- err; return }
            }
            done <- struct{}{}
        }()
    }

    finished := 0
    for finished < workers {
        select {
        case err := <-errs: return err
        case <-done: finished++
        case <-ctx.Done(): return ctx.Err()
        }
    }
    return nil
}
```

## Performance Considerations
- Goroutine spawning is negligible at scale
- Uncontended channel operations remain cheap
- Contended channel sends serialize through internal mutex
- Cost ordering: atomic < mutex < uncontended sends < contended sends
