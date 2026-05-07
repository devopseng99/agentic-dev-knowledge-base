---
title: "Stop Burning Money: Implementing Semantic Caching for LLMs with Redis & Cosine Similarity"
url: "https://dev.to/roiting_hacking_4d8d76800/stop-burning-money-implementing-semantic-caching-for-llms-with-redis-cosine-similarity-53a5"
author: "roiting hacking"
category: "llm-agent-caching-redis"
---

# Stop Burning Money: Implementing Semantic Caching for LLMs with Redis & Cosine Similarity

**Author:** roiting hacking
**Published:** November 25, 2025

## Overview
Production-grade semantic cache using Python, Redis (VSS), and Sentence Transformers. On 10,000 customer support queries: 62% hit rate, costs cut from $30 to $11, latency from 2.1s to 45ms on hits.

## Key Concepts

### Complete Implementation

```python
from sentence_transformers import SentenceTransformer
import numpy as np

model = SentenceTransformer('all-MiniLM-L6-v2')

def get_embedding(text: str) -> np.ndarray:
    embedding = model.encode(text)
    return embedding.astype(np.float32).tobytes()

import redis
from redis.commands.search.field import VectorField, TextField
from redis.commands.search.indexDefinition import IndexDefinition, IndexType

r = redis.Redis(host='localhost', port=6379, decode_responses=False)
INDEX_NAME = "llm_cache_idx"
VECTOR_DIM = 384

def create_index():
    try:
        r.ft(INDEX_NAME).info()
    except:
        schema = (
            TextField("response"),
            VectorField("embedding", "HNSW", {
                "TYPE": "FLOAT32",
                "DIM": VECTOR_DIM,
                "DISTANCE_METRIC": "COSINE"
            })
        )
        definition = IndexDefinition(prefix=["cache:"], index_type=IndexType.HASH)
        r.ft(INDEX_NAME).create_index(schema, definition=definition)

from redis.commands.search.query import Query

def semantic_search(user_query: str, threshold: float = 0.1):
    query_vector = get_embedding(user_query)
    q = Query(f"(@embedding:[VECTOR_RANGE {threshold} $blob])=>{{$yield_distance_as: score}}")\
        .return_fields("response", "score")\
        .sort_by("score")\
        .dialect(2)
    params = {"blob": query_vector}
    results = r.ft(INDEX_NAME).search(q, query_params=params)
    if results.docs:
        return results.docs[0].response
    return None

def cache_response(user_query: str, llm_response: str):
    embedding = get_embedding(user_query)
    key = f"cache:{hash(user_query)}"
    r.hset(key, mapping={"embedding": embedding, "response": llm_response})
    r.expire(key, 86400)
```

### Benchmark Results

| Metric | Without Cache | With Semantic Cache |
|--------|---------------|-------------------|
| API Calls | 10,000 | 3,800 (62% hit rate) |
| Cost | ~$30 | ~$11 |
| Avg Latency | 2.1 seconds | 45ms (on hits) |

### Key Recommendations
- Use local embeddings (all-MiniLM-L6-v2: 80MB, runs on CPU in milliseconds)
- Consider hybrid caching: O(1) exact + O(log n) vector search
- Set TTL on cache entries (24h default)
