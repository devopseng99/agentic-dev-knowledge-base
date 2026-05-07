---
title: "Stripe's x402 Is Live - Here's the Open-Source SDK That Makes It Dead Simple"
url: "https://dev.to/ai-agent-economy/stripes-x402-is-live-heres-the-open-source-sdk-that-makes-it-dead-simple-cb"
author: "Bill Wilson"
category: "web3-blockchain-agents"
---

# Stripe's x402 Is Live - Here's the Open-Source SDK That Makes It Dead Simple
**Author:** Bill Wilson
**Published:** March 10, 2026

## Overview
Announces Stripe's x402 payment support on Base and introduces agentwallet-sdk (v5.0.2) for automating x402 payment flows with USDC, including spending guardrails and ERC-8004 identity.

## Key Concepts

### x402 Agent Wallet

```typescript
const wallet = await AgentWallet.create({
  chain: 'base',
  spendingPolicy: {
    maxPerTransaction: '10.00',
    dailyLimit: '100.00',
    allowedRecipients: ['0x...stripe-merchant']
  }
});
const response = await wallet.fetch('https://api.example.com/premium-data');
```

### Features
- ERC-8004 identity registries
- Mutual stake escrow
- Multi-chain CCTP bridging
- Automatic spending guardrails
- Open-source (MIT license)
