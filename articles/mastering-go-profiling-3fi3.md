---
title: "Mastering Go Profiling"
url: "https://dev.to/vplatonov/mastering-go-profiling-3fi3"
author: "Vladyslav Platonov"
category: "code-optimization"
---
# Mastering Go Profiling
**Author:** Vladyslav Platonov  **Published:** November 17, 2025

## Overview
A comprehensive guide to Go's built-in profiling tool pprof, which helps developers understand CPU usage, memory allocation, goroutine behavior, and synchronization bottlenecks. Key takeaway: "Measure, don't guess - profile first."

## Key Concepts

### Profile Types

| Profile Type | Purpose | Use Case |
|---|---|---|
| CPU | Execution time | High CPU load, slow processing |
| Heap | Memory usage | Memory leaks, OOM errors |
| Goroutine | Concurrency snapshot | Deadlocks, goroutine leaks |
| Block | Waiting time | Latency, thread stalls |
| Mutex | Lock contention | Poor scalability |
| Allocs | Allocation frequency | GC pressure analysis |

### How pprof Works
- CPU: samples stack traces at ~100 Hz intervals
- Memory (heap): records allocation data from garbage collector
- Block/Mutex: tracks synchronization delays
- Goroutine: captures snapshots of running goroutines

### Reading Results
- flat: time inside function (excluding callees)
- cum: total time including callees
- Red nodes in flame graph = highest resource consumption
- Node width = time/memory weight

## Key Code Examples

```go
// Enable HTTP profiling (two lines)
import (
    "net/http"
    _ "net/http/pprof"
)

func main() {
    go func() {
        http.ListenAndServe("localhost:6060", nil)
    }()
    // your app logic
}
```

```bash
# Access profiling endpoint
http://localhost:6060/debug/pprof/

# CPU Profile Collection (30 seconds)
go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30

# Analyze profile
go tool pprof cpu.pprof
(pprof) top
(pprof) web
```

```go
// Record CPU Profile to File
f, _ := os.Create("cpu.pprof")
pprof.StartCPUProfile(f)
defer pprof.StopCPUProfile()
workload()
```

```go
// Enable Block Profiling
runtime.SetBlockProfileRate(1)

// Enable Mutex Profiling
runtime.SetMutexProfileFraction(1)
```

```bash
# Heap Profile
go tool pprof http://localhost:6060/debug/pprof/heap

# Goroutine Profile (Text Format)
curl http://localhost:6060/debug/pprof/goroutine?debug=2

# Compare Profiles Before/After Optimization
go tool pprof -diff_base heap1.pprof heap2.pprof
```

## Production Best Practices
- Restrict access to /debug/pprof/ endpoints
- Avoid running CPU profiling continuously (~5-10% overhead)
- Maintain CPU profiles for 10-30+ seconds for accuracy
- Heap profiles are safe for production collection
- Use sampling rates: SetBlockProfileRate(10000) for production
- Visualization tools: pprof, Speedscope, or Parca

## Practical Tips
1. Start with widest blocks at the bottom (highest resource consumption)
2. Ignore runtime internals unless abnormal
3. Look for repeating narrow peaks (inefficient loop work)
4. For hanging apps with low CPU, check block/mutex profiles
5. Use diffing to compare optimization results
