---
title: "From Zero to Local LLM: A Developer's Guide to Docker Model Runner"
url: "https://dev.to/docker/from-zero-to-local-llm-a-developers-guide-to-docker-model-runner-4oi2"
author: "Karan Verma"
category: "llm-agent-docker"
---

# From Zero to Local LLM: A Developer's Guide to Docker Model Runner

**Author:** Karan Verma
**Published:** April 11, 2025

## Overview
Docker Model Runner brings container-native development to local AI workflows. Standardized model access via CLI pulling from Docker Hub, fast inference powered by llama.cpp, OpenAI-compatible APIs, and GPU acceleration for Apple Silicon and NVIDIA GPUs.

## Key Concepts

### Developer Pain Points Solved
- Privacy: data never leaves your machine
- Cost: no paid API expenses
- Setup: standardized CLI-based workflow
- Hardware: works without dedicated GPU
- Model switching: easy swapping via UI and CLI

## Code Examples

### Getting Started

```bash
# Enable Model Runner
docker desktop enable model-runner --port 12434

# Pull a Model
docker model pull ai/smollm2:360M-Q4_K_M

# Run with a Prompt
docker model run ai/smollm2:360M-Q4_K_M "Explain the Doppler effect like I'm five."
```

### OpenAI-Compatible API

```bash
curl http://localhost:12434/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "smollm2", "prompt": "Hello, who are you?", "max_tokens": 100}'
```

### Chat API

```bash
curl http://localhost:12434/engines/llama.cpp/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "ai/smollm2",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Please write 500 words about the fall of Rome."}
    ]
  }'
```

### Docker Compose with Model Runner

```yaml
services:
  chat:
    build: ./chat
    depends_on:
      - ai_runner
    environment:
      - MODEL_URL=${AI_RUNNER_URL}
      - MODEL_NAME=${AI_RUNNER_MODEL}
    ports:
      - "5000:5000"

  ai_runner:
    provider:
      type: model
      options:
        model: ai/smollm2
```

### Advanced Use Cases
- RAG pipelines combining PDFs, vector search, and Model Runner
- Multiple models (phi2, mistral) in separate services
- A/B testing interfaces via Compose
- Edge AI deployments on airgapped systems
