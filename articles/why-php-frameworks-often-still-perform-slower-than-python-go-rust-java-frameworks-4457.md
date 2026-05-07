---
title: "Why PHP frameworks often (still) perform slower than Python / Go / Rust / Java frameworks"
url: "https://dev.to/m-a-h-b-u-b/why-php-frameworks-often-still-perform-slower-than-python-go-rust-java-frameworks-4457"
author: "Md Mahbubur Rahman"
category: "rust-go-java-agents"
---

# Why PHP frameworks often perform slower than Python / Go / Rust / Java frameworks
**Author:** Md Mahbubur Rahman
**Published:** September 29, 2025

## Overview
Examines why PHP shows 10-30x lower throughput vs Go/Rust/Java in TechEmpower benchmarks. Technical reasons: interpreted runtime, process threading vs long-running services, heavy framework abstractions, GC patterns, limited native async I/O. PHP 8.x with Swoole/RoadRunner closes gap significantly.

## Key Concepts
- Compiled stacks (Go/Rust/Java) deliver orders of magnitude higher RPS in microbenchmarks
- In real I/O-bound apps, differences narrow to single/low-double-digit percents
- PHP 8.3 JIT produces measurable gains but doesn't achieve architectural parity
- Recommendation: offload CPU-intensive endpoints to compiled languages
