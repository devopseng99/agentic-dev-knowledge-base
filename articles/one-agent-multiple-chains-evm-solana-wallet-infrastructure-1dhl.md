---
title: "One Agent, Multiple Chains: EVM + Solana Wallet Infrastructure"
url: "https://dev.to/walletguy/one-agent-multiple-chains-evm-solana-wallet-infrastructure-1dhl"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# One Agent, Multiple Chains: EVM + Solana Wallet Infrastructure
**Author:** Wallet Guy
**Published:** March 24, 2026

## Overview
Introduces WAIaaS providing unified wallet infrastructure for AI agents across EVM and Solana chains with 45 MCP tools, 14 DeFi protocol integrations, and a 7-stage transaction pipeline.

## Key Concepts

### Quick Start

```bash
npm install -g @waiaas/cli
waiaas init
waiaas start
waiaas quickset --mode mainnet
```

### Claude Desktop Integration

```bash
waiaas mcp setup --all
```

### Security Model
Three authorization layers: session auth for routine operations, time delays + human approval for significant transactions, monitoring with kill switches.

### Cross-Chain Operations
Agent can hold USDC on Polygon, bridge to Solana via Across, swap for SOL on Jupiter, stake through Jito -- all from same wallet infrastructure.

### Headless Deployment

```bash
npm install -g @waiaas/cli
waiaas init --auto-provision
waiaas start
waiaas quickset
waiaas set-master
```

### Integration Paths
TypeScript SDK (@waiaas/sdk), Python SDK, REST API (39 route modules), OpenClaw plugin (17 sessionAuth tools), MCP for Claude Desktop.
