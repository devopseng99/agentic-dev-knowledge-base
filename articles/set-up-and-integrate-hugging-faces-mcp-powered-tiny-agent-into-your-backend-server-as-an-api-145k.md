---
title: "Set up and integrate Hugging Face's MCP-powered Tiny Agent into your backend server as an API"
url: "https://dev.to/prakhar_doneria/set-up-and-integrate-hugging-faces-mcp-powered-tiny-agent-into-your-backend-server-as-an-api-145k"
author: "Prakhar Doneria"
category: "huggingface-llm-agents"
---
# Set up and integrate Hugging Face's MCP-powered Tiny Agent into your backend server as an API
**Author:** Prakhar Doneria  **Published:** April 25, 2025

## Overview
This tutorial demonstrates how to integrate Hugging Face's Model Context Protocol (MCP) agent into a backend system as an API endpoint. The guide covers local installation, basic setup, and wrapping the agent in an Express.js server to enable tool-using AI capabilities.

## Key Concepts
- MCP Protocol — an open-source standard allowing language models to access external tools like browsers and file systems
- Tool Integration — the agent can utilize MCP servers for filesystem interactions and web browsing via Playwright
- Agent Loop — cycles between LLM prompts and tool execution until task completion
- @huggingface/mcp-client — npm package for integrating HF MCP agents

## Code Examples

### Installation
```javascript
npm install @huggingface/mcp-client
```

### Express Server Implementation
```typescript
import express from "express";
import { Agent } from "@huggingface/mcp-client";
import dotenv from "dotenv";

dotenv.config();

const app = express();
app.use(express.json());

const agent = new Agent({
  provider: "nebius",
  model: "Qwen/Qwen2.5-72B-Instruct",
  apiKey: process.env.HF_TOKEN!,
  servers: [
    { command: "mcp-fs" },
    { command: "mcp-playwright" },
  ],
});

(async () => {
  await agent.loadTools();

  app.post("/agent", async (req, res) => {
    const input = req.body?.message;
    if (!input) return res.status(400).send("Missing input");

    const result: string[] = [];
    for await (const output of agent.chat(input)) {
      if (typeof output === "string") result.push(output);
    }

    res.json({ result: result.join("") });
  });

  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`Agent API running on http://localhost:${PORT}`));
})();
```

### Quick Local Test
```bash
npx @huggingface/mcp-client
```
