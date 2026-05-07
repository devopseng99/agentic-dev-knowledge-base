---
title: "How to Use Dremio with Claude Code: Connect, Query, and Build Data Apps"
url: "https://dev.to/alexmercedcoder/how-to-use-dremio-with-claude-code-connect-query-and-build-data-apps-538i"
author: "Alex Merced"
category: "a2a-protocols"
---

# Dremio with Claude Code
**Author:** Alex Merced
**Published:** March 6, 2026

## Overview
Four approaches to connect Claude Code to Dremio's lakehouse: MCP server, CLAUDE.md context, pre-built skills, and custom skills.

## Key Concepts

```json
{
  "mcpServers": {
    "dremio": {
      "url": "https://YOUR_PROJECT_MCP_URL",
      "auth": {
        "type": "oauth",
        "clientId": "YOUR_CLIENT_ID"
      }
    }
  }
}
```

Start with MCP server (5-min setup), layer context files as usage matures.
