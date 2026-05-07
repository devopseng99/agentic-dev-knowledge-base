---
title: "Introducing Agent Duelist: Benchmark LLM Providers Like a Pro"
url: "https://dev.to/datagobes/introducing-agent-duelist-benchmark-llm-providers-like-a-pro-4hh0"
author: "Gijs Jansen"
category: "agent-research-testing"
---
# Introducing Agent Duelist: Benchmark LLM Providers Like a Pro
**Author:** Gijs Jansen  **Published:** March 1, 2026

## Overview
Agent Duelist is a TypeScript framework enabling developers to benchmark multiple LLM providers against real tasks. Addresses the fragmented workflow of comparing models by unifying provider integrations, metrics collection, and performance analysis into a single CLI tool.

## Key Concepts
1. **Provider-Agnostic Architecture** — Write tasks once, execute across OpenAI, Azure, Anthropic, Gemini, and OpenAI-compatible endpoints
2. **Structured Metrics** — Captures latency (wall-clock milliseconds), token counts, and cost estimation using a bundled pricing catalog
3. **Rich Scoring System** — Seven built-in scorers: latency, cost, correctness, schema validation, fuzzy similarity, LLM-as-judge, and tool-usage accuracy
4. **Agent-Focused Design** — Native support for tool-calling workflows with local handler execution and invocation accuracy measurement
5. **TypeScript-First DX** — Strong typing via Zod schemas and full IDE autocomplete

## Code Examples

```typescript
import { defineArena, openai, anthropic } from 'agent-duelist'
import { z } from 'zod'

export default defineArena({
  providers: [
    openai('gpt-5.2'),
    anthropic('claude-sonnet-4-6-20260217'),
  ],
  tasks: [{
    name: 'extract-company',
    prompt: 'Extract company and role as JSON from: "I work at Acme Corp as engineer."',
    expected: { company: 'Acme Corp', role: 'engineer' },
    schema: z.object({ 
      company: z.string(), 
      role: z.string() 
    }),
  }],
  scorers: ['latency', 'cost', 'correctness', 'schema-correctness'],
  runs: 3,
})
```

```bash
npm install agent-duelist
npx duelist init
npx duelist run
npx duelist run --reporter json > results.json
```
