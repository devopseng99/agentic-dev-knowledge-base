---
title: "Building Scalable Multi-Modal AI Agents with Strands Agents and Amazon S3 Vectors"
url: "https://dev.to/aws/building-scalable-multi-modal-ai-agents-with-strands-agents-and-amazon-s3-vectors-575b"
author: "Elizabeth Fuentes L"
category: "multi-modal-agent-vision"
---

# Building Scalable Multi-Modal AI Agents with Strands Agents and Amazon S3 Vectors

**Author:** Elizabeth Fuentes L
**Published:** September 8, 2025

## Overview

Part 3 of a series on multi-modal AI agent development. Demonstrates transitioning from local FAISS memory to cloud-based Amazon S3 Vectors for production-scale persistent memory with the Strands Agent framework.

## Key Concepts

### Model Setup (Python)

```python
model = BedrockModel(
    model_id="us.anthropic.claude-3-5-sonnet-20241022-v2:0",
    region="us-east-1"
)
```

### Agent Tools

- `s3_vector_memory` (persistent storage)
- `image_reader` (visual content)
- `file_read` (document processing)
- `video_reader` (video analysis)
- `use_llm` (reasoning capabilities)

### S3 Vectors Capabilities

- Large-scale vector storage per index
- Fully managed service with automatic optimization
- AWS IAM integration for user isolation
- Built-in disaster recovery across regions
- Support for Cosine and Euclidean distance metrics

### Memory Operations

1. `store()` - Persist conversations and insights
2. `retrieve()` - Query contextual information
3. `list()` - Enumerate stored memories with metadata
4. `auto_store_and_retrieve()` - Intelligent context handling
5. `auto_context()` - Maintain conversation continuity

### Practical Workflows

- **User Context Storage:** Capturing preferences like "work early in the morning, prefer Italian coffee"
- **Image Analysis:** Processing architectural diagrams with automatic memory persistence
- **Document Summarization:** Converting PDF content to JSON format for future retrieval

### Production Applications

- AI agent memory systems
- Retrieval-augmented generation (RAG)
- Semantic search capabilities
- Personalized recommendation engines
