---
title: "Function Calling with Ollama: Make Your Local LLM Run Real Tools"
url: "https://dev.to/pavelespitia/function-calling-with-ollama-make-your-local-llm-run-real-tools-bep"
author: "Pavel Espitia"
category: "tool calling LLM"
---

# Function Calling with Ollama: Make Your Local LLM Run Real Tools

**Author:** Pavel Espitia
**Published:** May 1, 2026

## Overview

Tutorial on implementing function calling with local Ollama models in TypeScript. "The LLM doesn't actually call your function. It returns a structured request, and your code decides whether to execute it. Always."

## Key Concepts

### Compatible Models (2026)

- `qwen2.5:7b` and larger -- strong support
- `llama3.1:8b` and larger -- strong support
- `mistral-nemo` -- strong support
- `llama3.2:3b` -- limited capability

### Tool Definition

```typescript
const tools = [
  {
    type: "function",
    function: {
      name: "get_weather",
      description: "Get the current weather for a city",
      parameters: {
        type: "object",
        properties: {
          city: { type: "string", description: "City name" },
          unit: {
            type: "string",
            enum: ["celsius", "fahrenheit"],
            description: "Temperature unit",
          },
        },
        required: ["city"],
      },
    },
  },
];
```

### API Call to Ollama

```typescript
const response = await fetch("http://localhost:11434/v1/chat/completions", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    model: "qwen2.5:7b",
    messages: [{ role: "user", content: "What's the weather in Bogota?" }],
    tools,
    tool_choice: "auto",
  }),
});

const json = await response.json();
const message = json.choices[0].message;
console.log(message.tool_calls);
```

### Function Execution and Follow-up

```typescript
async function getWeather(city: string, unit: string) {
  return { city, temperature: 19, unit, conditions: "partly cloudy" };
}

const toolCall = message.tool_calls[0];
const args = JSON.parse(toolCall.function.arguments);
const result = await getWeather(args.city, args.unit ?? "celsius");

const final = await fetch("http://localhost:11434/v1/chat/completions", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    model: "qwen2.5:7b",
    messages: [
      { role: "user", content: "What's the weather in Bogota?" },
      message,
      {
        role: "tool",
        tool_call_id: toolCall.id,
        content: JSON.stringify(result),
      },
    ],
  }),
});

const finalJson = await final.json();
console.log(finalJson.choices[0].message.content);
```

### Zod Validation for Safety

```typescript
import { z } from "zod";

const WeatherArgs = z.object({
  city: z.string(),
  unit: z.enum(["celsius", "fahrenheit"]).default("celsius"),
});

const args = WeatherArgs.parse(JSON.parse(toolCall.function.arguments));
```

### Common Issues

1. **Hallucinated arguments** - Smaller models invent field values; use strict validation
2. **Ignored tools** - Reword prompts to explicitly instruct tool usage
3. **Unnecessary function calls** - Add system prompt guidance for when to call functions
