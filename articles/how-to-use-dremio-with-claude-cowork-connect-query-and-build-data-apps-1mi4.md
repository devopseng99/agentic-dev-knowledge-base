---
title: "How to Use Dremio with Claude CoWork: Connect, Query, and Build Data Apps"
url: "https://dev.to/alexmercedcoder/how-to-use-dremio-with-claude-cowork-connect-query-and-build-data-apps-1mi4"
author: "Alex Merced"
category: "a2a-protocols"
---

# Dremio with Claude CoWork
**Author:** Alex Merced
**Published:** March 6, 2026

## Overview
Claude CoWork as autonomous desktop assistant querying Dremio's lakehouse platform for data projects.

## Key Concepts

```json
{
  "mcpServers": {
    "dremio": {
      "command": "uv",
      "args": ["run", "--directory", "/path/to/dremio-mcp",
               "dremio-mcp-server", "run"]
    }
  }
}
```

Environment: `DREMIO_PAT=<token>`, `DREMIO_PROJECT_ID=<id>`. Start with MCP connector for fastest setup.
