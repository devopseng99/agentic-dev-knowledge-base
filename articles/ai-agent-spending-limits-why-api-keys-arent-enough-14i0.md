---
title: "AI Agent Spending Limits: Why API Keys Aren't Enough"
url: "https://dev.to/mattdeangit/ai-agent-spending-limits-why-api-keys-arent-enough-14i0"
author: "matt-dean-git"
category: "ai-agent-rate-limiting"
---

# AI Agent Spending Limits: Why API Keys Aren't Enough

**Author:** matt-dean-git
**Published:** March 10, 2026

## Overview
Rate limits control volume, but agents need budget limits for predictable spending. A research agent visiting 1,000 links at $0.10 each costs $100 for a single query. The problem is not volume but unpredictability.

## Key Concepts

### Budget vs Rate Limits
Agents need budget limits, not just rate limits. Predictable spending, not just predictable requests.

### Budget Exhaustion as Structured Error

```json
{
  "jsonrpc":"2.0",
  "id":42,
  "error":{
    "code":-32000,
    "message":"Budget exhausted",
    "data":{
      "error":"budget_exhausted",
      "tool":"dalle_generate",
      "cost_credits":50,
      "remaining_credits":0
    }
  }
}
```

### Per-Tool Cost Configuration

```yaml
tools:
  defaultCost: 5
  costs:
    web_search: 5
    database_query: 5
    gpt4_summarize: 25
    gpt4_*: 25
    dalle_generate: 50
    code_execute: 15
```

Resolution: exact match -> longest wildcard prefix -> catch-all * -> default value.

### Installation

```shell
go install github.com/satgate-io/satgate/cmd/satgate-mcp@latest
```

### Enterprise Features
- RedisBudgetEnforcer: Atomic spend tracking across instances
- Postgres audit trail: Spend attribution for cost recovery
