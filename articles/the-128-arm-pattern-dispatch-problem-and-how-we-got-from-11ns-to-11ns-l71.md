---
title: "The 128-arm Pattern Dispatch Problem: From 11ns to 1.1ns"
url: "https://dev.to/byebyyanogawa/the-128-arm-pattern-dispatch-problem-and-how-we-got-from-11ns-to-11ns-l71"
author: "sentomk"
category: "code-optimization"
---
# The 128-arm Pattern Dispatch Problem: From 11ns to 1.1ns
**Author:** sentomk  **Published:** May 3, 2026

## Overview
A performance optimization for pattern matching in C++ that achieved a 10x improvement by changing a single type trait condition. The original library constructed 128 case objects per match call, resulting in 11ns latency. The fix reduced this to 1.1ns, matching hand-written switch statement performance.

## Key Concepts

### The Core Problem
Pattern matching syntax constructs all 128 case objects every call, even though case values are compile-time constants.

### Root Cause: `[[no_unique_address]]` and Compiler Variance
The library used `std::is_empty()` to identify cacheable patterns. GCC does not apply `[[no_unique_address]]` to non-base-class members, even for empty types. The pattern failed the std::is_empty check across compilers, preventing dispatch table construction.

### The Fix: `sizeof <= 1`
Rather than checking for theoretical emptiness, use empirical hardware constraints. One byte is the smallest addressable hardware unit - this works across GCC, Clang, and MSVC regardless of attribute rule differences.

"The entire improvement came from a type trait that was answering the wrong question." std::is_empty addresses abstract type theory; sizeof <= 1 answers the engineering question.

## Key Code Examples

```cpp
// The problem - constructs 128 case objects every call
return match(x) | on(
    lit(0) >> handle_0,
    lit(1) >> handle_1,
    // ... 126 more arms
    _ >> default_handler
);
```

```cpp
// First attempt: std::is_constant_evaluated() - only helped for constexpr call sites
template <typename Plan, typename Subject, typename CasesTuple>
constexpr auto dispatch(Subject& subject, CasesTuple&& cases) {
    if (std::is_constant_evaluated()) {
        return static_dispatch<Plan>(subject, std::forward<CasesTuple>(cases));
    }
    return runtime_dispatch<Plan>(subject, std::forward<CasesTuple>(cases));
}
```

```cpp
// Problem code - is_empty fails across compilers
template <auto V, typename Cmp = std::equal_to<>>
struct static_literal_pattern {
    static constexpr auto value = V;
    [[no_unique_address]] Cmp cmp{};  // GCC doesn't apply attribute to non-base members
};
```

```cpp
// THE FIX: sizeof <= 1 instead of is_empty
template <typename T>
constexpr bool is_cacheable_pattern_v = sizeof(T) <= 1;  // Works on all compilers!

// Runtime O(1) lookup
if (subject >= min_value && subject <= max_value) {
    auto idx = case_index_table[subject - min_value];
    if (idx != k_invalid_case_index) {
        return invoke_handler(std::get<idx>(cases), subject);
    }
}
return otherwise_handler(subject);
```

## Performance Results

Benchmark: Intel i7-13700K, GCC 13.2, -O3 -march=native, 128 literal arms, random input

| Approach | Latency | vs. Switch |
|----------|---------|-----------|
| Original on() | 10.79 ns | 9.9x slower |
| Manual static macro | 1.16 ns | 1.06x slower |
| Auto-cache (fix) | 1.13 ns | 1.04x slower |
| Hand-written switch | 1.09 ns | baseline |

The 0.04ns gap to hand-written switch comes from unavoidable branch predictor mispredicts on bounds checking.

## Key Design Insight
"The entire improvement came from a type trait that was answering the wrong question." Match the question to the engineering context, not the theoretical one.
