---
title: "33,000 lines of XML to tell you heavyWork() is slow: how I tamed xctrace for LLMs"
url: "https://dev.to/frr149/33000-lines-of-xml-to-tell-you-heavywork-is-slow-how-i-tamed-xctrace-for-llms-28bd"
author: "Fernando Rodriguez"
category: "code-optimization"
---
# 33,000 lines of XML to tell you heavyWork() is slow: how I tamed xctrace for LLMs
**Author:** Fernando Rodriguez  **Published:** April 30, 2026

## Overview
xctrace export generates massive XML files (33,553 lines for a simple two-function program) that overwhelm LLM context windows. Created ztrace, a Python tool that transforms verbose trace data into compact, actionable summaries. Central thesis: "LLMs are bad at processing raw data at scale. They're good at reasoning about processed, compact data."

## Key Concepts

### The Core Problem
Standard xctrace exports include exhaustive details: "3,044 individual samples, memory addresses, UUIDs, timestamps" but developers only need high-level bottleneck identification.

### Why XML is Actually Appropriate
Hierarchical structure suits backtrace trees, self-describing elements aid clarity, and the id/ref system elegantly deduplicates frame definitions.

### ztrace's Approach
1. Extracts metadata using `xctrace export --toc`
2. Parses the time-profile table with XPath
3. Resolves the id/ref system to reconstruct complete frame information
4. Filters system frames (OS/Swift runtime code)
5. Aggregates by function and generates summaries

### Filtering Strategy
- Removes /usr/lib/ and /System/ binaries
- Excludes runtime internals like __swift_instantiateConcreteTypeFromMangledNameV2
- Retains only user-written code

## Key Code Examples

```bash
# Basic usage
ztrace summary sample.trace
```

```
# Sample Output - 13 lines vs 33,553
Process: hotspot  Duration: 3.8s  Template: Time Profiler
Samples: 3044  Total CPU: 3044ms

SELF TIME
   69.4%    2113ms  hotspot  heavyWork()
   29.7%     905ms  hotspot  lightWork()

TOTAL TIME (callers with significant overhead)
   99.9%    3041ms  main

CALL STACKS
   69.4%    2113ms  main > heavyWork()
   29.7%     904ms  main > lightWork()
```

```
# Real-World Example (Ghostty terminal)
Process: ghostty  Duration: 3.8s  Template: Time Profiler
Samples: 295  Total CPU: 295ms

SELF TIME
   53.2%     157ms  ghostty  main
    3.7%      11ms  ghostty  renderer.metal.RenderPass.begin
    3.1%       9ms  ghostty  renderer.generic.Renderer.rebuildCells
    2.7%       8ms  ghostty  renderer.generic.Renderer.drawFrame
```

```markdown
# Integration via CLAUDE.md
### Profiling (xctrace)

- Use `ztrace summary <file.trace>` to read traces.
- Flow: `xctrace record` -> `ztrace summary`
- Flags: `--threshold 0.5` (more functions), `--depth 10` (deeper stacks)
```

```bash
# Recommended workflow
# 1. Record
xctrace record --template 'Time Profiler' --time-limit 5s --launch -- .build/debug/MyApp

# 2. Summarize (13 lines instead of 33,000)
ztrace summary MyApp.trace

# 3. Feed compact output to LLM for analysis
```

## Implementation Details
- Language: Python (not Swift) due to superior XML parsing and easier distribution via `uv tool install`
- Key: The id/ref system parsing is critical - without it, most frame context is lost
- GitHub: github.com/frr149/ztrace

## Planned Features (v0.1+)
- ztrace record command for integrated recording and summarization
- Configurable filters and call stack depth
- Trace comparison (before/after optimization diffs)
- Memory allocation profiling support
