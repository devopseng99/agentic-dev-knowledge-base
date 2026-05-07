---
title: "Go Channels Aren't Free. Here's the Real Cost"
url: "https://dev.to/gabrielanhaia/go-channels-arent-free-heres-the-real-cost-56eg"
author: "Gabriel Anhaia"
category: "code-optimization"
---
# Go Channels Aren't Free. Here's the Real Cost
**Author:** Gabriel Anhaia  **Published:** April 29, 2026

## Overview
Challenges the common Go practice of using channels everywhere. A production team reduced CPU usage by roughly one-third by replacing a counter channel with sync.Mutex and int64. Channel selection significantly impacts performance at scale.

## Key Concepts

### Core Performance Numbers (modern x86)
- Uncontended sync.Mutex Lock+Unlock: tens of nanoseconds
- atomic.AddInt64: handful of nanoseconds
- Buffered channel send+recv (single producer/consumer): several times costlier than mutex
- Unbuffered channels: higher cost due to mandatory rendezvous
- Contended channels under N producers/M consumers: easily microseconds

### Why Channels Cost More
Channels force every mutation through a queue with runtime scheduler involvement:
- Channel lock acquisition
- Ring buffer value copying
- Possible goroutine parking/waking
- Lock release

### Three-Question Decision Framework
1. Single state mutation under contention? Use mutex or atomic.
2. Ownership transfer between goroutines? Use channels (park/wake semantics essential).
3. Signaling (not data transfer)? Channels of struct{}{} or context.Done() are canonical.

## Key Code Examples

```go
// Counter pattern comparison
package bench

import (
    "sync"
    "sync/atomic"
    "testing"
)

func BenchmarkCounterChannel(b *testing.B) {
    ch := make(chan int, 1024)
    done := make(chan struct{})
    var total int64

    go func() {
        for v := range ch { total += int64(v) }
        close(done)
    }()

    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() { ch <- 1 }
    })
    close(ch)
    <-done
    _ = total
}

func BenchmarkCounterMutex(b *testing.B) {
    var mu sync.Mutex
    var total int64
    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            mu.Lock()
            total++
            mu.Unlock()
        }
    })
}

func BenchmarkCounterAtomic(b *testing.B) {
    var total atomic.Int64
    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() { total.Add(1) }
    })
}
```

```go
// Worker pool with channels (correct use case)
func BenchmarkWorkerPoolChannel(b *testing.B) {
    const workers = 8
    jobs := make(chan Job, 64)
    var wg sync.WaitGroup
    wg.Add(workers)
    for i := 0; i < workers; i++ {
        go func() {
            defer wg.Done()
            for j := range jobs { process(j) }
        }()
    }
    b.ResetTimer()
    for i := 0; i < b.N; i++ { jobs <- Job{} }
    close(jobs)
    wg.Wait()
}
```

```go
// Worker pool with mutex queue (faster for some patterns)
func BenchmarkWorkerPoolMutexQueue(b *testing.B) {
    var (
        mu    sync.Mutex
        cond  = sync.NewCond(&mu)
        queue []Job
        closed bool
    )
    const workers = 8
    var wg sync.WaitGroup
    wg.Add(workers)
    for i := 0; i < workers; i++ {
        go func() {
            defer wg.Done()
            for {
                mu.Lock()
                for len(queue) == 0 && !closed { cond.Wait() }
                if len(queue) == 0 && closed { mu.Unlock(); return }
                j := queue[0]
                queue = queue[1:]
                mu.Unlock()
                process(j)
            }
        }()
    }
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        mu.Lock()
        queue = append(queue, Job{})
        mu.Unlock()
        cond.Signal()
    }
    mu.Lock(); closed = true; mu.Unlock()
    cond.Broadcast()
    wg.Wait()
}
```

## Common Antipatterns
1. Counter behind a channel - serializes writes unnecessarily
2. Pub-sub with one channel per subscriber - slow subscriber blocks all publishers
3. Shallow pipelines doing nanoseconds of work

## Profiling
```bash
go test -bench=Counter -cpu=1,4,8 -benchtime=3s
# Look for runtime.chansend and runtime.chanrecv hotspots in pprof
```

Key mental model: "A channel is a queue with park/wake semantics. Use one when the queue is the point; reach for a mutex when the state is the point."
