---
title: "Building a Monetized API (Part 2 of 4)"
url: "https://dev.to/zuplo/building-a-monetized-api-part-2-of-4-59ie"
author: "Martyn Davies"
category: "startup-monetization"
---
# Building a Monetized API (Part 2 of 4)
**Author:** Martyn Davies  **Published:** 2026-04-14

## Overview
Implementing a monetization layer on an API gateway using Zuplo. Part 2 in a four-part series covering meters, plans, Stripe integration, and the developer portal.

## Key Concepts

### Three Features to Define

1. **Requests:** Linked to a meter, counts API usage against limits
2. **MCP Server:** Boolean feature (enabled/disabled), not metered
3. **Monthly Fee:** Display-only feature representing flat subscription costs

### Three Pricing Tiers

1. **Free Plan** ($0): 20 requests monthly with hard limits (blocked above this)

2. **Starter Plan** ($29.99/month): 5,000 included requests with graduated overage pricing at $0.10 per additional request. Soft limits — overages billed rather than blocked.

3. **Pro Plan** ($99.99/month): 50,000 included requests at $0.01 per overage, also with soft limits.

### Stripe Integration
Connect by pasting Stripe secret key (`sk_test_...` for development, live key for production).

### Monetization Policy Configuration

```json
{
  "handler": {
    "export": "MonetizationInboundPolicy",
    "module": "$import(@zuplo/runtime)",
    "options": {
      "meters": {
        "requests": 1
      }
    }
  }
}
```

This policy handles authentication and metering simultaneously. Must execute first in the policy chain.

### Developer Portal Integration

```javascript
import { zuploMonetizationPlugin } from "@zuplo/zudoku-plugin-monetization";
```

Added to plugins array, this automatically surfaces pricing tables and subscription management interfaces.

### End-to-End User Flow
- Sign-up displays pricing table; free plans skip Stripe checkout
- Users receive auto-provisioned API keys post-subscription
- Real-time usage tracking displays against plan limits
- Self-serve upgrades and cancellation available

### Completion Checklist
- Request metering for all API calls
- Three functional pricing plans with appropriate limits
- Stripe payment processing connected
- Monetization policy replacing basic authentication
- Developer portal with self-serve pricing and key management
