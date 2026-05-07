---
title: "Claude Function calls with AWS Step Functions"
url: "https://dev.to/aws-builders/claude-function-calls-with-aws-step-functions-46l"
author: "szymon-szym"
category: "aws-agents"
---

# Claude Function calls with AWS Step Functions
**Author:** szymon-szym
**Published:** April 28, 2024

## Overview
Building an agent-like system using Claude 3 function calling APIs orchestrated by AWS Step Functions, with Rust Lambda functions as tools and AWS CDK for infrastructure.

## Key Concepts

### Step Functions HttpInvoke for Claude API

```typescript
const callLlmTask = new tasks.HttpInvoke(this, "Call LLM", {
  apiRoot: "https://api.anthropic.com",
  apiEndpoint: sfn.TaskInput.fromText("/v1/messages"),
  body: sfn.TaskInput.fromObject(getLlmPrompt()),
  connection: llmDestinationConnection,
  headers: sfn.TaskInput.fromObject({
    "Content-Type": "application/json",
    "anthropic-version": "2023-06-01",
    "anthropic-beta": "tools-2024-04-04",
  }),
  method: sfn.TaskInput.fromText("POST"),
});
```

### Tool Definitions in Prompt

```typescript
tools: [
  {
    name: "get_weather",
    description: "Get the current weather in a given location.",
    input_schema: {
      type: "object",
      properties: {
        location: { type: "string", description: "The city and state" },
      },
      required: ["location"],
    },
  },
  {
    name: "get_restaurants",
    description: "Get recommended restaurants in the given city.",
    input_schema: {
      type: "object",
      properties: {
        location: { type: "string" },
      },
      required: ["location"],
    },
  },
],
```

### Choice State for Tool Use

```typescript
const choiceIfUseTool = new sfn.Choice(this, "Choice if use tool");
choiceIfUseTool.when(
  sfn.Condition.stringEquals("$.taskResult.stop_reason", "tool_use"),
  callToolsTask
);
choiceIfUseTool.otherwise(passAnswer);
```

### Rust Lambda Tool Handler

```rust
let tool_result = match req_use.name.as_str() {
  "get_weather" => {
    let inp = serde_json::from_value::<GetWeatherToolInput>(input).unwrap();
    get_weather(req_use.id.clone(), inp)
  }
  "get_restaurants" => {
    let inp = serde_json::from_value::<GetRestaurantsToolInput>(input).unwrap();
    get_restaurants(req_use.id.clone(), inp)
  }
  _ => panic!("unknown tool name"),
};
```
