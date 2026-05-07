---
title: "A Lock-Free Counter in Go: atomic, sync.Map, or Just a Mutex?"
url: "https://dev.to/gabrielanhaia/a-lock-free-counter-in-go-atomic-syncmap-or-just-a-mutex-31fo"
author: "Gabriel Anhaia"
category: "code-optimization"
---
# A Lock-Free Counter in Go: atomic, sync.Map, or Just a Mutex?
**Author:** Gabriel Anhaia  **Published:** May 4, 2026

## Overview
Examines three approaches for implementing shared counters in Go under concurrent load. Container choice around atomic operations significantly impacts CPU usage even when the underlying increment mechanism is identical. Switching from sync.Map to RWMutex-guarded map eliminated a counter from CPU profiles entirely.

## Key Concepts

### The Three Implementations

1. **Atomic Counter (Go 1.19+)**: Uses atomic.Int64, compiles to single CPU instruction. Best for single hot counters. Prevents accidental value-vs-pointer mistakes.

2. **Mutex Counter**: Traditional sync.Mutex around int64. Safer for multi-field updates. Provides consistent snapshots across multiple counters. Brutal under contention due to goroutine parking.

3. **sync.Map Counter**: Maps string keys to *atomic.Int64 values. Adds interface lookup overhead. Documented for read-mostly, disjoint-key patterns. Generally slowest for hot-path metric incrementing.

### Decision Rule
- Single counter on hot path: Use atomic.Int64
- Multiple counters moving together per event: Use sync.Mutex with all updates inside one critical section
- Named counter registry (stable keys, reads dominant): Use map[string]*atomic.Int64 with sync.RWMutex

## Key Code Examples

```go
// Atomic Counter
type AtomicCounter struct {
    v atomic.Int64
}

func (c *AtomicCounter) Inc()        { c.v.Add(1) }
func (c *AtomicCounter) Load() int64 { return c.v.Load() }

// Mutex Counter
type MutexCounter struct {
    mu sync.Mutex
    v  int64
}

func (c *MutexCounter) Inc() {
    c.mu.Lock()
    c.v++
    c.mu.Unlock()
}

func (c *MutexCounter) Load() int64 {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.v
}
```

```go
// sync.Map implementation
type MapCounter struct {
    m sync.Map // map[string]*atomic.Int64
}

func (c *MapCounter) Inc(key string) {
    if v, ok := c.m.Load(key); ok {
        v.(*atomic.Int64).Add(1)
        return
    }
    fresh := new(atomic.Int64)
    actual, _ := c.m.LoadOrStore(key, fresh)
    actual.(*atomic.Int64).Add(1)
}
```

```go
// Benchmark test
func BenchmarkAtomicInc(b *testing.B) {
    var c AtomicCounter
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() { c.Inc() }
    })
}

// Run with: go test -bench=. -benchmem -cpu=1,4,8 -count=10 | tee bench.out
```

```go
// Multi-field stats with mutex (consistent snapshots)
type Stats struct {
    mu       sync.Mutex
    requests int64
    errors   int64
    bytes    int64
}

func (s *Stats) Record(err bool, n int64) {
    s.mu.Lock()
    s.requests++
    if err { s.errors++ }
    s.bytes += n
    s.mu.Unlock()
}
```

```go
// Registry with RWMutex (recommended for metrics with stable key set)
type Registry struct {
    mu sync.RWMutex
    m  map[string]*atomic.Int64
}

func (r *Registry) Inc(key string) {
    r.mu.RLock()
    v, ok := r.m[key]
    r.mu.RUnlock()
    if ok {
        v.Add(1)
        return
    }
    r.mu.Lock()
    if v, ok = r.m[key]; !ok {
        v = new(atomic.Int64)
        r.m[key] = v
    }
    r.mu.Unlock()
    v.Add(1)
}
```

## Performance Insights
Expected performance order at realistic contention:
- Atomic: single-digit nanoseconds, growing to tens at high concurrency
- Mutex: tens of nanoseconds at low contention, order-of-magnitude worse at -cpu=8
- sync.Map: slowest consistently; lookup overhead dominates even with atomic inner increment
