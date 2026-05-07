---
title: "I Built 9 MCP Servers with 49 AI Tools on Cloudflare Workers -- Here's What I Learned"
url: "https://dev.to/yedanyagamiaicmd/i-built-9-mcp-servers-with-49-ai-tools-on-cloudflare-workers-heres-what-i-learned-3ii4"
author: "YedanYagami"
category: "ai-agent-cloudflare-workers"
---

# I Built 9 MCP Servers with 49 AI Tools on Cloudflare Workers

**Author:** YedanYagami
**Published:** March 11, 2026

## Overview
Nine production MCP servers with 49 tools running on Cloudflare Workers, enabling AI assistants like Claude Code, Cursor, and Windsurf to access external tools via the Model Context Protocol. Cost: $0-5/month on Workers paid plan.

## Key Concepts

### The 9 Servers
- JSON Toolkit (6 tools): Validate, format, diff, query, transform, schema generation
- Regex Engine (5 tools): Test, explain, build, replace, extract
- Color Palette (5 tools): Convert, harmonies, WCAG contrast, Tailwind lookup
- Timestamp (5 tools): Unix/ISO convert, timezone, cron parse, duration format
- Prompt Enhancer (5 tools): Optimize, score, rewrite, system prompt generator
- Intel (5 tools): AI market intelligence, GitHub trends, tool comparison
- MoltBook (5 tools): Markdown to HTML, SEO meta, translation, outlines
- AgentForge (5 tools): Side-by-side AI model comparison

### Three Key Learnings
1. **Quality Over Quantity:** Three polished servers would have been more impactful than nine adequate ones
2. **Rate Limiting Priority:** Bots overwhelmed the system within hours of launch without rate limiting
3. **Landing Pages Drive Adoption:** Individual landing pages generated more signups than README files

## Code Examples

### MCP Server Architecture

```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === '/' && request.method === 'GET') {
      return new Response(landingHTML(), {
        headers: { 'Content-Type': 'text/html' }
      });
    }

    if (url.pathname === '/mcp' && request.method === 'POST') {
      const body = await request.json();
      const { method, id, params } = body;

      switch (method) {
        case 'initialize':
          return mcpResponse(id, {
            protocolVersion: '2025-03-26',
            capabilities: { tools: {} },
            serverInfo: { name: 'my-server', version: '1.0.0' },
          });
        case 'tools/list':
          return mcpResponse(id, { tools: TOOLS });
        case 'tools/call':
          return handleToolCall(id, params, env);
      }
    }
  }
};
```

### Client Configuration

```json
{
  "mcpServers": {
    "json-toolkit": {
      "url": "https://json-toolkit-mcp.yagami8095.workers.dev/mcp"
    }
  }
}
```

### Technical Stack
- Runtime: Cloudflare Workers (V8 isolates, <50ms cold start)
- Storage: D1 (SQLite), KV (key-value), Vectorize (vector search)
- Protocol: MCP 2025-03-26 over JSON-RPC 2.0
- Authentication: API key via "Authorization: Bearer" header
- Deployment: Wrangler CLI (~3 seconds per deployment)
