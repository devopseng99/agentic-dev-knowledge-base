---
title: "Reading Algorithms Like an Engineer: What DiskANN Taught Me About Pseudocode"
url: "https://dev.to/dubeykartikay/reading-algorithms-like-an-engineer-what-diskann-taught-me-about-pseudocode-2979"
author: "kartikay dubey"
category: "code-optimization"
---
# Reading Algorithms Like an Engineer: What DiskANN Taught Me About Pseudocode
**Author:** kartikay dubey  **Published:** May 3, 2026

## Overview
Chronicles implementing the Vamana algorithm from the DiskANN paper for approximate nearest neighbor search. Initial implementation: 22.98ms per query vs 0.27ms for brute force. After optimization: 0.02ms and 5.34x throughput over brute force with 1.0 recall. Academic pseudocode abstraction doesn't directly translate to efficient data structures.

## Key Concepts

### The Core Problem
Academic pseudocode uses abstract notations like sets L, V, and Nout(p) that don't specify actual implementation details. "A set is not a data structure" - choosing the wrong concrete implementation undermines algorithmic efficiency.

### Critical Decisions Required
- Candidate list L: sorted vector vs heap vs bounded priority queue?
- Visited set V: hash table vs bitset vs boolean array?
- Removal semantics: physical deletion vs logical marking?

### The Solution
Reorganize implementations around the algorithm's actual invariants rather than copying pseudocode literally.

Key changes:
- Replaced generic sets with `Neighbour` struct (distance, node ID, deletion marker)
- Implemented `SortedBoundedVector` for candidate management with built-in deduplication
- Switched visited tracking to `boost::dynamic_bitset` for faster membership checks
- Changed pruning from physical deletion to marker-based bookkeeping

## Results

| Metric | Before | After |
|--------|--------|-------|
| Query latency (small fixtures) | 22.98 ms | 0.02 ms |
| Throughput vs brute force | 0.04x | 5.34x |
| Recall | 1.0 | 1.0 |

## Key Lesson
Examine the "nouns" in pseudocode carefully. For each abstraction, determine its actual operations and constraints to select appropriate data structures.

The choice between std::unordered_set and boost::dynamic_bitset for the visited set V makes a 14.7x difference at n=500,000 - purely based on memory access patterns, not algorithmic complexity.
