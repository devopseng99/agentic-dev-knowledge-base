---
title: "Rust vs. Go: The benchmark"
url: "https://dev.to/zanepearton/building-a-simple-web-server-rust-vs-go-om5"
author: "Zane"
category: "rust-go-java-agents"
---

# Rust vs. Go: The benchmark
**Author:** Zane
**Published:** January 17, 2024

## Overview
HTTP web server benchmark using WRK. Rust (actix-web) debug: 15K RPS, release: 18.8K RPS. Go (net/http): 36K RPS. Go initially outperforms, but reader comments show Rust with --release flag and proper tuning achieves comparable or superior results. Server configuration and optimization levels matter significantly.

## Key Concepts

```rust
use actix_web::{web, App, HttpServer, HttpResponse, Responder};
async fn root_handler() -> impl Responder {
    HttpResponse::Ok().body("Hello, World!")
}
```

```go
func rootHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprint(w, "Hello, World!")
}
```

| Mode | Rust Debug | Rust Release | Go |
|------|-----------|-------------|-----|
| RPS | 15,004 | 18,839 | 36,022 |
| Latency | 7.36ms | 6.41ms | 3.12ms |
