---
title: "Expose Your App to AI Agents in 30 Minutes: A MCP Integration Pattern"
url: "https://dev.to/yiliuli/expose-your-app-to-ai-agents-in-30-minutes-a-mcp-integration-pattern-55fi"
author: "Aiden Li"
category: "a2a-protocols"
---

# Expose Your App to AI Agents in 30 Minutes: A MCP Integration Pattern
**Author:** Aiden Li
**Published:** May 5, 2026

## Overview
Ageniti framework: define once, expose everywhere. Single action definition generates MCP servers, CLI tools, and OpenAI schemas.

## Key Concepts
Ageniti framework: define once, expose everywhere. Single action definition generates MCP servers, CLI tools, and OpenAI schemas.

```javascript
const searchProducts = action({
  id: 'search-products',
  description: 'Search product catalog by keyword',
  input: z.object({
    query: z.string().describe('Search query'),
    limit: z.number().optional().default(10),
  }),
  handler: async ({ query, limit }) => {
    return await productService.search({ query, limit });
  },
});
```

Handles validation, authorization, timeouts, retries, structured output, and logging through shared runtime.
