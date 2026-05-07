---
title: "From Blood Sugar Spikes to Automatic Order Interventions: Building a Closed-Loop Health Agent with LangChain and OpenAI"
url: "https://dev.to/beck_moulton/from-blood-sugar-spikes-to-automatic-order-interventions-building-a-closed-loop-health-agent-with-229"
author: "Beck_Moulton"
category: "healthcare-ai"
---
# From Blood Sugar Spikes to Automatic Order Interventions: Building a Closed-Loop Health Agent with LangChain and OpenAI
**Author:** Beck_Moulton  **Published:** March 21, 2026

## Overview
Tutorial demonstrating building an intelligent healthcare system that monitors glucose levels via Continuous Glucose Monitor (CGM) data and automatically intervenes with food delivery order cancellations when metabolic thresholds are exceeded. Combines real-time biometric monitoring with AI-driven decision-making using LangChain and OpenAI.

## Key Concepts
- AI agents with tool-calling capabilities
- Real-time glucose monitoring (Dexcom API integration)
- Automated health interventions triggering food delivery cancellations
- Closed-loop health systems
- TypeScript-based implementation

```typescript
import { DynamicStructuredTool } from "@langchain/core/tools";
import { z } from "zod";

export const glucoseMonitorTool = new DynamicStructuredTool({
  name: "get_glucose_levels",
  description: "Fetches current blood sugar levels and trends from Dexcom CGM.",
  schema: z.object({}),
  func: async () => {
    console.log("Fetching data from Dexcom API...");
    return JSON.stringify({
      value: 185,
      unit: "mg/dL",
      trend: "rising_fast",
      timestamp: new Date().toISOString()
    });
  },
});
```

```typescript
import { ChatOpenAI } from "@langchain/openai";
import { ChatPromptTemplate, MessagesPlaceholder } from "@langchain/core/prompts";
import { AgentExecutor, createOpenAIFunctionsAgent } from "langchain/agents";

const llm = new ChatOpenAI({
  modelName: "gpt-4o",
  temperature: 0
});

const prompt = ChatPromptTemplate.fromMessages([
  ["system", "You are an expert Health Guardian Agent. Monitor CGM data. If glucose > 180 and rising, check for active food orders and suggest cancellations of high-carb items."],
  ["human", "{input}"],
  new MessagesPlaceholder("agent_scratchpad"),
]);

const agent = await createOpenAIFunctionsAgent({ llm, tools, prompt });
const executor = new AgentExecutor({ agent, tools });
```

```typescript
async function runHealthCheck() {
  const result = await executor.invoke({
    input: "My sugar is spiking! I just ordered a pizza (Order ID: PIZZA-123). Please handle this!",
  });
  console.log("Agent Response:", result.output);
}
```
