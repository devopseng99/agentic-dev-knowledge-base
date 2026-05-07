---
title: "Cloudflare as an Inference Layer for Agents: What It Promises and What Worries Me"
url: "https://dev.to/jtorchia/cloudflare-as-an-inference-layer-for-agents-what-it-promises-and-what-worries-me-1j3"
author: "Juan Torchia"
category: "ai-agent-cloudflare-workers"
---

# Cloudflare as an Inference Layer for Agents: What It Promises and What Worries Me

**Author:** Juan Torchia
**Published:** April 17, 2026

## Overview
A critical analysis of Cloudflare's AI Platform for building distributed agents. While acknowledging the technical merit of edge inference and integrated tooling, the author warns against conflating "distributed" with "decentralized" when a single company controls the entire stack.

## Key Concepts

### The Promise
Cloudflare offers a complete platform integrating Workers AI (edge inference), Durable Objects (state management), Queues/Workflows (task orchestration), and AI Gateway (observability).

### The Concerns
1. **Pricing Opacity:** Complex billing interactions between Durable Objects, Queues, and AI Gateway
2. **Vendor Lock-in:** Integration between Workers AI + Durable Objects + Queues is Cloudflare-specific; migration means redesigning architecture
3. **Model Limitations:** Quantized edge models lack reasoning capabilities of full-precision alternatives
4. **Privacy Nuances:** "Reasonable" policies differ from "legally guaranteed" protections
5. **Centralized Risk:** One vendor controlling rate limiting, model deprecation, and free tier limits

## Code Examples

### Basic Agent Example

```javascript
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const response = await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
      messages: [
        {
          role: 'system',
          content: 'You are an agent that helps with code analysis'
        },
        {
          role: 'user',
          content: await request.text()
        }
      ],
      max_tokens: 1024
    })
    return Response.json(response)
  }
}
```

### Durable Object for Persistent State

```javascript
export class AgentWithMemory implements DurableObject {
  private history: Array<{role: string, content: string}> = []

  constructor(private state: DurableObjectState, private env: Env) {}

  async fetch(request: Request): Promise<Response> {
    const { message } = await request.json() as { message: string }
    this.history = await this.state.storage.get('history') ?? []
    this.history.push({ role: 'user', content: message })

    const response = await this.env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
      messages: this.history
    })

    const responseText = (response as any).response
    this.history.push({ role: 'assistant', content: responseText })
    await this.state.storage.put('history', this.history)

    return Response.json({ response: responseText })
  }
}
```

### Vendor Lock-in Example

```javascript
export class DangerouslySimpleAgent implements DurableObject {
  constructor(private state: DurableObjectState, private env: Env) {}

  async fetch(request: Request): Promise<Response> {
    // Every single one of these lines is Cloudflare-specific
    const memory = await this.state.storage.get('state')
    const inference = await this.env.AI.run('...', { messages: [] })
    await this.state.storage.put('state', inference)

    return Response.json(inference)
  }
}
```
