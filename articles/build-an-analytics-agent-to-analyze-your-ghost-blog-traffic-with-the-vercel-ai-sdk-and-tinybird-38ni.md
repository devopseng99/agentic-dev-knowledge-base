---
title: "Build an analytics agent to analyze your Ghost blog traffic with the Vercel AI SDK and Tinybird"
url: "https://dev.to/tinybirdco/build-an-analytics-agent-to-analyze-your-ghost-blog-traffic-with-the-vercel-ai-sdk-and-tinybird-38ni"
author: "Cameron Archer"
category: "agent-sdks"
---

# Build an analytics agent to analyze your Ghost blog traffic with the Vercel AI SDK and Tinybird
**Author:** Cameron Archer
**Published:** August 6, 2025

## Overview
CLI analytics agent combining Vercel AI SDK with Tinybird MCP Server to analyze Ghost blog traffic data using natural language queries.

## Key Concepts

### MCP Client Setup
```javascript
import { streamText, experimental_createMCPClient as createMCPClient } from 'ai';
import { anthropic } from '@ai-sdk/anthropic';
import { StreamableHTTPClientTransport } from '@modelcontextprotocol/sdk/client/streamableHttp.js';
import readline from 'readline';
import * as dotenv from 'dotenv';
dotenv.config();
```

### MCP Client Initialization
```javascript
async function initializeMCP() {
    if (!process.env.TINYBIRD_TOKEN) {
        console.error('TINYBIRD_TOKEN environment variable not found');
        process.exit(1);
    }
    const url = new URL(`https://mcp.tinybird.co?token=${process.env.TINYBIRD_TOKEN}`);
    mcpClient = await createMCPClient({
        transport: new StreamableHTTPClientTransport(url, {
            sessionId: `ghost-cli-${Date.now()}`,
        }),
    });
    const tools = await mcpClient.tools();
    return tools;
}
```

### Streaming Question Handler
```javascript
async function askQuestion(question, mcpTools) {
    chatHistory.push({ role: 'user', content: question });
    const result = await streamText({
        model: anthropic("claude-3-7-sonnet-20250219"),
        messages: chatHistory,
        maxSteps: 5,
        tools: { ...mcpTools },
        system: SYSTEM_PROMPT,
    });
    for await (const delta of result.fullStream) {
        switch (delta.type) {
            case 'tool-call':
                console.log(`\n🔧 ${delta.toolName}`);
                break;
            case 'text-delta':
                process.stdout.write(delta.textDelta);
                break;
        }
    }
}
```
