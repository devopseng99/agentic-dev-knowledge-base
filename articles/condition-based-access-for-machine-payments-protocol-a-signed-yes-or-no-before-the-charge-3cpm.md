---
title: "Condition-Based Access for Machine Payments Protocol: A Signed Yes-or-No Before the Charge"
url: "https://dev.to/douglasborthwickcrypto/condition-based-access-for-machine-payments-protocol-a-signed-yes-or-no-before-the-charge-3cpm"
author: "Douglas Borthwick"
category: "web3-blockchain-agents"
---

# Condition-Based Access for Machine Payments Protocol: A Signed Yes-or-No Before the Charge

**Author:** Douglas Borthwick
**Published:** May 7, 2026

## Overview

The `@insumermodel/mppx-condition-gate` package sits before any MPP Method.Server and inserts a decision point before charging executes. First entry on Tempo's extensions page (PR #445, merged March 23, 2026).

## The Gap MPP Leaves Open

MPP carries payer wallet address via `credential.source` (DID format) but lacks native pattern for deciding whether wallets warrant free access based on conditions.

## Four Condition Types

1. **Token balance** -- wallets holding specified token amounts
2. **NFT ownership** -- wallets possessing particular NFTs
3. **EAS attestation** -- wallets with Coinbase-verified accounts
4. **Farcaster ID** -- wallets maintaining Farcaster accounts

Conditions combinable with matchMode 'any' or 'all'.

## How It Works

Requests arrive, conditionGate extracts wallet from credential.source, calls InsumerAPI with conditions, evaluates results. Meeting conditions produces free-access receipt. Unmet conditions fall through to normal paid processing.

## Composability

Same adapter works across Tempo, Stripe, Hono, Express, Next.js -- any framework consuming MPP servers. Non-destructive: precedes original verify function and falls through on failures.

## Chains and Pricing

33 chains: 30 EVM + Solana + XRPL + Bitcoin. Wallet holders pay nothing at gated routes. Operators pay per attestation call. 10 free attestation credits via email, or buy with USDC/USDT/BTC.

Principle: "Before a machine pays, it should qualify."
