---
title: "Adding Multi-Agent Orchestration to a Vercel AI SDK App"
url: https://dev.to/jackchenme/adding-multi-agent-orchestration-to-a-vercel-ai-sdk-app-4536
author: JackChen
category: vercel-ai-sdk
---

# Adding Multi-Agent Orchestration to a Vercel AI SDK App

**Author:** JackChen
**Published:** April 15, 2026

---

## Overview

This article demonstrates how to integrate open-multi-agent (OMA) with Vercel's AI SDK to build collaborative multi-agent systems. The author shows how to create a research-and-writing workflow where agents decompose tasks, execute them in dependency order, and share context.

## Key Architecture

The solution employs a two-phase approach:

1. **OMA orchestration phase**: A coordinator agent plans tasks, agents execute them in parallel/sequence, and results populate shared memory
2. **AI SDK streaming phase**: The team's output streams to the browser via `useChat`

As the author notes: *"OMA sits above that: given a goal and a roster of agents, it breaks the goal into tasks, runs them in dependency order."*

## Implementation Steps

### Project Setup

Required dependencies:
- `ai` (Vercel AI SDK v6)
- `@jackchen_me/open-multi-agent` (orchestration framework)
- `@ai-sdk/openai-compatible` (provider integration)
- Next.js and React 19

### Backend: API Route (`app/api/chat/route.ts`)

```typescript
import { streamText, convertToModelMessages, type UIMessage } from 'ai'
import { createOpenAICompatible } from '@ai-sdk/openai-compatible'
import { OpenMultiAgent } from '@jackchen_me/open-multi-agent'

const provider = createOpenAICompatible({
  name: 'deepseek',
  baseURL: 'https://api.deepseek.com/v1',
  apiKey: process.env.DEEPSEEK_API_KEY,
})

// Define agents with system prompts and configuration
const researcher: AgentConfig = {
  name: 'researcher',
  model: 'deepseek-chat',
  provider: 'openai',
  systemPrompt: 'You are a research specialist...',
  maxTurns: 3,
  temperature: 0.2,
}

const writer: AgentConfig = {
  name: 'writer',
  model: 'deepseek-chat',
  provider: 'openai',
  systemPrompt: 'You are an expert writer...',
  maxTurns: 3,
  temperature: 0.4,
}

export async function POST(req: Request) {
  const { messages } = await req.json()

  // Phase 1: Multi-agent orchestration
  const orchestrator = new OpenMultiAgent({
    defaultModel: 'deepseek-chat',
    defaultProvider: 'openai',
    defaultBaseURL: 'https://api.deepseek.com',
    defaultApiKey: process.env.DEEPSEEK_API_KEY,
  })

  const team = orchestrator.createTeam('research-writing', {
    agents: [researcher, writer],
    sharedMemory: true,
  })

  const teamResult = await orchestrator.runTeam(
    team,
    `Research and write an article about: ${userInput}`,
  )

  // Phase 2: Stream via AI SDK
  const result = streamText({
    model: provider('deepseek-chat'),
    system: 'Relay team output faithfully...',
    messages: await convertToModelMessages(messages),
  })

  return result.toUIMessageStreamResponse()
}
```

### Frontend: Chat Component (`app/page.tsx`)

```typescript
'use client'

import { useState } from 'react'
import { useChat } from '@ai-sdk/react'

export default function Home() {
  const { messages, sendMessage, status, error } = useChat()
  const [input, setInput] = useState('')

  const isLoading = status === 'submitted' || status === 'streaming'

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!input.trim() || isLoading) return
    setInput('')
    await sendMessage({ text: input })
  }

  return (
    <main style={{ maxWidth: 720, margin: '0 auto', padding: '32px 16px' }}>
      <h1>Research Team</h1>

      {messages.map((m) => (
        <div key={m.id} style={{ marginBottom: 24 }}>
          <strong>{m.role === 'user' ? 'You' : 'Research Team'}</strong>
          <div>{/* Render message parts */}</div>
        </div>
      ))}

      <form onSubmit={handleSubmit}>
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Enter a topic to research..."
          disabled={isLoading}
        />
        <button type="submit" disabled={isLoading || !input.trim()}>
          Send
        </button>
      </form>
    </main>
  )
}
```

## Request Lifecycle

1. User submits topic via `useChat`
2. `runTeam()` executes: coordinator plans tasks, researcher gathers information, writer drafts article
3. Outputs persist in shared memory for inter-agent access
4. Final coordinator synthesis passes to `streamText()`
5. Tokens stream to browser through AI SDK protocol
6. `useChat` renders response incrementally

## Key Takeaways

- **Division of labor**: AI SDK handles LLM calls and streaming; OMA manages multi-agent orchestration
- **When to use OMA**: Multi-agent collaboration with interdependencies (research+writing, code review teams)
- **Provider flexibility**: Works with OpenAI, Anthropic, DeepSeek, or any OpenAI-compatible API
- **Gotcha**: `@ai-sdk/openai` v2 defaults to Responses API; use `@ai-sdk/openai-compatible` for broader provider support

Working example available in the [open-multi-agent repository](https://github.com/JackChen-me/open-multi-agent/tree/main/examples/with-vercel-ai-sdk).
