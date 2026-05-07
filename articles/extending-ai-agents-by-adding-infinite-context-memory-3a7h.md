---
title: "Extending AI Agents by Adding Infinite Context Memory"
url: "https://dev.to/einarcesar/extending-ai-agents-by-adding-infinite-context-memory-3a7h"
author: "Einar Cesar"
category: "llm-agent-context-window"
---

# Extending AI Agents by Adding Infinite Context Memory

**Author:** Einar Cesar
**Published:** September 17, 2025

## Overview
Using Neo4j graph databases as persistent memory for AI agents, breaking through context window limitations via MCP servers.

## Key Concepts

### Running Neo4j

```shell
docker run -d -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/password --name neo4j-instance neo4j
```

### MCP Server Configuration (.mcp.json)

```json
{
  "mcpServers": {
    "neo4j-memory": {
      "command": "npx",
      "args": ["@knowall-ai/mcp-neo4j-agent-memory"],
      "env": {
        "NEO4J_URI": "bolt://localhost:7687",
        "NEO4J_USERNAME": "neo4j",
        "NEO4J_PASSWORD": "password",
        "NEO4J_DATABASE": "neo4j"
      }
    }
  }
}
```

### Verification

```shell
claude mcp list
# neo4j-memory: npx @knowall-ai/mcp-neo4j-agent-memory - ✓ Connected
```

Graph databases offer advantages over vector storage: they don't depend on AI embedding models and provide faster data handling.
