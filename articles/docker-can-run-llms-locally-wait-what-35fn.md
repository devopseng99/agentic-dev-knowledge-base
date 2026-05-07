---
title: "Docker Can Run LLMs Locally. Wait, What!?"
url: "https://dev.to/pradumnasaraf/docker-can-run-llms-locally-wait-what-35fn"
author: "Pradumna Saraf"
category: "llm-agent-docker"
---

# Docker Can Run LLMs Locally. Wait, What!?

**Author:** Pradumna Saraf
**Published:** April 7, 2025

## Overview
Docker Model Runner enables running LLMs locally on Apple Silicon Macs with Metal GPU acceleration. Models stored as OCI artifacts (not bundled in images), exposed via OpenAI-compatible API on localhost:12434. Currently in Beta.

## Key Concepts

### Benefits
- Runs llama.cpp natively with Apple Metal GPU access
- OCI artifacts save disk space vs bundled images
- No cloud APIs, no rate limiting, no latency, no cost
- Familiar Docker CLI pattern

## Code Examples

### CLI Usage

```bash
docker model pull ai/llama3.2
docker model run ai/llama3.2
```

### API from Inside Containers

```shell
curl http://model-runner.docker.internal/engines/llama.cpp/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "ai/llama3.2",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Please write 100 words about Docker Compose."}
    ]
  }'
```

### API from Host Machine

```shell
curl http://localhost:12434/engines/llama.cpp/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "ai/llama3.2",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Please write 100 words about Docker Compose."}
    ]
  }'
```

### Available Endpoints
```
GET  /engines/llama.cpp/v1/models
GET  /engines/llama.cpp/v1/models/{namespace}/{name}
POST /engines/llama.cpp/v1/chat/completions
POST /engines/llama.cpp/v1/completions
POST /engines/llama.cpp/v1/embeddings
```
