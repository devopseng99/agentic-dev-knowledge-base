---
title: "Vector Databases Explained: What They Don't Tell You"
url: "https://dev.to/vektor_memory_43f51a32376/vector-databases-explained-what-they-dont-tell-you-1nkg"
author: "Vektor Memory"
category: "agent-memory-vector-database"
---

# Vector Databases Explained: What They Don't Tell You

**Author:** Vektor Memory
**Published:** May 7, 2026

## Overview
Comprehensive guide covering vector math, indexing algorithms (HNSW, IVF, PQ, LSH), real-world use cases, top database comparison, and why vector search alone is insufficient for agent memory. Introduces MAGMA (Multi-layer Associative Graph Memory Architecture) as a four-layer solution beyond cosine similarity.

## Key Concepts

### Embeddings from First Principles

```javascript
const embedding = await openai.embeddings.create({
  model: "text-embedding-3-large",
  input: "What is a vector database?"
});
const vector = embedding.data[0].embedding;
// [0.0023, -0.0187, 0.0441, ... 3072 values]
```

### Indexing Algorithms

- **HNSW** -- Multi-layer graph, sub-linear search time, dominant in production. Used by Qdrant, Weaviate, pgvector, Milvus.
- **IVF** -- Clusters into Voronoi cells, memory-efficient. Best for billions of vectors.
- **PQ** -- Compresses vectors 125x (12KB to ~96 bytes). Combined with IVF for large-scale.
- **LSH** -- Hash-based approximate search. Best for sparse data and deduplication.

### The Gap: Vector Search Is Not Memory

Vector search answers "What is most similar to this query?" but agents need to answer:
- What has changed since I last spoke to this user?
- Is this new fact consistent with what I already know?
- How are these facts related in logical causality (not text similarity)?
- What should I forget because it is stale or contradicted?

### MAGMA: Four-Layer Memory Graph

**Layer 1 -- Semantic:** Standard vector embeddings (cosine similarity entry point)
**Layer 2 -- Causal:** Directed cause-and-effect edges between facts
**Layer 3 -- Temporal:** Timestamps and decay weights; facts lose authority over time
**Layer 4 -- Entity:** Named entities as first-class graph nodes

Every ingestion triggers the AUDN decision: Add, Update, Delete, or None (redundant).

### MAGMA in Practice

```javascript
await vektor.store("User migrated from Pinecone to LanceDB in March", {
  entities: ["user:alex", "tool:pinecone", "tool:lancedb"],
  causal: "cost_reduction",
  temporal: new Date()
});

const memory = await vektor.recall("what vector db is this user running?");
// Returns: LanceDB (March migration) - not Pinecone
// Standard RAG would return both, with no preference
```

### Installation

```bash
npm install -g vektor-slipstream
vektor mcp
```

### Choosing the Right Vector Layer
- **Prototypes:** LanceDB (embedded) or pgvector
- **Production RAG:** Qdrant or Weaviate (self-hosted)
- **Zero infrastructure:** Pinecone (managed)
- **Agent memory:** Need more than vector store -- need contradiction resolution, temporal decay, entity relationships
