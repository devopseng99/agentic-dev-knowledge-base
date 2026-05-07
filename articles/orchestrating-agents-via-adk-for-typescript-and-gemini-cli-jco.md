---
title: "Orchestrating Agents via ADK for TypeScript and Gemini CLI"
url: "https://dev.to/gde/orchestrating-agents-via-adk-for-typescript-and-gemini-cli-jco"
author: "Tanaike"
category: "AI agent TypeScript"
---

# Orchestrating Agents via ADK for TypeScript and Gemini CLI

**Author:** Tanaike
**Published:** April 21, 2026

## Overview

Explores construction and coordination of production-grade, type-safe AI agents using Google's TypeScript Agent Development Kit. Covers practical scaffolding, multi-agent coordination, and deployment strategies for remote subagents within the Gemini CLI framework. Notes that "TypeScript-specific ADK resources account for less than 5% of total search volume compared to the Python-centric ecosystem."

## Key Concepts

### Sample 1: General Logic Analyst

```typescript
import { LlmAgent } from "@google/adk";

export const rootAgent = new LlmAgent({
  name: "general_logic_analyst",
  description:
    "Handles general reasoning, text summarization, and logical validation of information.",
  model: "gemini-3-flash-preview",
  instruction: `You are a Senior Logic Analyst and General Assistant.
Your role is to process general queries and synthesize information from various sources.

### Key Responsibilities:
1. **Summarization**: Condense long texts or technical logs into concise, actionable insights.
2. **Logical Validation**: Check if a given statement or piece of code follows logical consistency.
3. **Drafting**: Create professional emails, reports, or documentation based on raw data.
4. **Knowledge Retrieval**: Answer general knowledge questions using your internal training data.

### Constraints:
- Keep responses professional and structured.
- If you receive data from other agents (like weather or file logs), focus on explaining the *implications* of that data.
- Do not invent facts; if information is missing, clearly state so.

### Output Style:
Use bullet points for clarity and always provide a brief "Conclusion" or "Next Steps" section at the end of long responses.`,
});
```

### Sample 2: API Manager with Tools

```typescript
import { LlmAgent, FunctionTool } from "@google/adk";
import { z } from "zod";

const getExchangeRateTool = new FunctionTool({
  name: "get_exchange_rate",
  description: "Use this to get current exchange rate between currencies.",
  parameters: z.object({
    currency_from: z.string().default("USD").describe("Source currency."),
    currency_to: z.string().default("EUR").describe("Destination currency."),
    currency_date: z.string().default("latest").describe("Date in ISO format or 'latest'."),
  }),
  execute: async ({ currency_from, currency_to, currency_date }) => {
    try {
      const response = await fetch(
        `https://api.frankfurter.app/${currency_date}?from=${currency_from}&to=${currency_to}`,
      );
      if (!response.ok) throw new Error(`API status: ${response.status}`);
      const data: any = await response.json();
      const rate = data.rates[currency_to];
      return `The currency rate at ${currency_date} from "${currency_from}" to "${currency_to}" is ${rate}.`;
    } catch (error: any) {
      return `Error retrieving exchange rate: ${error.message}`;
    }
  },
});

export const rootAgent = new LlmAgent({
  name: "api_manager_agent",
  description: "An agent that manages currency and weather API tools.",
  model: "gemini-3-flash-preview",
  instruction: `You are a professional API Manager.
1. Use 'get_exchange_rate' for currency queries.
2. Use 'get_current_weather' for weather queries.
3. Provide precise, helpful responses based on tool outputs.`,
  tools: [getExchangeRateTool],
});
```

### Sample 3: Local Filesystem Expert via MCP

```typescript
import { LlmAgent, MCPToolset } from "@google/adk";

export const rootAgent = new LlmAgent({
  name: "local_file_expert",
  model: "gemini-3-flash-preview",
  instruction:
    "You are a local file manager. Help users organize and understand their files.",
  tools: [
    new MCPToolset({
      type: "StdioConnectionParams",
      serverParams: {
        command: "npx",
        args: ["-y", "@modelcontextprotocol/server-filesystem", "sample3/sample"],
      },
    }),
  ],
});
```

### Sample 5: Multi-Agent Orchestrator

```typescript
import { LlmAgent } from "@google/adk";
import { rootAgent as agent1 } from "../sample1/agent.ts";
import { rootAgent as agent2 } from "../sample2/agent.ts";
import { rootAgent as agent3 } from "../sample3/agent.ts";
import { rootAgent as agent4 } from "../sample4/agent.ts";

export const rootAgent = new LlmAgent({
  name: "multi_agent_orchestrator",
  description: "Advanced orchestrator capable of serial, parallel, and iterative task execution.",
  model: "gemini-3-flash-preview",
  instruction: `You are a Senior Multi-Agent Orchestrator. Your role is to analyze user prompts and delegate tasks to the most suitable sub-agents.

### Available Sub-Agents & Expertise:
- "general_logic_analyst": Logic validation, summarization, and final report drafting.
- "api_manager_agent": Real-time currency exchange and weather data retrieval.
- "local_file_expert": Local file system operations within the workspace.
- "workspace_doc_guide": Google Workspace APIs and Apps Script documentation.`,
  subAgents: [agent1, agent2, agent3, agent4],
});
```

### Sample 6: A2A Server Implementation

```typescript
import { LlmAgent, toA2a } from "@google/adk";
import express from "express";
import "dotenv/config";

const port = 8000;
const host = "localhost";

async function startServer() {
  const app = express();
  await toA2a(targetAgent, {
    protocol: "http",
    basePath: "",
    host,
    port,
    app,
  });
  app.listen(port, () => {
    console.log(`Server started on http://${host}:${port}`);
    console.log(`Try: http://${host}:${port}/.well-known/agent-card.json`);
  });
}
startServer().catch(console.error);
```

Repository: https://github.com/tanaikech/ts-multi-agent-scaffolding
