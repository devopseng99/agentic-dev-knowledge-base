---
title: "One Redis Instance, Three Jobs: DevOps for AI Agents Without the Overkill"
url: "https://dev.to/labontese/one-redis-instance-three-jobs-devops-for-ai-agents-without-the-overkill-gm7"
author: "Daniel Gustafsson"
category: "ai-agent-redis"
---

# One Redis Instance, Three Jobs: DevOps for AI Agents Without the Overkill

**Author:** Daniel Gustafsson
**Published:** March 14, 2026

## Overview
Consolidates typical microservices infrastructure into a single Redis Stack instance paired with Ollama for local LLM inference, replacing separate vector database, message queue, cache service, and state store.

## Key Concepts

### Three Primary Functions
1. **Conversation Memory (Checkpointer)** - LangGraph state persistence via RedisSaver
2. **Long-Term Memory (Vector Index)** - Semantic search via RedisStore with RediSearch
3. **Semantic Cache** - LLM response caching based on vector proximity

## Code Examples

### Docker Compose Configuration
```yaml
services:
  redis:
    image: redis/redis-stack:latest
    ports:
      - "6379:6379"
      - "8001:8001"  # RedisInsight
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

  ollama:
    image: ollama/ollama
    ports:
      - "11434:11434"
    volumes:
      - ollama_models:/root/.ollama
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:11434/api/tags || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 3

volumes:
  redis_data:
  ollama_models:
```

### RedisSaver for Conversation State
```python
with RedisSaver.from_conn_string("redis://localhost:6379") as checkpointer:
    checkpointer.setup()
    agent = create_react_agent(..., checkpointer=checkpointer)
```

### RedisStore with Vector Index
```python
with RedisStore.from_conn_string(
    "redis://localhost:6379",
    index={
        "embed": embeddings,
        "dims": 768,
        "distance_type": "cosine",
        "fields": ["text"],
    },
) as store:
    store.setup()
```

### Semantic Cache
```python
from redisvl.extensions.llmcache import SemanticCache

cache = SemanticCache(
    name="llm_cache",
    redis_url="redis://localhost:6379",
    distance_threshold=0.1,
    ttl=3600,
)
```

### ChatOllama Configuration
```python
model = ChatOllama(
    model="qwen3.5:4b",
    base_url="http://ollama:11434",
)
```

### Model Management
```bash
ollama pull qwen3.5:4b      # 2.5 GB, requires ~4 GB VRAM
ollama pull nomic-embed-text  # 274 MB, for embeddings
```

### Redis Monitoring
```bash
redis-cli INFO memory | grep used_memory_human
redis-cli DBSIZE
redis-cli MONITOR
redis-cli SLOWLOG GET 10
```

### Backup Operations
```bash
redis-cli BGSAVE
cp /data/dump.rdb /backup/redis.rdb
cp /data/appendonly.aof /backup/
```

## Economics
- Cloud-based: ~$0.005 per scan, 200 daily scans = $30/month
- Local Ollama: Fixed hardware cost (~$1,500 for RTX 4070) with unlimited inference

## Production Recommendations
- Set `maxmemory` limits with LRU eviction policies
- TTL strategies: cached responses 1 hour, conversation history 7 days
- Separate Redis instances per environment
- GPU with 8+ GB VRAM for local models
