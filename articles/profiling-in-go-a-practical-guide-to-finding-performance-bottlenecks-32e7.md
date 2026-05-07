---
title: "Profiling in Go: A Practical Guide to Finding Performance Bottlenecks"
url: "https://dev.to/seyedahmaddv/profiling-in-go-a-practical-guide-to-finding-performance-bottlenecks-32e7"
author: "Seyed Ahmad"
category: "code-optimization"
---
# Profiling in Go: A Practical Guide to Finding Performance Bottlenecks
**Author:** Seyed Ahmad  **Published:** August 26, 2025

## Overview
Introduction to Go's built-in profiling capabilities for identifying performance bottlenecks. "Profiling is the process of analyzing the runtime behavior of your Go program" to determine where CPU and memory resources are consumed most heavily.

## Key Concepts

### What Profiling Reveals
- Where programs spend most execution time
- Which functions consume the most CPU or memory
- How resources like goroutines and mutexes are utilized

### Built-in Tools
1. runtime/pprof - Programmatic profile collection
2. net/http/pprof - HTTP-based profiling for long-running applications
3. Test flags - Profiling during automated tests

### Profile Types
- CPU Profile (execution time distribution)
- Heap Profile (memory allocations and leaks)
- Goroutine Profile (active goroutines and stacks)
- Block Profile (goroutine blocking points)
- Mutex Profile (contention issues)

## Key Code Examples

```go
// CPU Profile with runtime/pprof
package main

import (
    "log"
    "os"
    "runtime/pprof"
)

func main() {
    f, err := os.Create("cpu.prof")
    if err != nil { log.Fatal(err) }
    defer f.Close()

    if err := pprof.StartCPUProfile(f); err != nil { log.Fatal(err) }
    defer pprof.StopCPUProfile()

    // Your workload
    for i := 0; i < 1000000; i++ { _ = i * i }
}
```

```go
// HTTP-based profiling with net/http/pprof
package main

import (
    "log"
    "net/http"
    _ "net/http/pprof"
)

func main() {
    log.Println(http.ListenAndServe("localhost:6060", nil))
}
```

```bash
# Test profiling
go test -cpuprofile=cpu.out -memprofile=mem.out ./...

# Analysis
go tool pprof cpu.prof
go tool pprof -http=:8080 cpu.prof
```

## The go tool pprof Analysis Tool
Provides call graphs, flame graphs, and detailed cost analysis with web-based visualization options. Key commands:
- top: shows functions by CPU time
- web: generates interactive call graph
- list funcName: shows annotated source
