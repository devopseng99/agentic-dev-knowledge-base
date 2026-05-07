---
title: "Semantic Caching in RAG Systems & AI Agents"
url: "https://dev.to/sreeni5018/semantic-caching-in-rag-systems-ai-agents-2gal"
author: "Seenivasa Ramadurai"
category: "ai-agent-caching-strategy"
---

# Semantic Caching in RAG Systems & AI Agents

**Author:** Seenivasa Ramadurai
**Published:** March 9, 2026

## Overview

Explores semantic caching as a performance optimization for RAG systems and AI agents. Rather than matching exact strings, converts queries into numerical vectors where similar meanings cluster together. 40% of production queries being near-duplicates means preventable costs.

## Key Concepts

### Three Cache Layers
1. **Query-level caching** -- Intercepts full questions before retrieval
2. **Tool-level caching** -- Caches individual API/database call results
3. **Response-level caching** -- Stores final LLM outputs

### Repository Pattern Design

```python
from abc import ABC, abstractmethod

class CacheRepository(ABC):
    @abstractmethod
    def lookup(self, v_q, threshold=0.92, namespace=None):
        pass

    @abstractmethod
    def insert(self, v_q, response, namespace=None, ttl_hours=None):
        pass

    @abstractmethod
    def invalidate(self, max_age_hours=24):
        pass
```

### Backend Factory Pattern

```python
backend = os.getenv('CACHE_BACKEND', 'qdrant')
if backend == 'qdrant':
    from .qdrant_cache import QdrantCache
    _cache = QdrantCache(...)
elif backend == 'faiss':
    from .faiss_cache import FaissCache
    _cache = FaissCache()
```

### Performance Results
- Query #1 (cold cache): 2.48 seconds
- Query #2 (semantically similar): 0.17 seconds (93% improvement)
- Query #5 (paraphrased): 0.22 seconds (cache hit)

### Critical Safeguards
- Personal, time-sensitive, or entity-specific queries must bypass caching
- PII must never be cached
- Verify answers remain identical regardless of who asks
- Check if responses could change within the TTL window
- Expected cache hit rates should exceed ~15%

### Use Cases
- HR Policy Bot: 60% redundant query elimination for 2,000-person company
- Customer Support: 73% of 50K daily queries fall into 12 categories, achieving 93% latency reduction
