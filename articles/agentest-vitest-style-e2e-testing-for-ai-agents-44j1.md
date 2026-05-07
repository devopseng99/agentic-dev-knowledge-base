---
title: "Agentest: Vitest-style e2e Testing for AI Agents"
url: "https://dev.to/raffael_p/agentest-vitest-style-e2e-testing-for-ai-agents-44j1"
author: "Raffael"
category: "llm-eval-alignment"
---
# Agentest: Vitest-style e2e Testing for AI Agents
**Author:** Raffael  **Published:** March 29, 2026

## Overview
Agentest is a testing framework for AI agents that operates like Vitest or Jest but for agent-based systems. Developers cannot simply assert on text output — they need to verify tool invocations, retry logic, and decision trajectories. Agentest provides an integrated test runner (not just an observability dashboard) with LLM-powered simulated users and framework-agnostic compatibility.

## Key Concepts

### Core Capabilities
- Run tests on AI agents without modifying agent code
- Deploy LLM-powered simulated users against agents
- Mock tool calls deterministically
- Evaluate performance through LLM-as-judge metrics
- Integrate into CI/CD pipelines with clear pass/fail status

### Scenario-Based Testing

```typescript
scenario('user books a morning slot', {
  profile: 'Busy professional who prefers mornings.',
  goal: 'Book a haircut for next Tuesday morning.',
  mocks: {
    tools: {
      check_availability: (args) => ({
        available: true,
        slots: ['09:00', '09:45', '10:30'],
      }),
    },
  },
})
```

### Tool Call Assertions
Trajectory matching modes:
- `strict` — Exact sequence of tool calls
- `unordered` — All expected calls present, any order
- `contains` — Expected calls are subset of actual
- `within` — Expected calls within N steps

Argument matching strategies: `ignore`, `partial`, `exact`

### LLM-as-Judge Metrics
- Helpfulness (1-5 scale)
- Coherence (1-5 scale)
- Relevance (1-5 scale)
- Faithfulness (1-5 scale)
- Goal completion tracking
- Failure pattern detection

### Comparison Mode
Tests identical scenarios across multiple models or agent variants simultaneously, generating side-by-side metric comparisons for A/B testing during development.

### Installation

```bash
npm install @agentesting/agentest --save-dev
npx agentest run
```

CLI exits with status 0 for passing tests, enabling standard CI integration.

### Framework Compatibility
Framework-agnostic: works with any agent built on LangChain, Mastra, Vercel AI SDK, OpenLLMetry, AutoGen, or CrewAI through either HTTP endpoints or custom handler functions.

- GitHub: https://github.com/r-prem/agentest
- License: MIT
