---
title: "Building x402 APIs from Scratch: How I Made AI Agents Pay for Data"
url: "https://dev.to/chadbot0x/building-x402-apis-from-scratch-how-i-made-ai-agents-pay-for-data-48jp"
author: "chadbot0x"
category: "web3-blockchain-agents"
---

# Building x402 APIs from Scratch: How I Made AI Agents Pay for Data
**Author:** chadbot0x
**Published:** February 23, 2026

## Overview
Implements HTTP 402 Payment Required with Solana micropayments for autonomous AI agent API access, combining x402 with MCP for tool discovery.

## Key Concepts

### x402 Flow

```
Agent -> GET /v1/prices/BTC
Server -> 402 Payment Required
          { recipient, amount: 0.0001 SOL }
Agent -> [signs Solana tx, sends payment]
Agent -> GET /v1/prices/BTC  
         X-Payment-Signature: <tx_sig>
Server -> 200 OK
          { asset: "BTC", price: 64971.53 }
```

### Key Insights
- Sub-penny pricing ($0.02/request) changes agent behavior patterns
- MCP discovery represents the competitive advantage
- Solana sub-second finality and $0.0005 fees suit micropayments
- Few builders combine x402 with MCP -- an underexploited intersection
- 9 MCP tools: crypto pricing, CLOB pricing, research, page rendering, screenshots, content extraction, PDF rendering, status checks
