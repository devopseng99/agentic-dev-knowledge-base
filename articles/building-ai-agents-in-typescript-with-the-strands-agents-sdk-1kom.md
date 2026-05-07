---
title: "Building AI Agents in TypeScript with the Strands Agents SDK"
url: https://dev.to/gunnargrosch/building-ai-agents-in-typescript-with-the-strands-agents-sdk-1kom
author: Gunnar Grosch
category: ai-agents-typescript
---

# Building AI Agents in TypeScript with the Strands Agents SDK

**Author:** Gunnar Grosch
**Published:** February 23, 2026
**Tags:** #aws #ai #beginners #productivity

## Overview

The Strands Agents SDK now supports TypeScript (preview), enabling developers to build AI agents without switching languages. The announcement covers five progressive examples demonstrating agent fundamentals using Amazon Bedrock.

## Setup Requirements

- Node.js 20+
- AWS credentials configured for Bedrock access
- Supported providers: Bedrock, OpenAI, Gemini, and custom options

```bash
git clone https://github.com/gunnargrosch/strands-agents-ts-demo.git
cd strands-agents-ts-demo
npm install
```

## Five Progressive Examples

### Example 1: Minimal Agent
```typescript
import { Agent, BedrockModel } from '@strands-agents/sdk'

const agent = new Agent({
  model: new BedrockModel(),
  systemPrompt: 'You are a helpful assistant that likes to be edgy.',
  printer: false,
})

const result = await agent.invoke('Your prompt here')
console.log(result.toString())
```

### Example 2: Tool Integration
```typescript
const calculator = tool({
  name: 'calculate',
  description: 'Perform basic math operations',
  inputSchema: z.object({
    operation: z.enum(['add', 'subtract', 'multiply', 'divide']),
    a: z.number(),
    b: z.number(),
  }),
  callback: ({ operation, a, b }) => {
    // Implementation
  },
})
```

Uses Zod for schema validation and automatic error handling when models send invalid parameters.

### Example 3: Streaming with Configuration
```typescript
const model = new BedrockModel({
  temperature: 0.7,
  maxTokens: 1024,
})

for await (const event of agent.stream(prompt)) {
  if (event.type === 'modelContentBlockDeltaEvent' &&
      event.delta.type === 'textDelta') {
    process.stdout.write(event.delta.text)
  }
}
```

### Example 4: Multi-Tool Orchestration
Agents autonomously decide tool calling sequence based on responses. The researcher example demonstrates search, compare, and summarize tools working together dynamically.

### Example 5: Multi-Turn Conversation
```typescript
while (true) {
  const input = await ask('You: ')
  if (input.trim().toLowerCase() === 'exit') break

  const result = await agent.invoke(input)
  console.log(`\nAgent: ${result.toString()}\n`)
}
```

Maintains conversation history using a sliding window manager.

## Current Limitations

Not yet available: structured output, multi-agent patterns, callback handlers, module-based tool loading, and observability/telemetry features.

## Key Takeaways

- Core agent functionality is production-ready with model invocation, tool use, streaming, and conversation management
- Type safety through Zod schemas improves reliability
- Async iterators for streaming events provide granular control
- SDK handles tool error recovery automatically
- Single-file examples require no build steps

## Resources

- [Demo Repository](https://github.com/gunnargrosch/strands-agents-ts-demo)
- [Strands Agents Documentation](https://strandsagents.com)
- [TypeScript SDK Quickstart](https://strandsagents.com/latest/documentation/docs/user-guide/quickstart/typescript/)
