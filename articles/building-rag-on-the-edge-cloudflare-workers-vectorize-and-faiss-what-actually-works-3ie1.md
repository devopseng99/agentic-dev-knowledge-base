---
title: "Building RAG on the Edge: Cloudflare Workers, Vectorize, and FAISS - What Actually Works"
url: "https://dev.to/karol_81a50ed396508bcffd7/building-rag-on-the-edge-cloudflare-workers-vectorize-and-faiss-what-actually-works-3ie1"
author: "Karol"
category: "cloudflare-vectorize"
---

# Building RAG on the Edge: Cloudflare Workers, Vectorize, and FAISS
**Author:** Karol
**Published:** January 7, 2026

## Overview
Technical postmortem of edge RAG system. Vectorize queries: 200-400ms. Local FAISS: under 5ms. Conclusion: edge computing works for lightweight inference, not RAG.

## Key Concepts

### Problem: Worker Execution Timeout
```python
# Works locally. Fails at the edge (30-second CPU timeout).
def embed_document(text: str):
    model = SentenceTransformer('all-MiniLM-L6-v2')
    embeddings = model.encode(text, show_progress_bar=True)  # 5-15 seconds per doc
    return embeddings
```

### Local RAG Wins
```python
from sentence_transformers import SentenceTransformer
import faiss
import numpy as np

model = SentenceTransformer('all-MiniLM-L6-v2')
documents = ["doc1", "doc2", "doc3"]
embeddings = np.array([model.encode(doc) for doc in documents])
index = faiss.IndexFlatL2(embeddings.shape[1])
index.add(embeddings)
query_embedding = model.encode("user question")
distances, indices = index.search(np.array([query_embedding]), k=5)
```

### Conclusions
- Cloudflare Workers + Vectorize: Simple stateless queries with >1s latency tolerance
- Local RAG: Sub-200ms retrieval, reranking, intensive inference
- Edge computing actual use cases: Lightweight inference for classification and routing
