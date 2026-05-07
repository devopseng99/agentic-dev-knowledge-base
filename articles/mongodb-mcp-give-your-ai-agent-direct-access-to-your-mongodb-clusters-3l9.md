---
title: "MongoDB MCP: Give Your AI Agent Direct Access to Your MongoDB Clusters"
url: "https://dev.to/curatedmcp/mongodb-mcp-give-your-ai-agent-direct-access-to-your-mongodb-clusters-3l9"
author: "curatedmcp"
category: "ai-agent-database-query"
---

# MongoDB MCP: Give Your AI Agent Direct Access to Your MongoDB Clusters

**Author:** curatedmcp (sam_curatedmcp)
**Published:** April 27, 2026

## Overview
MongoDB's official MCP server enabling Claude, Cursor, and other AI agents to query, inspect, and modify MongoDB Atlas clusters and local instances directly with full CRUD operations.

## Key Concepts

### Capabilities
- Query documents with filters and aggregations
- Inspect collections and indexes
- Create and update records
- Manage cluster configuration
- Performance monitoring and slow query detection
- Atlas search integration
- Change stream support

### Installation
```bash
npx -y @mongodb/mcp
```

### Claude Desktop Configuration
```json
{
  "mcpServers": {
    "mongodb-mcp": {
      "command": "npx -y @mongodb/mcp"
    }
  }
}
```

### Use Cases
- **Data migration and cleanup:** Find and transform legacy documents, execute updates
- **Schema exploration:** Query data patterns, discover edge cases, get indexing suggestions
- **Debugging production:** Query slow logs, inspect problematic documents, get fix suggestions

Free and officially maintained by MongoDB.
