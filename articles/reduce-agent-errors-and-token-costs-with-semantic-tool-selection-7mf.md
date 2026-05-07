---
title: "Reduce Agent Errors and Token Costs with Semantic Tool Selection"
url: "https://dev.to/aws/reduce-agent-errors-and-token-costs-with-semantic-tool-selection-7mf"
author: "Elizabeth Fuentes L"
category: "agent-token-optimization"
---

# Reduce Agent Errors and Token Costs with Semantic Tool Selection

**Author:** Elizabeth Fuentes L
**Published:** March 4, 2026

## Overview
When agents have many similar tools, semantic filtering reduces tool sets from 29 to 3, achieving 82% token reduction while maintaining 92% accuracy. Production systems report 89% token reduction.

## Key Concepts

### FAISS Vector Index

```python
import faiss
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')
index = faiss.IndexFlatL2(embeddings.shape[1])
```

### Tool Registration

```python
def build_index(tools):
    texts = [f"{t.__name__}: {t.__doc__}" for t in tools]
    embeddings = model.encode(texts)
    index.add(embeddings.astype('float32'))
    return index
```

### Semantic Search

```python
def search_tools(query: str, top_k: int = 3):
    emb = model.encode([query])
    _, indices = index.search(emb.astype('float32'), top_k)
    return [tools[i] for i in indices[0]]
```

### Runtime Tool Swapping (Strands Agents)

```python
def swap_tools(agent, new_tools):
    reg = agent.tool_registry
    reg.registry.clear()
    reg.dynamic_tools.clear()
    for t in new_tools:
        reg.register_tool(t)
```

### Results

| Approach | Avg Tokens/Query | Accuracy |
|----------|-----------------|----------|
| All 29 Tools | 1,557 | 92% |
| Top-3 Filtered | 275 | 92% |

Agent messages preserved across tool swaps - conversation history remains intact.
