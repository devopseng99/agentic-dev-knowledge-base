---
title: "How to Build an AI Agent that Builds Full-Stack Apps"
url: "https://dev.to/tidbcommunity/how-to-build-an-ai-agent-that-builds-full-stack-apps-5c1d"
author: "Hao Huo"
category: "full-code-examples"
---

# How to Build an AI Agent that Builds Full-Stack Apps
**Author:** Hao Huo (PingCAP/TiDB Community)
**Published:** January 6, 2026

## Overview
Open-source starter kit for building AI agents that generate complete full-stack applications from natural language prompts. Integrates TiDB Cloud branching for database versioning alongside code generation.

## Key Concepts

### GitHub Repository
https://github.com/pingcap/full-stack-app-builder-ai-agent

### Architecture Components
- Codex (GPT-5.1) or Claude Code for reasoning and code generation
- TiDB Cloud as central database with branching capability
- Kysely for type-safe SQL operations
- Vercel for deployment
- GitHub for version control

### TiDB Cloud Branch Creation

```javascript
import fetch from "node-fetch";

const SERVERLESS_API_BASE = "https://serverless.tidbapi.com/v1beta1";

async function createBranch(clusterId, newBranchName, publicKey, privateKey) {
  const url = `${SERVERLESS_API_BASE}/clusters/${clusterId}/branches`;
  const body = JSON.stringify({ displayName: newBranchName });

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization:
        "Basic " + Buffer.from(`${publicKey}:${privateKey}`).toString("base64"),
    },
    body,
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`Failed to create branch: ${response.status} ${text}`);
  }

  const data = await response.json();
  return data.branchId;
}

createBranch(
  "1234567890",
  "new-feature-branch",
  process.env.TIDB_CLOUD_PUBLIC_KEY,
  process.env.TIDB_CLOUD_PRIVATE_KEY
)
  .then((branchId) => console.log("Branch created:", branchId))
  .catch(console.error);
```

### Kysely Migration File

```typescript
import type { Kysely } from "kysely";

export async function up(db: Kysely<any>) {
  await db.schema
    .alterTable("todo_list")
    .addColumn("username", "varchar(255)", (col) => col.notNull().defaultTo(""))
    .execute();
}

export async function down(db: Kysely<any>) {
  await db.schema
    .alterTable("todo_list")
    .dropColumn("username")
    .execute();
}
```

### Key Innovations
- Git + TiDB Branch Synchronization for code-data consistency
- Reversible migrations with both "up" and "down"
- Scale-to-zero economics for ephemeral development environments
