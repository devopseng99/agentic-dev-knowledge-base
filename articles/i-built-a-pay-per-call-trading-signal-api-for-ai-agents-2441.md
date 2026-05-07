---
title: "I Built a Pay-Per-Call Trading Signal API for AI Agents"
url: "https://dev.to/pmestreforge/i-built-a-pay-per-call-trading-signal-api-for-ai-agents-2441"
author: "pmestre-Forge"
category: "ai-agent-trading-finance"
---

# I Built a Pay-Per-Call Trading Signal API for AI Agents

**Author:** pmestre-Forge
**Published:** April 15, 2026

## Overview

A trading signal API designed for autonomous AI agents using the x402 protocol for USDC micropayments on Base L2 blockchain. "Agent shows up, pays half a cent, gets data" without needing signup or API keys.

## Key Concepts

### x402 Protocol Flow

1. Agent requests data via `GET /signal/NVDA`
2. Server returns HTTP 402 status with payment requirements
3. Agent's wallet signs a USDC transfer on Base L2
4. Agent resubmits request with payment proof header
5. Server verifies payment and delivers data

The complete flow executes within approximately 200 milliseconds.

### Signal Analysis Engine

The engine combines four technical indicators:

- **RSI (14):** Identifies overbought/oversold conditions
- **ADX (14):** Measures trend strength (>25 indicates strong trends)
- **MACD (12/26/9):** Tracks momentum crossovers
- **Volume ratio:** Compares current volume to 20-day averages

Results generate BUY (>=30), SELL (<=-30), or HOLD signals with confidence scoring.

### API Endpoints and Pricing

| Endpoint | Cost | Function |
|----------|------|----------|
| `/signal/TICKER` | $0.005 | Individual stock analysis |
| `/scan/momentum` | $0.01 | Top 10 momentum opportunities |
| `/risk?tickers=X,Y` | $0.01 | Portfolio risk evaluation |

### Technology Stack

- FastAPI (synchronous endpoints for blocking yfinance I/O)
- x402 Python SDK with ASGI middleware integration
- LRU caching (200-entry capacity, 5-minute TTL)
- Fly.io hosting

**Repository:** https://github.com/pmestre-Forge/signal-api
