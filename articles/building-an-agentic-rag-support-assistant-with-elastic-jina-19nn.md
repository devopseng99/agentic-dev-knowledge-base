---
title: "Building an Agentic RAG Support Assistant with Elastic & Jina"
url: "https://dev.to/d2anubis/building-an-agentic-rag-support-assistant-with-elastic-jina-19nn"
author: "Niharika"
category: "agentic-rag"
---

# Building an Agentic RAG Support Assistant with Elastic & Jina

**Author:** Niharika
**Published:** February 28, 2026

## Overview
Builds an agentic RAG support assistant using Elasticsearch (KNN vector search), Jina (embeddings + reranking), and Ollama (local LLM). Achieves sub-2-second response times replacing 20-minute manual doc searches.

## Key Concepts

### Pipeline
Query -> Jina Embed -> Elasticsearch (KNN) -> Jina Rerank -> Ollama -> Answer

Reranking is critical: vector search casts a wide net (20 candidates), Jina's cross-encoder narrows to top 5. Without reranking, irrelevant articles sneak in and the LLM parrots wrong content.

## Code Examples

### Elasticsearch KNN Search

```python
es.search(
    index="support-kb",
    knn={"field": "content_embedding", "query_vector": qvec, "k": 20, "num_candidates": 100}
)
```

### Environment Setup

```
ELASTIC_CLOUD_ID=your-deployment:dXMt...
ELASTIC_API_KEY=your-api-key
JINA_API_KEY=jina_xxxxxxxxxxxx
```

### Run the Pipeline

```bash
pip install -r requirements.txt
python -m src.ingest   # once, to index the sample KB
python -m src.main "Why is my dashboard showing stale data?"
```

### Core RAG Pipeline

```python
def ask(query):
    passages = search_and_rerank(query)  # Elastic KNN + Jina rerank
    if not passages:
        return "No relevant docs found.", []
    answer = generate_answer(query, passages)  # Ollama or fallback
    return answer, passages
```
