---
title: "Build AI Agents Locally and Access Them Anywhere with Langflow"
url: "https://dev.to/lightningdev123/build-ai-agents-locally-and-access-them-anywhere-with-langflow-1nof"
author: "Lightning Developer"
category: "langflow-agent"
---

# Build AI Agents Locally and Access Them Anywhere with Langflow

**Author:** Lightning Developer
**Published:** March 17, 2026

## Overview

Comprehensive guide to installing Langflow locally, building AI agents with the visual canvas, and making them remotely accessible via tunneling. Covers installation methods, Docker Compose with PostgreSQL persistence, local inference with Ollama, and API usage.

## Key Concepts

### Installation Options

**Option 1: Using uv**
```shell
pip install uv
uv pip install langflow
uv run langflow run
```

**Option 2: Using pip**
```shell
pip install langflow
langflow run
```

**Option 3: Using Docker**
```docker
docker run -p 7860:7860 langflowai/langflow:latest
```

### Docker Compose with PostgreSQL Persistence

```yaml
services:
  langflow:
    image: langflowai/langflow:latest
    pull_policy: always
    ports:
      - "7860:7860"
    depends_on:
      - postgres
    env_file:
      - .env
    environment:
      - LANGFLOW_DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
      - LANGFLOW_CONFIG_DIR=/app/langflow
    volumes:
      - langflow-data:/app/langflow

  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - langflow-postgres:/var/lib/postgresql/data

volumes:
  langflow-postgres:
  langflow-data:
```

**.env file:**
```properties
POSTGRES_USER=langflow
POSTGRES_PASSWORD=changeme
POSTGRES_DB=langflow
LANGFLOW_SUPERUSER=admin
LANGFLOW_SUPERUSER_PASSWORD=changeme
LANGFLOW_AUTO_LOGIN=False
```

### Remote Access via Tunneling

```shell
ssh -p 443 -R0:localhost:7860 free.pinggy.io
```

With basic authentication:
```shell
ssh -p 443 -R0:localhost:7860 -t free.pinggy.io b:username:password
```

### Local Inference with Ollama

```shell
ollama pull llama3.2
ollama serve
```

Connect Langflow to `http://localhost:11434` to eliminate external API dependencies.

### Using Flows as APIs

```shell
curl -X POST \
  "http://localhost:7860/api/v1/run/<your-flow-id>" \
  -H "Content-Type: application/json" \
  -d '{"input_value": "What does the document say about pricing?"}'
```

### RAG Workflow

1. Upload document
2. Split into chunks
3. Convert chunks to embeddings
4. Store in vector database
5. Retrieve relevant pieces during queries
6. Combine with questions
7. Generate final answers
