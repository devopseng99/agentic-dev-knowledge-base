---
title: "How to Implement LLM Grounding using Retrieval Augmented Generation Technique (RAG)"
url: "https://dev.to/eyitayoitalt/how-to-implement-llm-grounding-using-retrieval-augmented-generation-techniquerag-1m2p"
author: "Eyitayo Itunu Babatope"
category: "llm-eval-alignment"
---
# How to Implement LLM Grounding using Retrieval Augmented Generation Technique (RAG)
**Author:** Eyitayo Itunu Babatope  **Published:** December 5, 2025

## Overview
Grounding is when Large Language Models use domain-specific information and data to generate accurate and relevant output. The RAG technique retrieves relevant information based on a query, merges it with the prompt into the LLM context window, and generates relevant output. This dramatically reduces hallucinations.

## Key Concepts

### LLM Grounding Techniques
1. **Retrieval-Augmented Generation (RAG)** — Dynamic retrieval at query time
2. **Fine-tuning** — Embedding domain knowledge into model weights

### Embeddings: The Foundation of RAG
Embeddings convert data into vectors — long arrays of numbers representing semantic meaning.

**OpenAI models:**
- text-embedding-3-small (1536 dimensions)
- text-embedding-3-large (3072 dimensions)
- text-embedding-ada-002 (1536 dimensions)

**Ollama models:**
- nomic-embed-text (768 dimensions)
- mxbai-embed-large (1024 dimensions)
- all-minilm (384 dimensions)

### Code Examples

**OpenAI embeddings:**

```python
from openai import OpenAI

client = OpenAI()

embedding = client.embeddings.create(
    model="text-embedding-3-small",
    input="Grounding Improves LLM output.",
    encoding_format="float",
)
print(embedding)
```

**Ollama embeddings:**

```python
import ollama
response = ollama.embed(model="nomic-embed-text", prompt="Grounding Improves LLM output")
```

**Response generation with context (OpenAI):**

```python
from openai import OpenAI

client = OpenAI()

response = client.responses.create(
    model="gpt-5-nano",
    input=f"You are an assistant, use this data {data} to answer this input {prompt}"
)

print(response.output_text)
```

**Response generation with context (Ollama):**

```python
import ollama

output = ollama.generate(
    model="llama2", prompt=f"Use this data: {data} to respond to this prompt: {input}"
)

print(output)
```

### Use Cases
1. Customer Service and Support (Q&A Chatbots)
2. Legal Research (case law and statutes retrieval)
3. Content creation and research
4. Code Assistant (error troubleshooting)
5. Medical Assistant (patient insights)

### Benefits
Grounding improves LLM output by reducing hallucinations while increasing accuracy. RAG provides dynamic, current context without requiring model retraining.
