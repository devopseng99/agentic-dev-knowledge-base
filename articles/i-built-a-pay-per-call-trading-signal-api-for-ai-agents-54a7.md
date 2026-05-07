---
title: "I Built a Pay-Per-Call Trading Signal API for AI Agents"
url: "https://dev.to/pmestreforge/i-built-a-pay-per-call-trading-signal-api-for-ai-agents-54a7"
author: "pmestre-Forge"
category: "web3-blockchain-agents"
---

# I Built a Pay-Per-Call Trading Signal API for AI Agents

**Author:** pmestre-Forge
**Published:** May 4, 2026

## Overview

A trading signal API for autonomous AI agents using x402 protocol with USDC micropayments on Base L2. Agents complete wallet signatures and proof verification in approximately 200 milliseconds.

## Signal Generation

Four technical indicators: RSI (14-period), ADX (14-period), MACD (12/26/9), and volume ratios. Combined into composite scores: BUY (>=30), SELL (<=-30), or HOLD with confidence values.

## Endpoints

- `/signal/TICKER` ($0.005)
- `/scan/momentum` ($0.01)
- `/risk?tickers=X,Y` ($0.01)

## Technology Stack

FastAPI backend, x402 Python SDK via ASGI middleware, LRU caching (200 entries, 5-minute TTL), deployed on Fly.io.
