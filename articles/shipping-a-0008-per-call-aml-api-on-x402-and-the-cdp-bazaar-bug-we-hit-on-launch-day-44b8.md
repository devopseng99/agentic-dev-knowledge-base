---
title: "Shipping a $0.008-per-call AML API on x402 (and the CDP Bazaar bug we hit on launch day)"
url: "https://dev.to/rascal3/shipping-a-0008-per-call-aml-api-on-x402-and-the-cdp-bazaar-bug-we-hit-on-launch-day-44b8"
author: "Kenzo ARAI"
category: "web3-blockchain-agents"
---

# Shipping a $0.008-per-call AML API on x402 (and the CDP Bazaar bug we hit on launch day)

**Author:** Kenzo ARAI
**Published:** April 29, 2026

## Overview

ChainAnalyzer deployed an AML (Anti-Money Laundering) API using x402. An autonomous agent paid $0.008 USDC on Base mainnet to scan a Tornado Cash address, receiving CRITICAL risk scoring with no signup or API key.

## Five Implementation Issues

1. **Incorrect wire format** -- Adopted official `x402[httpx]>=2.9.0` with proper PaymentPayload structures
2. **Missing settlement step** -- Implemented full verify->handler->settle middleware chain
3. **Uninjected credentials** -- CDP API keys in Azure Key Vault weren't passed as env vars to container
4. **Header stripping** -- SvelteKit proxy filtered X-PAYMENT header; fixed with explicit forwarding
5. **Self-transfer validation** -- Demo wallet transferred USDC to itself, triggering facilitator rejection

## Ongoing CDP-Side Issue

Coinbase's Bazaar discovery pipeline fails to index settled services. The EXTENSION-RESPONSES header is absent from facilitator responses, preventing automatic listing on agentic.market. Affects at least three other teams per GitHub issues.

## API Endpoints ($0.003-$0.05 USDC per call)

- Risk scoring
- Sanctions checking
- Transaction tracing
- CoinJoin detection
- Wallet clustering
- Batch screening

Across eight blockchains. Per-call cost of plugging an autonomous agent into multi-chain AML data is now half a US cent.
