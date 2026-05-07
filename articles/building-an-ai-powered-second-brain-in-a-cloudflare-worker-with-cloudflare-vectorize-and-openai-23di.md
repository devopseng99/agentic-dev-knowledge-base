---
title: "Creating a Smart Second Brain: Leveraging Cloudflare Workers, Vectorize, and OpenAI"
url: "https://dev.to/andyjessop/building-an-ai-powered-second-brain-in-a-cloudflare-worker-with-cloudflare-vectorize-and-openai-23di"
author: "Andy Jessop"
category: "cloudflare-vectorize"
---

# Creating a Smart Second Brain: Leveraging Cloudflare Workers, Vectorize, and OpenAI
**Author:** Andy Jessop
**Published:** December 9, 2023

## Overview
AI-powered personal knowledge management using Cloudflare Workers, Vectorize, OpenAI embeddings (text-embedding-ada-002), and KV storage for contextually-aware semantic search.

## Key Concepts

### Core Implementation

```typescript
import OpenAI from "openai";

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const openai = new OpenAI({ apiKey: env.OPENAI_API_KEY });

    if (request.url.endsWith('/vectors/query') && request.method === 'POST') {
      const { model = 'gpt-3.5-turbo-1106', query } = await request.json();
      const embedding = await openai.embeddings.create({
        encoding_format: 'float', input: query, model: 'text-embedding-ada-002',
      });
      const vector = embedding?.data?.[0].embedding;
      const similar = await env.VECTORIZE_INDEX.query(vector, {
        topK: 10, returnMetadata: true,
      });
      const context = similar.matches.map((match) =>
        `\nSimilarity: ${match.score}\nContent:\n${match.vector.metadata.content}\n`
      ).join('\n\n');
      const chatCompletion = await openai.chat.completions.create({
        model,
        messages: [{ role: 'user', content: `You are my second brain...\n${context}\nQuestion: ${query}` }],
      });
      return new Response(JSON.stringify({ response: chatCompletion.choices[0].message }));
    }
  },
};
```

### Text Splitting
Uses Langchain's RecursiveCharacterTextSplitter with 1536-character chunks and 200-character overlap.

### Update Management
KV Store tracks embedding IDs by filename for clean deletion of outdated vectors before re-indexing.
