---
title: "Building a Monetized API (Part 3 of 4)"
url: "https://dev.to/zuplo/building-a-monetized-api-part-3-of-4-2oml"
author: "Martyn Davies"
category: "startup-monetization"
---
# Building a Monetized API (Part 3 of 4)
**Author:** Martyn Davies  **Published:** 2026-04-15

## Overview
Adding an MCP (Model Context Protocol) server to a monetized API gateway while restricting access to paid subscribers only. MCP server access is a premium feature available exclusively to Starter and Pro tier subscribers.

## Key Concepts

### Implementation Steps

1. **MCP Server Creation:** Configuration requires specifying name, version, and description, which automatically creates an endpoint at `/mcp`.

2. **Tool Exposure:** API developers select which routes become MCP tools. The team exposed all 12 endpoints. "Each tool adds to the context that AI assistants need to process."

3. **Access Control Policy:** Custom inbound policy using the `MonetizationInboundPolicy` class to check entitlements.

### Code Example

```typescript
import {
  MonetizationInboundPolicy,
  ZuploContext,
  ZuploRequest,
} from "@zuplo/runtime";

export default async function policy(
  request: ZuploRequest,
  context: ZuploContext,
  options: never,
  policyName: string,
) {
  const subscription = MonetizationInboundPolicy.getSubscriptionData(context);

  if (!subscription?.entitlements?.mcp_server?.hasAccess) {
    return new Response(
      JSON.stringify({
        error:
          "MCP access requires a Starter or Pro plan, please consider upgrading.",
      }),
      {
        status: 403,
        headers: { "Content-Type": "application/json" },
      },
    );
  }

  return request;
}
```

### Policy Ordering
The Monetization Inbound policy must run first (handling authentication and metering), followed by the custom code policy (checking entitlements).

### Testing Results
- Free-tier API keys: receive 403 responses
- Paid-tier keys: successfully connect to MCP server without requiring new credentials
- MCP requests count toward the subscriber's usage just like any other API call
