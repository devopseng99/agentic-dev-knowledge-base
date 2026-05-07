---
title: "Build Your First AI Agent in TypeScript"
url: https://dev.to/pmbanugo/build-your-first-ai-agent-in-typescript-hbo
author: Peter Mbanugo
category: ai-agents-typescript
---

# Build Your First AI Agent in TypeScript

**Author:** Peter Mbanugo
**Published:** August 11, 2025
**Tags:** #ai #gemini #typescript #node

---

## Overview

This tutorial demonstrates how to create an AI agent using TypeScript and Node.js. The author builds a weather agent capable of suggesting activities based on current conditions and time.

## Prerequisites

- TypeScript and Node.js installed
- LLM API key (Gemini recommended for free tier access)
- Obtain key at: https://aistudio.google.com/apikey

## Project Setup

Use Mastra SDK to scaffold the project:

```bash
npx create-mastra@latest --project-name weather-ai --example --components tools,agents,workflows --llm google
```

Configure the `.env` file with your Gemini API key as `GOOGLE_GENERATIVE_AI_API_KEY`.

Test with: `npm run dev` and visit http://localhost:4111

## Architecture Overview

The project follows three organizational folders:

- **Agents:** Define AI behavior and orchestrate tool usage
- **Tools:** Functions that agents use to retrieve data or perform actions
- **Workflows:** Coordinate complex multi-step processes

## Weather Agent Structure

The core agent definition includes system instructions, model selection, and tool references:

```typescript
export const weatherAgent = new Agent({
  name: "Weather Agent",
  instructions: `You are a helpful weather assistant...`,
  model: google("gemini-2.5-flash"),
  tools: { weatherTool },
  memory: new Memory({
    storage: new LibSQLStore({
      url: "file:../mastra.db",
    }),
  }),
});
```

## Weather Tool Implementation

The tool uses Zod for schema validation:

```typescript
export const weatherTool = createTool({
  id: "get-weather",
  description: "Get current weather for a location",
  inputSchema: z.object({
    location: z.string().describe("City name"),
  }),
  outputSchema: z.object({
    temperature: z.number(),
    feelsLike: z.number(),
    humidity: z.number(),
    windSpeed: z.number(),
    windGust: z.number(),
    conditions: z.string(),
    location: z.string(),
  }),
  execute: async ({ context }) => {
    return await getWeather(context.location);
  },
});
```

The implementation fetches geocoding data and weather information via Open-Meteo API.

## Time Tool Extension

Create `src/mastra/tools/time-tool.ts`:

```typescript
import { createTool } from "@mastra/core/tools";
import { z } from "zod";

export const timeTool = createTool({
  id: "get-current-time",
  description: "Get the current time and date information",
  inputSchema: z.object({
    timezone: z.string().optional().describe(
      'Timezone (e.g., "America/New_York")',
    ),
  }),
  outputSchema: z.object({
    date: z.string(),
    time: z.string(),
    timestamp: z.number(),
  }),
  execute: async ({ context }) => {
    return getCurrentTime(context.timezone);
  },
});

const getCurrentTime = (timezone?: string) => {
  const now = new Date();
  const targetTimezone =
    timezone || Intl.DateTimeFormat().resolvedOptions().timeZone;

  const dateFormatter = new Intl.DateTimeFormat("en-US", {
    timeZone: targetTimezone,
    weekday: "long",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });

  const timeFormatter = new Intl.DateTimeFormat("en-US", {
    timeZone: targetTimezone,
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  });

  return {
    date: dateFormatter.format(now),
    time: timeFormatter.format(now),
    timestamp: now.getTime(),
  };
};
```

## Integration Steps

1. Import the time tool in `weather-agent.ts`
2. Add to agent's tools object: `tools: { weatherTool, timeTool }`
3. Update system instructions to leverage the time tool for activity suggestions

## Key Takeaways

- System prompts significantly influence agent behavior and output quality
- Tools provide agents with capabilities to interact with external systems
- Zod schema validation ensures type safety for tool inputs/outputs
- Tool composition enables complex agent reasoning and decision-making
- Simple agents can be built quickly with proper SDK scaffolding

The author encourages experimentation with system prompts and tool combinations to create increasingly capable agents.
