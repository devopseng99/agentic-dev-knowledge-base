---
title: "Same API in Java, Go, Rust, and Kotlin -- a 4-language benchmark"
url: "https://dev.to/netfishx/same-api-in-java-go-rust-and-kotlin-a-4-language-benchmark-2fn6"
author: "netfishx"
category: "rust-go-java-agents"
---

# Same API in Java, Go, Rust, and Kotlin -- a 4-language benchmark
**Author:** netfishx
**Published:** March 19, 2026

## Overview
Short-video platform backend rebuilt in 4 languages. Rust: 210K QPS, 33MB peak RAM, p50 0.70ms. Go: 100K QPS, fastest cold start (69ms). Kotlin: 99K QPS (within 1% of Go with JVM 21 Virtual Threads). Java: 88K QPS. Team chose Rust for halved infrastructure costs.

## Key Concepts

| Metric | Rust | Go | Kotlin | Java |
|--------|------|-----|--------|------|
| QPS | 210K | 100K | 99K | 88K |
| p50 latency | 0.70ms | 1.20ms | 1.25ms | 1.50ms |
| Peak memory | 33MB | 120MB | 650MB | 580MB |
| Cold start | 153ms | 69ms | 2.1s | 2.8s |
| Build time | 98.3s | 3.2s | 12.1s | 5.6s |
| LOC | 4,179 | 5,412 | 8,607 | 7,893 |
