---
title: "Latency Slayer: a Redis 8 semantic cache gateway that makes LLMs feel instant"
url: "https://dev.to/mohit_agnihotri_5/latency-slayer-a-redis-8-semantic-cache-gateway-that-makes-llms-feel-instant-2klh"
author: "Mohit Agnihotri"
category: "llm-agent-caching-redis"
---

# Latency Slayer: a Redis 8 semantic cache gateway

**Author:** Mohit Agnihotri
**Published:** August 10, 2025

## Overview
Rust-based reverse proxy leveraging Redis 8's vector search for semantic caching of LLM API calls with per-field TTL, HNSW vectors, and real-time analytics via Redis Streams.

## Key Concepts

### Technical Architecture
- Redis Query Engine with HNSW vectors using COSINE similarity
- Hash field expiration for granular cache control
- Redis Streams for hit rate and latency tracking
- 1536-dimensional embeddings (OpenAI text-embedding-3-small)

### Why Redis 8
- Field-level expiration on hashes
- INT8 vector support for memory efficiency
- Streams for observability infrastructure

### Future Plans
- Predictive prefetching
- Hybrid filtering (vectors + metadata tags)
- Cohort-based threshold tuning
- INT8 vector quantization

**Repository:** GitHub mohitagnihotri/latency_slayer
