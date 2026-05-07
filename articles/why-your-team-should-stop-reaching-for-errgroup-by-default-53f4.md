---
title: "Why Your Team Should Stop Reaching for errgroup by Default"
url: "https://dev.to/gabrielanhaia/why-your-team-should-stop-reaching-for-errgroup-by-default-53f4"
author: "Gabriel Anhaia"
category: "code-optimization"
---
# Why Your Team Should Stop Reaching for errgroup by Default
**Author:** Gabriel Anhaia  **Published:** April 29, 2026

## Overview
errgroup from Go's standard library is overused as a default concurrency primitive despite being designed for specific use cases. It introduces three production failure modes that teams commonly encounter.

## Key Concepts

### Three Failure Modes

**Failure 1: Context Cancellation on First Error**
`WithContext` cancels peer goroutines when any function returns an error. Problematic for scenarios requiring partial results (e.g., enriching responses from multiple backends where one failure shouldn't discard nearly-complete work).

**Failure 2: Panic Handling Issues**
Panics in errgroup goroutines may be swallowed by middleware with its own recover() logic before errgroup sees them. This breaks peer-cancellation guarantees.

**Failure 3: Goroutine Leaks on Channel Operations**
Goroutines blocked on channel sends/receives aren't unblocked by context cancellation alone. Without `<-gctx.Done()` guards at every channel operation, goroutines can leak indefinitely.

### Decision Framework
Before using errgroup, answer three questions:
1. Do you want partial results on failure, or should one failure cancel peers?
2. Are all channel operations guarded with `<-gctx.Done()` branches?
3. Does any middleware in the call chain recover panics without re-panicking?

## Key Code Examples

```go
// Anti-pattern: errgroup where partial results are acceptable
g, gctx := errgroup.WithContext(ctx)
// Four concurrent enrichments - first error cancels EVERYTHING
g.Go(func() error { return fetchProfile(gctx, id, &profile) })
g.Go(func() error { return fetchPrefs(gctx, id, &prefs) })
g.Go(func() error { return fetchBadges(gctx, id, &badges) })
g.Go(func() error { return fetchActivity(gctx, id, &activity) })
if err := g.Wait(); err != nil {
    return Out{}, err  // Throws away 3 successful results!
}
```

```go
// Pattern 1: WaitGroup + errors.Join for partial results
var wg sync.WaitGroup
errs := [4]error{}
wg.Add(4)
go func() { defer wg.Done(); errs[0] = fetchProfile(ctx, id, &profile) }()
go func() { defer wg.Done(); errs[1] = fetchPrefs(ctx, id, &prefs) }()
go func() { defer wg.Done(); errs[2] = fetchBadges(ctx, id, &badges) }()
go func() { defer wg.Done(); errs[3] = fetchActivity(ctx, id, &activity) }()
wg.Wait()
return Out{profile, prefs, badges, activity}, errors.Join(errs[:]...)
```

```go
// Pattern 2: Custom Group type with explicit semantics
type Group struct {
    ctx    context.Context
    cancel context.CancelFunc  // nil for WaitAll
    wg     sync.WaitGroup
    mu     sync.Mutex
    errs   []error
}

func NewFailFast(parent context.Context) *Group {
    ctx, cancel := context.WithCancel(parent)
    return &Group{ctx: ctx, cancel: cancel}
}

func NewWaitAll(parent context.Context) *Group {
    return &Group{ctx: parent}  // No cancel function
}

// Call sites now self-document their intent:
g := NewFailFast(ctx)   // vs
g := NewWaitAll(ctx)
```

```go
// Pattern 3: errgroup.SetLimit for bounded fan-out (correct use case)
g, gctx := errgroup.WithContext(ctx)
g.SetLimit(20)  // Bound concurrency - don't spawn 1000 goroutines for 1000 items

for _, id := range ids {
    id := id
    g.Go(func() error {
        select {
        case <-gctx.Done():
            return gctx.Err()  // Respect cancellation on channel ops
        default:
        }
        return process(gctx, id)
    })
}
return g.Wait()
```

## When errgroup IS appropriate
- Processing thousands of items with a concurrency limit
- All operations must succeed for the result to be valid
- Fail-fast semantics and peer cancellation are genuinely desired
- All channel operations are guarded with ctx.Done() checks
