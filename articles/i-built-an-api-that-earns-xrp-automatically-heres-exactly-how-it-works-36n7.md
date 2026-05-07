---
title: "I Built an API That Earns XRP Automatically -- Here's Exactly How It Works"
url: "https://dev.to/kynto/i-built-an-api-that-earns-xrp-automatically-heres-exactly-how-it-works-36n7"
author: "Kynto"
category: "web3-blockchain-agents"
---

# I Built an API That Earns XRP Automatically -- Here's Exactly How It Works

**Author:** Kynto
**Published:** May 6, 2026

## Overview

xrplriskscore.ai is a production API that charges per-request payments in XRP with no subscriptions or API keys. It scores XRP Ledger wallet risk in real-time, returning ALLOW, CHALLENGE, or BLOCK verdicts before transactions are signed.

## x402 Payment Flow

1. Client requests GET /score/rWalletAddress
2. Server responds 402 with invoice details and destination wallet
3. Client constructs XRPL Payment transaction with invoiceId in Memos
4. Client signs, submits, retries with PAYMENT-SIGNATURE header
5. Facilitator verifies on-ledger payment
6. Server returns risk score

```javascript
{
  "x402Version": 1,
  "accepts": [{
    "scheme": "exact",
    "network": "xrpl:0",
    "maxAmountRequired": "1000000",
    "resource": "https://xrplriskscore.ai/score/rWalletAddress",
    "description": "Full 31-signal XRPL wallet risk score",
    "memoRequired": {
      "invoiceId": "uuid-generated-per-request"
    },
    "paymentAddress": "rU7kCg3PrDGXtKocUpEvpy6xiTgvsKLHPG"
  }]
}
```

## 31-Signal Scoring Engine

Four categories: Account Fundamentals (age, reserves, trustlines), Behavioral Signals (velocity, diversity, DEX patterns), Asset Exposure (stablecoin, NFT, escrow), Network Analysis (counterparty clustering, risk hop distance).

Verdicts: 0-30 ALLOW, 31-60 CHALLENGE, 61-100 BLOCK.

## Pricing

| Endpoint | Price | Function |
|----------|-------|----------|
| /score/:wallet | 1 XRP | Full 31-signal score |
| /prescore/:wallet | 0.1 XRP | Quick 3-signal verdict |
| /rwa-check/:wallet | 0.5 XRP | Tokenized asset compliance |
| /score-batch | 8-40 XRP | 10-50 wallets bulk |

## MCP Integration

```bash
npx -p @xrplriskscore/mcp xrplriskscore-mcp-setup
```

## Critical Bug Found

Every wallet scored INSTITUTIONAL with 0 risk because the Sequence field (tens of millions for modern wallets) was used instead of actual transaction history. Fix: `transactions.length` instead.
