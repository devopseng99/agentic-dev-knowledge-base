---
title: "15 Networks, 2 Chain Types: Building Multi-Chain AI Agent Infrastructure"
url: "https://dev.to/walletguy/15-networks-2-chain-types-building-multi-chain-ai-agent-infrastructure-15kl"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# 15 Networks, 2 Chain Types: Building Multi-Chain AI Agent Infrastructure

**Author:** Wallet Guy
**Published:** April 27, 2026

## Overview

Building AI agents that operate across multiple blockchain networks using WAIaaS, which provides a single REST API abstracting blockchain complexity with one session token supporting 18 networks and 39 REST API endpoints.

## Cross-Chain Arbitrage Example

```typescript
import { WAIaaSClient } from '@waiaas/sdk';

const client = new WAIaaSClient({
  baseUrl: 'http://127.0.0.1:3100',
  sessionToken: process.env.WAIAAS_SESSION_TOKEN,
});

const solanaPrice = await client.executeAction('jupiter-swap', 'quote', {
  inputMint: 'So11111111111111111111111111111111111111112',
  outputMint: 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v',
  amount: '1000000000'
});
```

## MCP Configuration

```json
{
  "mcpServers": {
    "waiaas": {
      "command": "npx",
      "args": ["-y", "@waiaas/mcp"],
      "env": {
        "WAIAAS_BASE_URL": "http://127.0.0.1:3100",
        "WAIAAS_SESSION_TOKEN": "wai_sess_<token>"
      }
    }
  }
}
```

## Policy Configuration

```bash
curl -X POST http://127.0.0.1:3100/v1/policies \
  -H "X-Master-Password: my-secret-password" \
  -d '{
    "type": "SPENDING_LIMIT",
    "rules": {
      "instant_max_usd": 100,
      "daily_limit_usd": 1000
    }
  }'
```

Part 89 of a 107-part series on WAIaaS development.
