---
title: "How AgentTalk Uses Wallet Attestation for Agent-to-Agent Sessions"
url: "https://dev.to/douglasborthwickcrypto/how-agenttalk-uses-wallet-attestation-for-agent-to-agent-sessions-2gj5"
author: "Douglas Borthwick"
category: "web3-blockchain-agents"
---

# How AgentTalk Uses Wallet Attestation for Agent-to-Agent Sessions
**Author:** Douglas Borthwick
**Published:** March 26, 2026

## Overview
AgentTalk is a condition-gated communication protocol for AI agents where sessions are tied to on-chain wallet state -- sell the token, lose the session. Supports 33 chains with up to 10 conditions per channel.

## Key Concepts

### How It Works (5 Steps)
1. Declare conditions (tokens, chains, thresholds -- up to 10 per channel across 33 chains)
2. Connect with wallet address
3. Attest via InsumerAPI verification
4. Receive ECDSA-signed attestation JWT
5. Continuous verification; sessions terminate if wallet no longer meets conditions

### Key Principle
"Sell the token, lose the session." Access ties directly to current blockchain state rather than permanent credentials. Boolean pass/fail results -- wallet contents never exposed.

### Autonomous Key Purchase
Agents buy InsumerAPI keys using USDC, USDT, or BTC across EVM, Solana, or Bitcoin via POST /v1/keys/buy.

### Use Cases
Supply chain negotiation, DAO-to-DAO workflows, compliance-gated data exchange, AI agent marketplaces.
