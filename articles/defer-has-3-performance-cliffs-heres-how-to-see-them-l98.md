---
title: "Defer Has 3 Performance Cliffs. Here's How to See Them"
url: "https://dev.to/gabrielanhaia/defer-has-3-performance-cliffs-heres-how-to-see-them-l98"
author: "Gabriel Anhaia"
category: "code-optimization"
---
# Defer Has 3 Performance Cliffs. Here's How to See Them
**Author:** Gabriel Anhaia  **Published:** April 29, 2026

## Overview
Go's defer statement can unexpectedly become a performance bottleneck. While open-coded defer (Go 1.14+) runs in ~6ns, the fallback mechanism costs ~35ns. The compiler silently switches between these two implementations based on specific code patterns, creating three "performance cliffs" where optimization is lost without warning.

## Key Concepts

### Open-Coded vs Stack-Allocated Defer
- Open-coded defer: Compiler inlines the deferred call into each return path, tracks which defers fired with an 8-bit bitmap, skips deferproc entirely (~6ns)
- Stack-allocated defer: Falls back to runtime.deferproc, allocating a _defer record (~35ns)

### The Three Cliffs

**Cliff 1: Defer Inside a Hot Loop**
Placing defer inside loops disqualifies the entire function from open-coded optimization.

**Cliff 2: Too Many Defers in One Function**
The compiler uses a single byte (8 bits) to track which defers executed. Exceeding 8 defers in one function causes all defers to use the slow path.

**Cliff 3: Closures Capturing Loop Variables**
Deferred function literals that capture loop variables cause escape analysis to move those variables to the heap, triggering allocations.

## Key Code Examples

```go
// CLIFF 1: Problem - defer inside loop
func processAll(paths []string) error {
    for _, p := range paths {
        f, err := os.Open(p)
        if err != nil { return err }
        defer f.Close()  // BAD: disqualifies open-coded optimization
        if err := process(f); err != nil { return err }
    }
    return nil
}

// Benchmark result:
// BenchmarkLoopDefer-8       1652  698.4 ns/op  240 B/op  10 allocs/op
// BenchmarkLoopNoDefer-8     5142  234.1 ns/op    0 B/op   0 allocs/op

// FIX: Extract loop body into helper function
func processAll(paths []string) error {
    for _, p := range paths {
        if err := processOne(p); err != nil { return err }
    }
    return nil
}

func processOne(p string) error {
    f, err := os.Open(p)
    if err != nil { return err }
    defer f.Close()  // OK: defer at function scope
    return process(f)
}
```

```go
// CLIFF 2: Problem - too many defers (9th defer hits cliff)
func handleRequest(ctx context.Context, w http.ResponseWriter, r *http.Request) error {
    span, ctx := tracer.Start(ctx, "handleRequest")
    defer span.End()          // 1
    timer := metrics.NewTimer("req")
    defer timer.Stop()        // 2
    conn, _ := pool.Get(ctx)
    defer pool.Put(conn)      // 3
    tx, _ := conn.Begin(ctx)
    defer tx.Rollback()       // 4
    lockCtx := lock.Acquire(r.UserID)
    defer lock.Release(lockCtx) // 5
    cache := localCache.Snapshot()
    defer cache.Free()        // 6
    f, _ := openTempFile(r)
    defer os.Remove(f.Name()) // 7
    defer f.Close()           // 8
    audit := audit.New(r)
    defer audit.Flush()       // 9 -- CLIFF
    return nil
}

// Detection: go build -gcflags='-d=defer'

// FIX: Group related defers into helpers
type reqResources struct {
    span  trace.Span
    timer *metrics.Timer
    conn  *pool.Conn
    tx    *db.Tx
}

func acquireReqResources(ctx context.Context, r *http.Request) (*reqResources, func(), error) {
    rr := &reqResources{}
    cleanup := func() {
        if rr.tx != nil    { rr.tx.Rollback() }
        if rr.conn != nil  { pool.Put(rr.conn) }
        if rr.timer != nil { rr.timer.Stop() }
        if rr.span != nil  { rr.span.End() }
    }
    return rr, cleanup, nil
}
```

```go
// CLIFF 3: Problem - closures capturing loop variables
func processItems(items []*Item) {
    for _, it := range items {
        defer logCompletion(it)     // (a) plain call -- fine
    }
    for _, it := range items {
        defer func() {              // (b) closure -- BAD: "moved to heap: it"
            log.Printf("done: %s", it.ID)
        }()
    }
}

// FIX: Extract to function
func processItems(items []*Item) {
    for _, it := range items { processOne(it) }
}

func processOne(it *Item) {
    defer logCompletion(it)  // OK: plain call
}
```

## Diagnostic Tools

```bash
go build -gcflags='-d=defer'  # identifies defer type
go build -gcflags='-m'        # shows escape analysis
go test -bench=. -benchmem    # measures allocs/op
```

## Summary Rules
1. Defer at function scope only - never inside loops; extract to helpers
2. Stay under 8 defers per function - bundle related cleanups
3. Defer plain calls, not closures - avoid capturing loop variables
