---
title: "Build an MCP Server for PostgreSQL: Query Your Database with Claude & Any AI Client"
url: "https://dev.to/sergiocolqueponce/build-an-mcp-server-for-postgresql-query-your-database-with-claude-any-ai-client-5m6"
author: "Sergio Alberto Colque Ponce"
category: "claude-mcp-server"
---

# Build an MCP Server for PostgreSQL: Query Your Database with Claude & Any AI Client

**Author:** Sergio Alberto Colque Ponce
**Published:** December 3, 2025

## Overview

Comprehensive guide to building a production-ready MCP server in TypeScript that bridges AI applications with PostgreSQL databases. Grants Claude and other MCP clients direct database query access through predefined, secure tools.

## Key Concepts

### Project Setup

```bash
mkdir mcp-postgres-server
cd mcp-postgres-server
npm init -y
npm install @modelcontextprotocol/sdk pg dotenv
npm install -D typescript @types/node @types/pg
```

### Database Service

```typescript
import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export class DatabaseService {
  async queryUsers(): Promise<any[]> {
    const result = await pool.query(
      'SELECT id, name, email FROM users LIMIT 10'
    );
    return result.rows;
  }

  async queryIncidents(status: string): Promise<any[]> {
    const result = await pool.query(
      'SELECT id, title, status, severity FROM incidents WHERE status = $1 ORDER BY created_at DESC',
      [status]
    );
    return result.rows;
  }

  async getStats(): Promise<any> {
    const result = await pool.query(`
      SELECT
        COUNT(*) as total_incidents,
        SUM(CASE WHEN severity = 'critical' THEN 1 ELSE 0 END) as critical_count,
        SUM(CASE WHEN status = 'open' THEN 1 ELSE 0 END) as open_count
      FROM incidents
    `);
    return result.rows[0];
  }
}
```

### MCP Server Implementation

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { CallToolRequestSchema, ListToolsRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { DatabaseService } from './database.js';

const server = new Server({
  name: 'postgres-mcp-server',
  version: '1.0.0',
});

const db = new DatabaseService();

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: 'get_users',
      description: 'Retrieve recent users from the database',
      inputSchema: { type: 'object', properties: {}, required: [] },
    },
    {
      name: 'get_open_incidents',
      description: 'Get all open incidents sorted by date',
      inputSchema: { type: 'object', properties: {}, required: [] },
    },
    {
      name: 'get_database_stats',
      description: 'Get incident statistics (total, critical, open)',
      inputSchema: { type: 'object', properties: {}, required: [] },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name } = request.params;
  try {
    if (name === 'get_users') {
      const users = await db.queryUsers();
      return { content: [{ type: 'text', text: JSON.stringify(users, null, 2) }] };
    }
    if (name === 'get_open_incidents') {
      const incidents = await db.queryIncidents('open');
      return { content: [{ type: 'text', text: JSON.stringify(incidents, null, 2) }] };
    }
    if (name === 'get_database_stats') {
      const stats = await db.getStats();
      return { content: [{ type: 'text', text: JSON.stringify(stats, null, 2) }] };
    }
    return { content: [{ type: 'text', text: `Unknown tool: ${name}` }], isError: true };
  } catch (error) {
    return { content: [{ type: 'text', text: `Error: ${error instanceof Error ? error.message : String(error)}` }], isError: true };
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('PostgreSQL MCP Server running on stdio');
}

main().catch(console.error);
```

### Claude Desktop Integration

```json
{
  "mcpServers": {
    "postgres": {
      "command": "node",
      "args": ["/absolute/path/to/dist/server.js"],
      "env": {
        "DATABASE_URL": "postgresql://user:password@localhost:5432/mydb"
      }
    }
  }
}
```

### Deployment Options

**Google Cloud Run:**
```bash
gcloud run deploy mcp-postgres \
  --source . \
  --set-env-vars DATABASE_URL=your_connection_string
```

**Docker:**
```bash
docker build -t mcp-postgres .
docker run -e DATABASE_URL=your_url mcp-postgres
```

### Production Best Practices

- Connection pooling via pg Pool
- Parameterized queries with placeholder syntax
- Comprehensive error handling
- Input validation before database operations
- Query logging and response time monitoring
- Rate limiting for high-volume scenarios
