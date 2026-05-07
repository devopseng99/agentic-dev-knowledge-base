---
title: "Build your first agent in 5 minutes with Mastra"
url: "https://dev.to/mastra_ai/build-your-first-agent-in-5-minutes-with-mastra-2ah3"
author: "Shane Thomas"
category: "agent-sdks"
---

# Build your first agent in 5 minutes with Mastra
**Author:** Shane Thomas
**Published:** April 10, 2025

## Overview
Beginner-friendly tutorial on building an AI agent with Mastra framework, covering agent concepts, tool creation, and adding memory capabilities.

## Key Concepts

### Installation
```bash
npm create mastra@latest
```

### Creating a Transactions Tool
```typescript
export const getTransactionsTool = createTool({
  id: 'get-transactions',
  description: 'Get transaction data from Google Sheets',
  inputSchema: z.object({}),
  outputSchema: z.object({
    csvData: z.string(),
  }),
  execute: async () => {
    return await getTransactions();
  },
});
```

### Agent with Tools and Memory
```typescript
export const assistantAgent = new Agent({
  name: "Personal Assistant Agent",
  instructions: `ROLE DEFINITION
- You are a personal assistant specializing in both weather information and personal financial transactions.
CORE CAPABILITIES
- Provide weather details for specific locations
- Assist with personal financial transactions
BEHAVIORAL GUIDELINES
- Convert temperature from Celsius to Fahrenheit
- Keep responses concise but informative`,
  model: openai("gpt-4o"),
  tools: { weatherTool, getTransactionsTool },
});
```

### Adding Memory
```bash
npm install @mastra/memory
```
```typescript
import { Memory } from '@mastra/memory';
// Add memory: new Memory() as agent property
```
