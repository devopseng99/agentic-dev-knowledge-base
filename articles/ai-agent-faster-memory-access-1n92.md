---
title: "AI Agent Faster Memory Access"
url: "https://dev.to/emiroberti/ai-agent-faster-memory-access-1n92"
author: "Emiliano Roberti"
category: "ai-agent-redis"
---

# AI Agent Faster Memory Access

**Author:** Emiliano Roberti
**Published:** May 21, 2025

## Overview
Explores using Redis as high-performance memory storage for AI agents with LangChain integration. Redis operations complete in under one millisecond, enabling instantaneous memory retrieval for real-time decision-making.

## Key Concepts
- Redis in-memory data structure store for sub-millisecond access
- RediSearch module for vector similarity search (semantic memory)
- RDB snapshots and AOF for persistence
- Redis Streams for multi-agent coordination
- Redis Cluster for horizontal scaling

## Code Examples

### Main CLI Entry Point (TypeScript)
```typescript
import readline from "readline";
import { client } from "./redisClient";
import { chain } from "./langchain";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function askQuestion(query: string): Promise<string> {
  return new Promise((resolve) => rl.question(query, resolve));
}

async function main() {
  while (true) {
    const prompt = await askQuestion("> ");
    if (prompt.toLowerCase() === "exit") break;

    const response = await chain.invoke({ input: prompt });
    console.log(response);

    const timestamp = new Date().toISOString();
    await client.hSet(timestamp, {
      prompt,
      response: response.toString(),
    });
  }

  rl.close();
  await client.quit();
}

main();
```

### Redis Client (TypeScript)
```typescript
import { createClient } from "redis";

export const client = createClient();

client.on("error", (err) => {
  console.error("Redis Client Error", err);
});

await client.connect();
```

### LangChain Setup (TypeScript)
```typescript
import { ChatOpenAI } from "langchain/chat_models/openai";
import { ConversationChain } from "langchain/chains";
import { BufferMemory } from "langchain/memory";

export const chain = new ConversationChain({
  llm: new ChatOpenAI({
    temperature: 0.7,
    modelName: "gpt-4",
  }),
  memory: new BufferMemory(),
});
```

### Quick Start
```bash
git clone git@github.com:EmiRoberti77/ts-redis-langchain-chat.git
cd redis-langchain-ts
npm install
redis-server
npx tsx src/index.ts
```

### Redis Commands
```bash
redis-cli keys "*"
hgetall "2025-04-04T05:53:27.956Z"
redis-cli FLUSHALL
```
