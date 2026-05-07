---
title: "Speed Test: Python Vs Rust"
url: "https://dev.to/bekbrace/speed-test-python-vs-rust-1mk4"
author: "Bek Brace"
category: "rust-go-java-agents"
---

# Speed Test: Python Vs Rust
**Author:** Bek Brace
**Published:** March 11, 2024

## Overview
Simple speed comparison counting to 200 million. Rust offers better performance due to low-level control, memory safety, and zero-cost abstractions. Compiled nature enables faster execution vs Python's interpreted approach.

## Key Concepts

```rust
use std::time::Instant;
fn main() {
    let start = Instant::now();
    let count = (0..200_000_000).count();
    let duration = start.elapsed();
    println!("Count: {}", count);
    println!("Time taken: {} seconds", duration.as_secs());
}
```

```python
import time
start = time.time()
count = sum(1 for _ in range(200_000_000))
duration = time.time() - start
print("Count:", count)
print("Time taken: {:.6f} seconds".format(duration))
```
