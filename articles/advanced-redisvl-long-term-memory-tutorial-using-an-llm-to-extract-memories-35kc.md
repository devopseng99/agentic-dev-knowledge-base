---
title: "Advanced RedisVL Long-term Memory Tutorial: Using an LLM to Extract Memories"
url: "https://dev.to/qtalen/advanced-redisvl-long-term-memory-tutorial-using-an-llm-to-extract-memories-35kc"
author: "Peng Qian"
category: "llm-agent-caching-redis"
---

# Advanced RedisVL Long-term Memory Tutorial

**Author:** Peng Qian
**Published:** February 10, 2026

## Overview
Solving agent long-term memory without context explosion by using an LLM to extract only valuable information before persisting to RedisVL. Previous approach of storing everything failed due to irrelevant semantic search results.

## Key Concepts

### What to Store
- User preferences and communication patterns
- Stable personal details (role, timezone, habits)
- Goals and explicit decisions
- Project context and stakeholders
- Repeated pain points

### What to Exclude
- LLM answers (change with context)
- One-time trivial information
- Sensitive personal data
- Duplicate information

### Architecture
1. Semantic search for related existing memories
2. Extraction agent evaluates and stores valuable info
3. Context injection adds retrieved memories to chat history

### Performance Optimization
Using `asyncio.create_task()` to run memory extraction concurrently with main conversation eliminates latency penalty (was >1s per turn).
