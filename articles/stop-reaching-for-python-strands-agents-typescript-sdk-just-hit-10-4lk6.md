---
title: "Stop Reaching for Python: Strands Agents TypeScript SDK Just Hit 1.0"
url: "https://dev.to/aws/stop-reaching-for-python-strands-agents-typescript-sdk-just-hit-10-4lk6"
author: "Erik Hanchett"
category: "AI agent TypeScript"
---

# Stop Reaching for Python: Strands Agents TypeScript SDK Just Hit 1.0

**Author:** Erik Hanchett (Developer Advocate for AWS)
**Published:** May 4, 2026

## Overview

Announces the release of Strands Agents TypeScript SDK version 1.0, a full-featured agent framework native to TypeScript that eliminates the need to bridge Python and TypeScript codebases.

## Key Concepts

### Basic Agent Setup

```typescript
import { Agent } from '@strands-agents/sdk'
const agent = new Agent({ systemPrompt: 'You are a helpful assistant.' })
const result = await agent.invoke('What makes TypeScript great for building agents?')
```

### Model Provider Flexibility

Bedrock serves as the default, with support for OpenAI, Anthropic, Google, and Vercel AI SDK-compatible providers. "You just swap the model import. The agent, tools, and invocation pattern don't change at all."

### Type-Safe Tools with Zod

Tools leverage Zod schemas for runtime validation and compile-time type inference, preventing invalid inputs from reaching tool callbacks.

### MCP Server Integration

"Any MCP-compatible server works the same way. One `McpClient` import and you're done."

### Streaming Support

Agents support async iterators for streaming responses back to users in real-time.

### Browser Execution

The TypeScript SDK uniquely enables agent execution within browsers, a capability the Python version cannot provide natively.

## Multi-Agent Patterns

- **Agent-as-Tool:** Sub-agents function as tools within parent agents' tool arrays, enabling hierarchical workflows
- **Graph:** Deterministic pipelines with defined node dependencies and guaranteed execution order
- **Swarm:** Dynamic routing where models decide agent handoffs at runtime based on context

## Notable Limitation

Bedrock users should note that Swarm currently encounters compatibility issues: "the current Claude Sonnet model on Bedrock throws a 'does not support assistant message prefill' error" due to structured output requirements.

## Included Utilities

The SDK provides pre-built tools for bash commands, file editing, HTTP requests, and notebook execution without custom implementation.
