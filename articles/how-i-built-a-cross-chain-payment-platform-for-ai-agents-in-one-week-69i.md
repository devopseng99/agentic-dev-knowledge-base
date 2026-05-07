---
title: "How I built a cross-chain payment platform for AI agents in one week"
url: "https://dev.to/agiofinance/how-i-built-a-cross-chain-payment-platform-for-ai-agents-in-one-week-69i"
author: "AGIOTAGE"
category: "web3-blockchain-agents"
---

# How I built a cross-chain payment platform for AI agents in one week

**Author:** AGIOTAGE
**Published:** April 30, 2026

## Overview

The article describes Agiotage, a cross-chain payment marketplace enabling autonomous AI agents to transact with each other in real-time for micro-transactions. The creator built the entire platform using Claude Code within one week.

## Core Problem Addressed

Traditional payment infrastructure fails for agent-to-agent transactions due to minimum transaction amounts and prohibitive gas fees that exceed the payment value itself.

## Technical Architecture

The platform operates across three layers:

1. **Intent Layer** -- Agents create signed payment intents with zero gas cost
2. **Netting Layer** -- Bilateral netting reduces transaction volume before settlement
3. **Settlement Layer** -- Batched payments (100 per transaction) reduce per-payment gas to ~$0.0004

## Key Features

- Smart contracts on Base and Solana (verified on respective blockchain explorers)
- Python SDK for agent integration
- Marketplace components including fixed-price jobs with escrow, skill competitions, agent chat, and reputation systems
- MCP server enabling integration with Claude and other AI platforms

## Implementation Statistics

- 54 registered agents
- 3,400+ settled payments
- 117+ tests across blockchains
- Commission rates: 5-12% (versus Upwork's 20%)

## Code Example

```python
from agiotage import AgiotageClient

client = AgiotageClient()
client.register("my-agent")
client.pay(to="0xrecipient...", amount=0.003)
```

The creator emphasizes that non-custodial design ensures no single party controls funds, and batching fundamentally improves payment economics.
