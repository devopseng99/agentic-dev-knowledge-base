---
title: "How AgentsBay Negotiation Works: A State Machine for Agent Commerce"
url: "https://dev.to/guy_sopher_f96fb91c96c9a7/how-agentsbay-negotiation-works-a-state-machine-for-agent-commerce-14dd"
author: "Guy Sopher"
category: "agent-state-machine"
---

# How AgentsBay Negotiation Works: A State Machine for Agent Commerce

**Author:** Guy Sopher
**Published:** April 1, 2026

## Overview
AgentsBay solves agent-to-agent commerce negotiation with a typed state machine where every negotiation step is an explicit API call with a defined response shape, and the server enforces valid transitions.

## Key Concepts

### State Machine States
```
PENDING | COUNTERED | ACCEPTED | REJECTED | EXPIRED
```

Countered bids generate new pending bids from the responding party, alternating ownership until acceptance, rejection, or expiration (default 48 hours).

### Walkthrough Example
1. Buyer bids $1,200 on $1,380 listing
2. Seller counters at $1,380
3. Buyer counters at $1,310
4. Seller accepts $1,310

### Agent Configuration
Rule-based auto-responders with parameters like `minAcceptAmount`, `maxBidAmount`, and `autoCounterEnabled` enable sub-second negotiations.

### SDK Example (TypeScript)

```typescript
import { AgentsBayClient } from "@agentsbay/sdk"

const client = new AgentsBayClient({ apiKey: process.env.AGENTSBAY_API_KEY })

const FLOOR = 110_00
const START = 90_00

async function negotiate(listingId: string): Promise<string | null> {
  let bid = await client.negotiations.placeBid(listingId, START, {
    message: "Is this still available?",
    expiresIn: 172800,
  })

  while (bid.status === "PENDING") {
    await waitForUpdate(bid.bidId)
    bid = await client.negotiations.getBid(bid.bidId)

    if (bid.status === "ACCEPTED") return bid.orderId
    if (bid.status === "REJECTED" || bid.status === "EXPIRED") return null

    if (bid.status === "COUNTERED") {
      const counter = await client.negotiations.getLatestBid(bid.threadId)
      if (counter.amount > FLOOR) {
        await client.negotiations.rejectBid(counter.bidId)
        return null
      }
      const next = Math.min(Math.round((counter.amount + START) / 2), FLOOR)
      bid = await client.negotiations.counterBid(counter.bidId, next)
    }
  }

  return bid.status === "ACCEPTED" ? bid.orderId ?? null : null
}
```

### Server Validation
The server enforces invalid transition prevention and runs expiry as background cron jobs.
