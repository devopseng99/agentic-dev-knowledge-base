---
title: "WalletConnect + AI Agents: Mobile Approval for Autonomous Transactions"
url: "https://dev.to/walletguy/walletconnect-ai-agents-mobile-approval-for-autonomous-transactions-2ke7"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# WalletConnect + AI Agents: Mobile Approval for Autonomous Transactions
**Author:** Wallet Guy
**Published:** April 2, 2026

## Overview
Three-layer security model for AI agent transactions: default-deny policy engine, four-tier spending limits, and mobile approval via WalletConnect for high-value operations.

## Key Concepts

### Layer 1: Default-Deny Policy

```bash
curl -X POST http://localhost:3100/v1/policies \
  -d '{"walletId": "<uuid>", "type": "ALLOWED_TOKENS", "rules": {"tokens": [{"symbol": "USDC"}, {"symbol": "SOL"}]}}'
```

### Layer 2: Spending Tiers

```bash
curl -X POST http://localhost:3100/v1/policies \
  -d '{"type": "SPENDING_LIMIT", "rules": {"instant_max_usd": 100, "notify_max_usd": 500, "delay_max_usd": 2000, "delay_seconds": 900, "daily_limit_usd": 5000}}'
```

Four tiers: INSTANT (<$100), NOTIFY ($100-500), DELAY ($500-2000 with 15min wait), APPROVAL (>$2000).

### Layer 3: WalletConnect Mobile Approval

```bash
curl -X POST http://127.0.0.1:3100/v1/owner/connect \
  -d '{"method": "walletconnect", "walletId": "<uuid>"}'
```

### Trading Bot Example

```bash
curl -X POST http://127.0.0.1:3100/v1/actions/jupiter-swap/swap \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{"inputMint": "EPjF...", "outputMint": "So11...", "amount": "1000000000"}'
```

### Advanced Policies
Time-based restrictions, rate limiting, per-protocol limits, leverage caps. Three approval channels: WalletConnect, Push Protocol, Telegram Bot.
