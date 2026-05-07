---
title: "Long Term Memory for LLMs using Vector Store - A Practical Approach with n8n and Qdrant"
url: "https://dev.to/einarcesar/long-term-memory-for-llms-using-vector-store-a-practical-approach-with-n8n-and-qdrant-2ha7"
author: "Einar Cesar"
category: "agent-memory-vector-database"
---

# Long Term Memory for LLMs using Vector Store - A Practical Approach with n8n and Qdrant

**Author:** Einar Cesar
**Published:** July 29, 2025

## Overview
Build a working long-term memory system for LLMs using n8n (workflow automation), OpenAI (LLM and embeddings), Qdrant (vector database), and Cohere (reranking). The system provides virtually unlimited memory capacity, allowing AI to remember conversations from weeks or months ago while reducing token consumption by 60-80%.

## Key Concepts

### Architecture
1. **Memory Retrieval System** - Before responding, agent searches vector database for relevant historical context
2. **Memory Storage System** - After each interaction, conversation is vectorized and stored

### Qdrant Setup with Docker Compose

```yaml
services:
  qdrant:
    image: "qdrant/qdrant:latest"
    environment:
      - SERVICE_FQDN_QDRANT_6333
      - "QDRANT__SERVICE__API_KEY=${SERVICE_PASSWORD_QDRANTAPIKEY}"
    volumes:
      - "qdrant-storage:/qdrant/storage"
    ports:
      - "6333:6333"
      - "6334:6334"
    healthcheck:
      test:
        - CMD-SHELL
        - "bash -c ':> /dev/tcp/127.0.0.1/6333' || exit 1"
      interval: 5s
      timeout: 5s
      retries: 3
volumes:
  qdrant-storage:
```

### AI Agent RAG Memory Tool Configuration

```json
{
  "mode": "retrieve-as-tool",
  "toolName": "RAG_MEMORY",
  "toolDescription": "Agent's long term memory as RAG",
  "qdrantCollection": "ltm",
  "topK": 20,
  "useReranker": true
}
```

### System Prompt for Memory Protocol

```
# AI Agent with RAG_MEMORY System

You are an AI assistant that uses RAG_MEMORY retrieval instead of working memory.

## Core Protocol
**Before every response:**
1. Query RAG_MEMORY for relevant context
2. Analyze retrieved information
3. Base your response on this context

## Key Principles
- Never store information in session memory
- Always retrieve context via RAG_MEMORY
- Be transparent about context retrieval
- Maintain consistency with retrieved information
```

### Benefits
- True long-term memory (unlimited capacity)
- Cost efficiency (60-80% token reduction)
- Improved accuracy (decisions based on actual historical data)
- Scalability (Qdrant handles millions of stored interactions)

### Limitations
- Multi-user scalability requires user-specific collections or metadata filtering
- No active forgetting mechanism (needs time-based expiration)
- Retrieval quality depends on embedding model and chunk size optimization
- Adds 200-500ms latency per query
