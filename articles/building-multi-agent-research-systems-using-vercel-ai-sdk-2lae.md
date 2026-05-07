---
title: "Building Multi-Agent Research Systems using Vercel AI SDK"
url: "https://dev.to/valyuai/building-multi-agent-research-systems-using-vercel-ai-sdk-2lae"
author: "Prosper Otemuyiwa"
category: "agent-sdks"
---

# Building Multi-Agent Research Systems using Vercel AI SDK
**Author:** Prosper Otemuyiwa
**Published:** March 13, 2026

## Overview
Demonstrates building a multi-agent research system using Vercel AI SDK with an orchestrator-worker pattern. Specialist agents run in parallel across financial analysis, medical research, and journalism domains.

## Key Concepts

### Setup
```bash
pnpm add ai @ai-sdk/anthropic @valyu/ai-sdk @ai-sdk/react zod valyu-js
```

### Financial Analyst Agent
```typescript
import { ToolLoopAgent } from "ai";
import { anthropic } from "@ai-sdk/anthropic";
import { secSearch, financeSearch, economicsSearch } from "@valyu/ai-sdk";

export const financialAnalystAgent = new ToolLoopAgent({
  model: anthropic("claude-haiku-4-5-20251001"),
  instructions: `You are a senior financial analyst specializing in SEC filings, market data, and economic research.`,
  tools: {
    secSearch: secSearch({ maxNumResults: 3, responseLength: "short" }),
    financeSearch: financeSearch({ maxNumResults: 3, responseLength: "short" }),
    economicsSearch: economicsSearch({ maxNumResults: 3, responseLength: "short" }),
  },
});
```

### Medical Researcher Agent
```typescript
import { ToolLoopAgent } from "ai";
import { anthropic } from "@ai-sdk/anthropic";
import { bioSearch, paperSearch } from "@valyu/ai-sdk";

export const medicalResearcherAgent = new ToolLoopAgent({
  model: anthropic("claude-haiku-4-5-20251001"),
  instructions: `You are a medical and life sciences research specialist.`,
  tools: {
    bioSearch: bioSearch({ maxNumResults: 3, responseLength: "short" }),
    paperSearch: paperSearch({ maxNumResults: 3, responseLength: "short" }),
  },
});
```

### Journalist Agent
```typescript
import { ToolLoopAgent } from "ai";
import { anthropic } from "@ai-sdk/anthropic";
import { webSearch } from "@valyu/ai-sdk";

export const journalistAgent = new ToolLoopAgent({
  model: anthropic("claude-haiku-4-5-20251001"),
  instructions: `You are an investigative journalist and news analyst with access to real-time web sources.`,
  tools: {
    webSearch: webSearch({ maxNumResults: 5, responseLength: "short" }),
  },
});
```

### Orchestrator Agent
```typescript
import { ToolLoopAgent, tool, stepCountIs } from "ai";
import { anthropic } from "@ai-sdk/anthropic";
import { z } from "zod";

const financialAnalystTool = tool({
  description: "Delegate to the Financial Analyst agent for SEC filings, stock data, earnings reports.",
  inputSchema: z.object({
    task: z.string().describe("The financial research task to complete"),
  }),
  execute: async ({ task }, { abortSignal }) => {
    const result = await financialAnalystAgent.generate({ prompt: task, abortSignal });
    return result.text;
  },
});

export const orchestratorAgent = new ToolLoopAgent({
  model: anthropic("claude-haiku-4-5-20251001"),
  instructions: `You are a research orchestrator that routes queries to specialized agents.`,
  tools: {
    financialAnalyst: financialAnalystTool,
    scientist: scientistTool,
    journalist: journalistTool,
  },
  stopWhen: stepCountIs(10),
});
```

### API Route
```typescript
import { createAgentUIStreamResponse } from "ai";
import { orchestratorAgent } from "@/agents/orchestrator";

export async function POST(request: Request) {
  const { messages } = await request.json();
  return createAgentUIStreamResponse({
    agent: orchestratorAgent,
    uiMessages: messages,
  });
}
```
