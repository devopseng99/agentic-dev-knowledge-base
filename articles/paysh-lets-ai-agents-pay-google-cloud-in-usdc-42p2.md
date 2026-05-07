---
title: "Pay.sh Lets AI Agents Pay Google Cloud in USDC"
url: "https://dev.to/tomwangcn/paysh-lets-ai-agents-pay-google-cloud-in-usdc-42p2"
author: "Tom Wang"
category: "web3-blockchain-agents"
---

# Pay.sh Lets AI Agents Pay Google Cloud in USDC

**Author:** Tom Wang
**Published:** May 6, 2026

## Overview

Pay.sh, a joint initiative from the Solana Foundation and Google Cloud, enables AI agents to pay for cloud services using USDC stablecoins on Solana. Supports Gemini, BigQuery, Vertex AI, and 50+ third-party APIs including OpenAI Codex and Anthropic Claude Code.

## Architecture

Pay.sh operates as an API proxy on Google Cloud Platform. When agents request services, the proxy responds with HTTP 402 Payment Required, prompting settlement on Solana before retry.

## Protocols Used

- **x402** -- HTTP-native payment standard (transferred to Linux Foundation in April)
- **MPP (Machine Payments Protocol)** -- Stripe and Tempo's specification for agent-to-agent payment intent

## Significance

First hyperscaler accepting stablecoin payments natively:
- Instant stablecoin integration for most-called APIs
- Fractions-of-a-cent per-call pricing
- Direct agent payment models without enterprise negotiation
- Solana wallets (Privy, Phantom, custodial) sign transfers
