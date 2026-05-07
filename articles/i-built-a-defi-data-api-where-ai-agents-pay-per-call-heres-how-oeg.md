---
title: "I Built a DeFi Data API Where AI Agents Pay Per Call -- Here's How"
url: "https://dev.to/fernsugi/i-built-a-defi-data-api-where-ai-agents-pay-per-call-heres-how-oeg"
author: "sugi"
category: "web3-blockchain-agents"
---

# I Built a DeFi Data API Where AI Agents Pay Per Call -- Here's How
**Author:** sugi
**Published:** February 22, 2026

## Overview
A DeFi data API where clients pay per call in USDC without API keys, accounts, or subscriptions. Payment integrates into the HTTP request itself using x402 protocol on Base blockchain. Registered as Agent #18763 via ERC-8004.

## Key Concepts

### API Endpoints
- GET /api/price-feed (0.001 USDC): BTC/ETH/SOL prices
- GET /api/gas-tracker (0.001 USDC): Multi-chain gas data
- GET /api/dex-quotes (0.002 USDC): Swap comparisons
- GET /api/token-scanner (0.003 USDC): Rug-pull risk detection
- GET /api/whale-tracker (0.005 USDC): Holder concentration metrics
- GET /api/yield-scanner (0.005 USDC): DeFi yields from Aave, Compound, Morpho
- GET /api/funding-rates (0.008 USDC): Perpetual funding rates
- GET /api/wallet-profiler (0.008 USDC): Portfolio risk assessment

### Client Implementation

```typescript
import { wrapFetchWithPayment } from 'x402-fetch';
import { createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { base } from 'viem/chains';

const account = privateKeyToAccount(process.env.PRIVATE_KEY as `0x${string}`);
const walletClient = createWalletClient({ account, chain: base, transport: http() });
const fetchWithPayment = wrapFetchWithPayment(fetch, walletClient);

const response = await fetchWithPayment('https://x402-api.fly.dev/api/price-feed');
const data = await response.json();
```

### ERC-8004 Agent Identity
On-chain agent registration making capabilities, endpoints, and status publicly discoverable. Enables autonomous agent discovery without human involvement.

### Key Learnings
- EIP-3009 transferWithAuthorization requires both signature and transaction hash validation
- Replay protection essential immediately -- use nonce tracking (Redis for multi-replica)
- HTTP 402 response structure must be exact or x402-fetch fails silently

Live at: https://x402-api.fly.dev
