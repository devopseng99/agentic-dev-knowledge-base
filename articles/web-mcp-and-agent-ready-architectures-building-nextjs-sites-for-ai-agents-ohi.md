---
title: "Web MCP and Agent-Ready Architectures: Building Next.js Sites for AI Agents"
url: "https://dev.to/mericcintosun/web-mcp-and-agent-ready-architectures-building-nextjs-sites-for-ai-agents-ohi"
author: "Meric Cintosun"
category: "ai-agent-nextjs-react"
---

# Web MCP and Agent-Ready Architectures: Building Next.js Sites for AI Agents

**Author:** Meric Cintosun
**Published:** April 6, 2026

## Overview

Comprehensive guide on using Model Context Protocol (MCP) with Next.js to create web interfaces optimized for AI agent interaction. Covers manifest serving, semantic HTML, action endpoints, and agent-readable component patterns.

## Key Concepts

### Web MCP Architecture Components
1. **Capability Manifest** -- JSON at `/.well-known/mcp.json` describing available actions
2. **Action Endpoints** -- HTTP endpoints agents invoke for structured operations
3. **Annotated HTML Interface** -- Semantic markup with fallback reading regions

### Why Semantic HTML Matters for Agents
- A `<button>` element carries implicit ARIA role; a styled `<div class="btn">` does not
- Landmark elements (`<main>`, `<article>`, `<nav>`, `<section>`) help agents navigate structure
- Proper `<label for="...">` associations communicate form constraints without submission

### Action Endpoints in Next.js

Actions organized under `/app/api/mcp/` with Zod validation:

```typescript
// TypeScript contracts for MCP actions
interface MCPAction<TInput, TOutput> {
  name: string;
  description: string;
  inputSchema: TInput;
  outputSchema: TOutput;
}

interface ProductSearchInput {
  query: string;
  category?: string;
  maxResults?: number;
}

interface ProductSearchOutput {
  results: Product[];
  totalCount: number;
}
```

### Serving the Manifest

```typescript
// app/.well-known/mcp.json/route.ts
export async function GET() {
  const manifest = generateManifest();
  return new Response(JSON.stringify(manifest), {
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'public, max-age=3600',
      'Access-Control-Allow-Origin': '*', // CORS for cross-origin agents
    },
  });
}
```

### Semantic Components for Agent Readability

Components use `data-mcp-region` attributes for stable element selection, `<data value="...">` elements for machine-readable numeric values, and ARIA attributes to establish relationships.

### Forms as Agent Interaction Points
Forms use `<form role="search">`, `<label htmlFor="...">` paired with input `id` attributes, `aria-label` for form identification, and `data-mcp-form` for agent-specific targeting.

### Project Setup
```bash
npx create-next-app@latest --typescript --tailwind --app my-mcp-app
```

Directory structure separates MCP logic under `/app/api/mcp/` with utilities in `/lib/mcp-*.ts`.
