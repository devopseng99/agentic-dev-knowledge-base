---
title: "GO vs RUST speed test | Which one to choose in 2024"
url: "https://dev.to/mukeshkuiry/go-vs-rust-speed-test-which-one-to-choose-in-2024-1ck"
author: "Mukesh Kuiry"
category: "rust-go-java-agents"
---

# GO vs RUST speed test
**Author:** Mukesh Kuiry
**Published:** January 2, 2024

## Overview
Compares Go (simplicity, goroutines) vs Rust (memory safety, ownership). Stack Overflow 2023: 84.66% admire Rust vs 62.45% Go. Speed test printing 1M numbers: Go 240s vs Rust 314s (I/O bound, not representative of compute). Go for beginners; Rust for advanced control.

## Key Concepts

```go
func main() {
    startTime := time.Now()
    for i := 1; i <= 1000000; i++ { fmt.Println(i) }
    duration := time.Since(startTime)
    fmt.Println("Execution time:", duration)
}
```

```rust
fn main() {
    let start_time = Instant::now();
    for i in 1..=1000000 { println!("{}", i); }
    let duration = start_time.elapsed();
    println!("Execution time: {:?}", duration);
}
```
