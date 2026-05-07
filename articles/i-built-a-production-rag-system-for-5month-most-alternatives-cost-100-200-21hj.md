---
title: "I Built a Production RAG System for $5/month"
url: "https://dev.to/dannwaneri/i-built-a-production-rag-system-for-5month-most-alternatives-cost-100-200-21hj"
author: "Daniel Nwaneri"
category: "cloudflare-vectorize"
---

# I Built a Production RAG System for $5/month
**Author:** Daniel Nwaneri
**Published:** December 24, 2025

## Overview
Cost-effective semantic search using Cloudflare Workers AI (bge-small-en-v1.5, 384 dimensions) and Vectorize with HNSW indexing. $8-10/month vs $130-190/month traditional stack.

## Key Concepts

### Search Implementation
```typescript
async function searchIndex(query: string, topK: number, env: Env) {
  const startTime = Date.now();
  const embeddingStart = Date.now();
  const embedding = await env.AI.run("@cf/baai/bge-small-en-v1.5", { text: query });
  const embeddingTime = Date.now() - embeddingStart;
  const searchStart = Date.now();
  const results = await env.VECTORIZE.query(embedding, { topK, returnMetadata: true });
  const searchTime = Date.now() - searchStart;
  return {
    query, results: results.matches,
    performance: {
      embeddingTime: `${embeddingTime}ms`, searchTime: `${searchTime}ms`,
      totalTime: `${Date.now() - startTime}ms`
    }
  };
}
```

### Performance (from Nigeria)
- Embedding generation: 142ms
- Vector search: 223ms
- Total: 365ms (6-10x faster than enterprise implementations)

**Repository:** https://github.com/dannwaneri/vectorize-mcp-worker
