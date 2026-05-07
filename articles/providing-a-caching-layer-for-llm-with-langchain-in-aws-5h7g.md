---
title: "Providing a caching layer for LLM with Langchain in AWS"
url: "https://dev.to/heuri/providing-a-caching-layer-for-llm-with-langchain-in-aws-5h7g"
author: "Jihun Lim"
category: "llm-agent-caching-redis"
---

# Providing a caching layer for LLM with Langchain in AWS

**Author:** Jihun Lim
**Published:** December 23, 2023

## Overview
Using AWS Redis offerings as a caching layer for LLM applications with Langchain, comparing standard cache vs semantic cache across Redis Stack, ElastiCache, and MemoryDB.

## Key Concepts

### Redis Stack on EC2

```bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
docker run -d --name redis-stack -p 6379:6379 redis/redis-stack:latest
```

### Standard Cache

```python
from langchain.globals import set_llm_cache
from langchain.llms.bedrock import Bedrock
from langchain.cache import RedisCache
from redis import Redis

ec2_redis = "redis://{EC2_Endpoint}:6379"
cache = RedisCache(Redis.from_url(ec2_redis))
llm = Bedrock(model_id="anthropic.claude-v2:1", region_name='us-west-2')
set_llm_cache(cache)
```

Performance: 7.82s -> 97.7ms on cache hit.

### Semantic Cache

```python
from langchain.cache import RedisSemanticCache
from langchain.embeddings import BedrockEmbeddings

bedrock_embeddings = BedrockEmbeddings(model_id="amazon.titan-embed-text-v1", region_name='us-west-2')
set_llm_cache(RedisSemanticCache(redis_url=ec2_redis, embedding=bedrock_embeddings))
```

Performance: 4.6s -> 532ms for semantically similar queries ("Las Vegas" vs "Vegas").

### Compatibility Matrix

| Cache/DB | Redis Stack EC2 | ElastiCache Serverless | MemoryDB | VectorSearch MemoryDB |
|----------|---|---|---|---|
| Standard Cache | Yes | Yes | Yes | Yes |
| Semantic Cache | Yes | No | No | Partial |

ElastiCache and standard MemoryDB lack vector search support.
