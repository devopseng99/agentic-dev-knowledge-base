---
title: "Smarter AI Agents with Caching, Building cache_utiles"
url: "https://dev.to/oar06g/smarter-ai-agents-with-caching-building-cacheutiles-4cc0"
author: "LeoLan"
category: "ai-agent-caching-strategy"
---

# Smarter AI Agents with Caching, Building cache_utiles

**Author:** LeoLan
**Published:** November 13, 2025

## Overview

Introduces cache_utiles, a Python toolkit for optimizing AI agent workflows by caching expensive computations, model loading, embeddings, and repeated API calls.

## Key Concepts

### Three Key Utilities

1. **MemoryCache** -- LRU cache with memory limits (MB) for LLM responses and embeddings
2. **ModelLRUStore** -- Maintains limited loaded model instances, prevents repeated reloading
3. **ResultCache** -- Stores computed results with TTL and LRU eviction strategies

### Usage Example

```python
from cache_utils import MemoryCache

# Create a cache with a 100MB limit
cache = MemoryCache(max_size_mb=100)

# Store responses
cache.set("response:123", {"text": "Hello, world!"})

# Retrieve them later
print(cache.get("response:123"))
# {'text': 'Hello, world!'}

# View cache stats
print(cache.stats())
# {'entries': 1, 'used_MB': 0.01, 'max_MB': 100.0}
```

### Benefits
- Reduce API costs
- Accelerate inference
- Prevent memory leaks
- Thread-safe for concurrent agents
- Easy integration with LangChain and LlamaIndex
