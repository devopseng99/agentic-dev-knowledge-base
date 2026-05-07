---
title: "7 Transaction Types Your AI Agent Can Execute: From Transfers to Contract Deployment"
url: "https://dev.to/walletguy/7-transaction-types-your-ai-agent-can-execute-from-transfers-to-contract-deployment-3p7g"
author: "Wallet Guy"
category: "ai-agent-trading-finance"
---

# 7 Transaction Types Your AI Agent Can Execute: From Transfers to Contract Deployment

**Author:** Wallet Guy
**Published:** April 26, 2026

## Overview

How WAIaaS (Wallet-as-a-Service) enables AI agents to execute blockchain transactions through seven standardized transaction types, each validated through a 7-stage pipeline with policy enforcement.

## Key Concepts

### The Seven Transaction Types

**1. Transfer** - Native token transfers (ETH, SOL)
```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "type": "TRANSFER",
    "to": "recipient-address",
    "amount": "0.1"
  }'
```

**2. TokenTransfer** - ERC-20/SPL token transfers
```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "type": "TOKEN_TRANSFER",
    "to": "recipient-address",
    "tokenAddress": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
    "amount": "100"
  }'
```

**3. ContractCall** - Smart contract interactions
```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "type": "CONTRACT_CALL",
    "to": "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984",
    "data": "0xa9059cbb000000000...",
    "value": "0"
  }'
```

**4. Approve** - Token spending permissions
```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "type": "APPROVE",
    "tokenAddress": "0xA0b86a33E6441d69BdC585C6ced5aFa36B8C1c4c",
    "spender": "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D",
    "amount": "1000000000000000000"
  }'
```

**5. Batch** - Multiple operations in one transaction
```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "type": "BATCH",
    "transactions": [
      {
        "type": "APPROVE",
        "tokenAddress": "0x...",
        "spender": "0x...",
        "amount": "1000"
      },
      {
        "type": "CONTRACT_CALL",
        "to": "0x...",
        "data": "0x..."
      }
    ]
  }'
```

**6. NftTransfer** - NFT transfers (ERC-721/ERC-1155 and Metaplex)
```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "type": "NFT_TRANSFER",
    "to": "recipient-address",
    "contractAddress": "0x...",
    "tokenId": "1234"
  }'
```

**7. ContractDeploy** - Smart contract deployment
```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/send \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "type": "CONTRACT_DEPLOY",
    "bytecode": "0x608060405234801561001057600080fd5b50...",
    "constructorArgs": ["param1", "param2"]
  }'
```

### Security - Policy Engine Configuration

```bash
curl -X POST http://127.0.0.1:3100/v1/policies \
  -H "Content-Type: application/json" \
  -H "X-Master-Password: my-secret-password" \
  -d '{
    "walletId": "<wallet-uuid>",
    "type": "SPENDING_LIMIT",
    "rules": {
      "instant_max_usd": 100,
      "notify_max_usd": 500,
      "delay_max_usd": 2000,
      "delay_seconds": 900,
      "daily_limit_usd": 5000
    }
  }'
```

### MCP Integration for Claude

```json
{
  "mcpServers": {
    "waiaas": {
      "command": "npx",
      "args": ["-y", "@waiaas/mcp"],
      "env": {
        "WAIAAS_BASE_URL": "http://127.0.0.1:3100",
        "WAIAAS_SESSION_TOKEN": "wai_sess_<your-token>"
      }
    }
  }
}
```

### TypeScript SDK

```typescript
import { WAIaaSClient } from '@waiaas/sdk';

const client = new WAIaaSClient({
  baseUrl: 'http://127.0.0.1:3100',
  sessionToken: process.env.WAIAAS_SESSION_TOKEN,
});

const balance = await client.getBalance();
const tx = await client.sendToken({ to: '...', amount: '0.1' });
```

### Quick Start

```bash
npm install -g @waiaas/cli
waiaas init
waiaas start
waiaas quickset --mode mainnet
waiaas mcp setup --all
```

- 21 policy types with 4 security tiers (INSTANT, NOTIFY, DELAY, APPROVAL)
- 7-stage transaction pipeline with policy enforcement
- Multi-chain support across EVM and Solana networks
- 45 MCP tools for Claude agent integration
- 631+ comprehensive tests
