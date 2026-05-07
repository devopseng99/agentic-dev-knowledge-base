---
title: "How I gave my AI Agent long-term memory (without the vector DB headache)"
url: "https://dev.to/the_nortern_dev/how-i-gave-my-ai-agent-long-term-memory-without-the-vector-db-headache-4c00"
author: "NorthernDev"
category: "agent-memory-vector-database"
---

# How I gave my AI Agent long-term memory (without the vector DB headache)

**Author:** NorthernDev
**Published:** November 26, 2025

## Overview
MemVault -- an open-source API (Node.js/TypeScript, PostgreSQL with pgvector) that abstracts vector database complexity for AI agent memory. Features hybrid search combining semantic similarity, recency, and importance scoring.

## Key Concepts

### Architecture
- **Backend:** Node.js & Express (TypeScript)
- **Database:** PostgreSQL with pgvector extension (via Prisma ORM)
- **Embeddings:** OpenAI text-embedding-3-small (512 dimensions)
- **Validation:** Zod

### Hybrid Search Algorithm
Weights three factors directly in SQL:
- **Semantic Similarity:** How close is the meaning?
- **Recency:** Time-decayed scoring (recent memories rank higher)
- **Importance:** Content-based scoring (text with money, dates, proper nouns gets a boost)

### Store a Memory

```javascript
const { storeMemory } = require('memvault-sdk-jakops88');

await storeMemory({
  sessionId: "user-123",
  text: "The user prefers dark mode and writes in Python.",
  metadata: { source: "onboarding_chat" }
});
```

### Retrieve Context

```javascript
const { retrieveMemories } = require('memvault-sdk-jakops88');

const context = await retrieveMemories({
  sessionId: "user-123",
  query: "What coding language should I use for the snippet?",
  limit: 1
});

console.log(context[0].text);
// Output: "The user prefers dark mode and writes in Python."
```

### Install SDK

```bash
npm install memvault-sdk-jakops88
```
