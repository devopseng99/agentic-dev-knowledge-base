---
title: "How to Use the Langflow API in Node.js"
url: "https://dev.to/datastax/how-to-use-the-langflow-api-in-nodejs-2a12"
author: "Phil Nash"
category: "langflow-agent"
---

# How to Use the Langflow API in Node.js

**Author:** Phil Nash (DataStax)
**Published:** January 28, 2025

## Overview

Guide to integrating Langflow into Node.js applications using the official @datastax/langflow-client library, covering initialization, flow execution, tweaks, and session management.

## Key Concepts

### Installation

```bash
mkdir using-langflow-client
cd using-langflow-client
npm init --yes
npm install @datastax/langflow-client
npm install tsx @types/node --save-dev
```

### Initialization

**DataStax-hosted:**
```typescript
import { LangflowClient } from "@datastax/langflow-client"

const langflowId = "YOUR_LANGFLOW_ID";
const apiKey = "YOUR_API_KEY";
const client = new LangflowClient({ langflowId, apiKey });
```

**Self-hosted:**
```typescript
const baseURL = "http://localhost:7860";
const apiKey = "YOUR_API_KEY";
const client = new LangflowClient({ baseURL, apiKey });
```

### Running a Flow

```typescript
const flowId = "YOUR_FLOW_ID";
const flow = client.flow(flowId);
const response = await flow.run("Hello, how are you?");
console.log(response.outputs);
```

### Extracting Chat Output

```typescript
const response = await flow.run("Hello, how are you?");
console.log(response.chatOutputText());
```

### Custom Parameters

```typescript
import { InputTypes, OutputTypes } from "@datastax/langflow-client/consts";

const response = await flow.run("Hello, how are you?", {
  input_type: InputTypes.TEXT,
  output_type: OutputTypes.TEXT,
  session_id: "USER_SESSION_ID",
});
```

### Applying Tweaks (Parameter Overrides)

```typescript
const flow = client.flow(flowId);
const tweakedFlow = flow.tweak("OpenAIModel-KqkTB", { model_name: "gpt-4o" });
```

Or inline:
```typescript
const tweaks = { "OpenAIModel-KqkTB": { "model_name": "gpt-4o" }};
const response = await flow.run("Hello, how are you?", { tweaks });
```

### Important Notes

- Client is server-side only; never expose API keys to frontend
- Flow IDs available in the API modal within the Langflow canvas
- Custom session IDs maintain multi-turn conversations
- Tweaks allow runtime modification without changing the flow itself
