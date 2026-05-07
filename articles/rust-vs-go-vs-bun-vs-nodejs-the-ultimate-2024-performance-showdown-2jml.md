---
title: "Rust vs Go vs Bun vs Node.js: The Ultimate 2024 Performance Showdown"
url: "https://dev.to/hamzakhan/rust-vs-go-vs-bun-vs-nodejs-the-ultimate-2024-performance-showdown-2jml"
author: "Hamza Khan"
category: "rust-go-java-agents"
---

# Rust vs Go vs Bun vs Node.js: The Ultimate 2024 Performance Showdown
**Author:** Hamza Khan
**Published:** October 5, 2024

## Overview
Benchmarks 100,000 concurrent HTTP requests. Rust: 110K RPS / 2.5ms latency / 50MB RAM. Go: 90K RPS / 3ms / 55MB. Bun: 80K RPS / 4ms / 60MB. Node.js: 45K RPS / 8ms / 100MB. Rust achieves highest throughput and lowest latency via zero-GC memory control.

## Key Concepts

```rust
use hyper::{Body, Request, Response, Server};
async fn handle(_: Request<Body>) -> Result<Response<Body>, hyper::Error> {
    Ok(Response::new(Body::from(r#"{"message": "Hello from Rust"}"#)))
}
```

```go
func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, `{"message": "Hello from Go"}`)
}
```

| Technology | RPS | Latency | Memory |
|------------|-----|---------|--------|
| Rust | 110,000 | 2.5 ms | 50 MB |
| Go | 90,000 | 3.0 ms | 55 MB |
| Bun | 80,000 | 4.0 ms | 60 MB |
| Node.js | 45,000 | 8.0 ms | 100 MB |
