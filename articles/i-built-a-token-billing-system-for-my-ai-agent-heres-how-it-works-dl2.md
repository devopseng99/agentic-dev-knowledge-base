---
title: "I Built a Token Billing System for My AI Agent"
url: "https://dev.to/tejakummarikuntla/i-built-a-token-billing-system-for-my-ai-agent-heres-how-it-works-dl2"
author: "Teja Kummarikuntla"
category: "ai-agent-api-gateway"
---

# I Built a Token Billing System for My AI Agent

**Author:** Teja Kummarikuntla (Kong)
**Published:** March 31, 2026

## Overview
Usage-based billing for AI agents routing requests across LLM providers using Kong AI Gateway, Konnect Metering & Billing, and Stripe.

## Key Concepts

### Architecture
1. **Kong AI Gateway** - Proxies LLM requests, logs token statistics
2. **Konnect Metering & Billing** (OpenMeter) - Aggregates usage events, applies pricing
3. **Stripe** - Payment collection

### Critical Settings
- `log_statistics: true` captures token counts
- `log_payloads: true` logs request/response content

### Key Insight: Input vs Output Pricing
Output tokens are 3-5x more expensive because input can be parallelized across GPUs while output generation is sequential. Separating token types prevents underpricing output-heavy workloads.

### Budget Configuration Example

```yaml
agents:
  research-bot:
    budget:
      daily: 5000
      per_call:
        web_search: 5
        gpt4_analyze: 50
        dalle_generate: 100
```

### Production Considerations
- Multiple features per model and token direction
- Tiered pricing at higher usage thresholds
- Token budgets and usage limits per plan tier
- Multi-provider routing with load balancing
