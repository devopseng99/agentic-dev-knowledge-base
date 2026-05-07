---
title: "How I Made My Vector Search Engine 16x Faster Without Changing the Algorithm"
url: "https://dev.to/dubeykartikay/how-i-made-my-vector-search-engine-16x-faster-without-changing-the-algorithm-4c8o"
author: "kartikay dubey"
category: "code-optimization"
---
# How I Made My Vector Search Engine 16x Faster Without Changing the Algorithm
**Author:** kartikay dubey  **Published:** May 3, 2026

## Overview
Optimizing a Vamana-based vector search engine (sembed-engine) written in C++, achieving 16x query speedup and 9x build speedup through data layout restructuring rather than algorithmic changes. Recall remained at 1.0 and visited node counts unchanged.

## Key Concepts

### 1. Data Layout Restructuring
Core improvement: replacing object-oriented pointer-based architecture with flat, contiguous arrays.

Original design used pointer chasing; new design enables sequential memory access.

### 2. Eliminated Virtual Dispatch Overhead
Old assembly included virtual method calls. New code uses direct SIMD operations on packed floats.

```asm
; Old: scalar operations with virtual dispatch
call rax
sqrtss xmm2, xmm2

; New: vectorized operations
movups xmm1, XMMWORD PTR [rdi+rax]
subps  xmm1, xmm3
mulps  xmm1, xmm1
```

### 3. Squared Distance Optimization
Replaced Euclidean distance (includes sqrt) with squared distances. If sqrt(25) < sqrt(100), then 25 < 100 - the ordering is identical. Adjusted Vamana's alpha parameter accordingly.

### 4. Cached Scoring During Sort
Precomputed distances once and stored in ScoredNode { node; score; } structures rather than recomputing during sort comparisons.

## Key Code Examples

```cpp
// Original design - pointer chasing
struct Record {
    int64_t id;
    std::shared_ptr<Vector> vector;
};

// New design - flat arrays
// ids    = [id0, id1, id2, ...]
// values = [v0_dim0, v0_dim1, ..., v1_dim0, v1_dim1, ...]
// Vector i accessed at values[i * D] via lightweight FloatVectorView
```

## Performance Results

| Workload | Metric | Before | After | Improvement |
|----------|--------|--------|-------|-------------|
| gvec | query latency (p50) | 4.094 ms | 0.631 ms | ~6.5x |
| w2v | query latency (p50) | 25.15 ms | 1.524 ms | ~16.5x |
| w2v | build time | 17.91 s | 1.889 s | ~9.5x |

## Key Insight
"The speedup came from data layout" rather than algorithmic changes. Reducing CPU cache misses, pointer chasing, and unnecessary computations in the hot path. The CPU cares about memory access patterns, not Big-O notation.
