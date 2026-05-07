---
title: "I Built an AI Chatbot Wrong (And What I Learned About Cloudflare's AI Search)"
url: "https://dev.to/dannwaneri/i-built-an-ai-chatbot-wrong-and-what-i-learned-about-cloudflares-ai-search-feo"
author: "Daniel Nwaneri"
category: "cloudflare-vectorize"
---

# I Built an AI Chatbot Wrong (And What I Learned About Cloudflare's AI Search)
**Author:** Daniel Nwaneri
**Published:** November 26, 2025

## Overview
Over-engineered a RAG chatbot in 4 hours when Cloudflare's AI Search feature could do it in 15 minutes. Comparison of manual RAG vs AI Search approaches.

## Key Concepts

### Manual RAG (4 hours)
```javascript
export default {
  async fetch(request, env) {
    const embedding = await env.AI.run('@cf/baai/bge-base-en-v1.5', { text: [product.text] });
    await env.VECTORIZE_INDEX.insert([{
      id: product.id, values: embedding.data[0],
      metadata: { text: product.text }
    }]);
  }
};
```

### AI Search (15 minutes)
```javascript
export default {
  async fetch(request, env) {
    const { query } = await request.json();
    const response = await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
      messages: [{ role: "user", content: query }],
      search: { index_name: "wellness-products" }
    });
    return Response.json(response);
  }
};
```

### When to Use Each
- Manual RAG: Specific LLM needs, complex retrieval logic, compliance requirements
- AI Search: Simple Q&A, fast development, Workers AI sufficient
