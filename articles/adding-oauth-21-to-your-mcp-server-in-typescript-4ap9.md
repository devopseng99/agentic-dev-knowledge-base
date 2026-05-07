---
title: "Adding OAuth 2.1 to your MCP server in TypeScript"
url: "https://dev.to/thegdsks/adding-oauth-21-to-your-mcp-server-in-typescript-4ap9"
author: "GDS K S"
category: "oauth-mcp"
---

# Adding OAuth 2.1 to your MCP server in TypeScript
**Author:** GDS K S
**Published:** April 29, 2026

## Overview
Tutorial for implementing OAuth 2.1 authentication for Model Context Protocol (MCP) servers using TypeScript and KavachOS authentication library.

## Key Concepts

### Installation

```bash
npm install kavachos @kavachos/hono hono
```

### Initial Configuration

```typescript
import { createKavach } from "kavachos";
import { mcpOAuth } from "kavachos/mcp";
import { createHonoAdapter } from "@kavachos/hono";
import { Hono } from "hono";

const kavach = await createKavach({
  database: { provider: "sqlite", url: "kavach.db" },
  plugins: [
    mcpOAuth({
      issuer: "https://your-mcp-server.com",
      resource: "https://your-mcp-server.com/mcp",
    }),
  ],
});

const app = new Hono();
app.route("/auth", createHonoAdapter(kavach));
```

### MCP Handler with Token Validation

```typescript
import { requireToken } from "kavachos";

app.post(
  "/mcp",
  requireToken({ scope: ["mcp:tools"] }),
  async (c) => {
    const agent = c.get("agent");
    const body = await c.req.json();
    // route the MCP request to your tool implementation
  },
);
```

### Testing

```bash
npm run dev
curl http://localhost:3000/.well-known/oauth-protected-resource
curl -X POST http://localhost:3000/register \
  -H "Content-Type: application/json" \
  -d '{"redirect_uris":["http://localhost:3334/callback"]}'
```

### RFC Standards Covered
- RFC 9728 - Protected Resource Metadata
- RFC 7591 - Dynamic Client Registration
- OAuth 2.1 with PKCE S256
- RFC 8707 - Resource Indicators
