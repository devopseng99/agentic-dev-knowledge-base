---
title: "How run LLM in local using Docker"
url: "https://dev.to/coder_dragon/how-run-llm-in-local-using-docker-i2b"
author: "Shivam"
category: "llm-agent-docker"
---

# How run LLM in local using Docker

**Author:** Shivam
**Published:** April 27, 2025

## Overview
Docker Model Runner makes running AI models as simple as running a container locally with a single command. Uses llama.cpp and provides OpenAI-compatible API. Requires Docker Desktop 4.40+.

## Key Concepts

### Benefits of Self-Hosted LLMs
- Improved performance
- Lower costs
- Better data privacy
- No standard way existed before Docker Model Runner

## Code Examples

### Pull a Model

```bash
docker model pull ai/llama3.1
```

### Access from Other Containers

```bash
curl http://model-runner.docker.internal/engines/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "ai/llama3.1",
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Please write 500 words about the fall of Rome."}
        ]
    }'
```

### Enable TCP Host Access

```bash
docker desktop enable model-runner --tcp 12434
```

### Access from Host Machine

```bash
curl http://localhost:12434/engines/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "ai/llama3.1",
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Please write 500 words about the fall of Rome."}
        ]
    }'
```
