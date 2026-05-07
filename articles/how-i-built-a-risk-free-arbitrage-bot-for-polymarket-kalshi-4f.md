---
title: "How I Built a Risk-Free Arbitrage Bot for Polymarket & Kalshi"
url: "https://dev.to/realfishsam/how-i-built-a-risk-free-arbitrage-bot-for-polymarket-kalshi-4f"
author: "Samuel EF. Tinnerholm"
category: "web3-blockchain-agents"
---

# How I Built a Risk-Free Arbitrage Bot for Polymarket & Kalshi
**Author:** Samuel EF. Tinnerholm
**Published:** January 16, 2026

## Overview
Exploiting consistent 2-5% price spreads between Polymarket (blockchain) and Kalshi (regulated REST API) prediction markets using the pmxt unified wrapper library.

## Key Concepts
- API fragmentation solved by pmxt (inspired by CCXT) normalizing both data streams
- Spread detection: combined prices below $1.00 indicate arbitrage
- Rotation strategy: exit when spreads close rather than holding to maturity
- Caveats: execution latency, liquidity constraints, slow fiat withdrawals

GitHub: github.com/realfishsam/prediction-market-arbitrage-bot
