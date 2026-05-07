---
title: "How to Verify Any Smart Contract or AI Agent Before You Transact"
url: "https://dev.to/jhinresh/how-to-verify-any-smart-contract-or-ai-agent-before-you-transact-44b2"
author: "JhiNResH"
category: "web3-blockchain-agents"
---

# How to Verify Any Smart Contract or AI Agent Before You Transact
**Author:** JhiNResH
**Published:** February 27, 2026

## Overview
Maiat Protocol provides on-chain reputation scoring (0-100) for EVM addresses -- smart contracts, wallets, and AI agent tokens -- aggregating on-chain analytics, community reviews, and outcome reports.

## Key Concepts

### API Usage

```
GET https://maiat-protocol.vercel.app/api/v1/score/0xYourAddress
GET https://maiat-protocol.vercel.app/api/v1/trust-check?agent=0xYourAddress
GET https://maiat-protocol.vercel.app/api/v1/trust-gate?agent=0xYourAddress  # x402 $0.02/call
```

### Agent Integration

```javascript
const verdict = await fetch(
  `https://maiat-protocol.vercel.app/api/v1/trust-check?agent=${counterpartyAddress}`,
  { headers: { 'X-Maiat-Key': 'mk_...' } }
).then(r => r.json());

if (verdict.verdict === 'block') {
  throw new Error('Counterparty flagged as high-risk by Maiat Protocol');
}
```

### Trust Score Signals

| Signal | Weight |
|--------|--------|
| Contract verified on Etherscan | High |
| Deployer wallet age | Medium |
| Transaction count (90d) | Medium |
| Community review score | High |
| Outcome dispute rate | High |

Verdicts: proceed (>60), caution (borderline), block (high-risk).

GitHub: github.com/JhiNResH/maiat-protocol
