---
title: "x402: How AI Agents Pay for API Calls with Crypto Micropayments"
url: "https://dev.to/emblemai/x402-how-ai-agents-pay-for-api-calls-with-crypto-micropayments-3a5a"
author: "EmblemAI"
category: "web3-blockchain-agents"
---

# x402: How AI Agents Pay for API Calls with Crypto Micropayments
**Author:** EmblemAI
**Published:** April 16, 2026

## Overview
Deep dive into x402, an HTTP payment protocol enabling AI agents to pay for individual API calls without accounts, credit cards, or API keys -- using USDC micropayments that complete in a single HTTP round trip.

## Key Concepts

### Protocol Flow

```
1. Agent sends request:
   GET /api/market-data HTTP/1.1

2. Server responds:
   HTTP/1.1 402 Payment Required
   {
     "x402Version": 1,
     "accepts": [{
       "scheme": "exact",
       "network": "base-mainnet",
       "maxAmountRequired": "10000",
       "payTo": "0x742d35Cc6634C0532925a3b8...",
       "asset": "0x833589fCD6eDb6E08f4c7C32D4f71..."
     }]
   }

3. Agent retries with payment:
   GET /api/market-data HTTP/1.1
   X-PAYMENT: <signed payment data>

4. Server verifies, returns data.
```

### Client Implementation

```javascript
async function x402Request(url, wallet) {
  const response = await fetch(url);
  if (response.status !== 402) return response.json();

  const paymentReq = await response.json();
  const option = paymentReq.accepts[0];

  const payment = await wallet.signPayment({
    to: option.payTo,
    amount: option.maxAmountRequired,
    asset: option.asset,
    network: option.network
  });

  const paidResponse = await fetch(url, {
    headers: { "X-PAYMENT": payment.signature }
  });
  return paidResponse.json();
}
```

### Server-Side Integration

```javascript
import { paymentMiddleware } from "@coinbase/x402";

app.use(
  paymentMiddleware({
    "GET /api/market-data": {
      accepts: [{ network: "base-mainnet", asset: "USDC" }],
      maxAmountRequired: "10000",
      description: "Real-time market analysis"
    }
  })
);
```

### Discovery Endpoints

| Endpoint | Standard | Purpose |
|----------|----------|---------|
| /.well-known/x402 | x402 | Payment discovery |
| /.well-known/agent-card.json | Google A2A | Agent interoperability |
| /.well-known/agent-registration.json | ERC-8004 | On-chain identity |

### Pricing
$0.01 for market-data queries, $0.05 for swaps, $0.10 for cross-chain analysis across 7 blockchains.
