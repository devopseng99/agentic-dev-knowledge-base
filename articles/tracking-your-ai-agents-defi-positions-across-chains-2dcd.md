---
title: "Tracking Your AI Agent's DeFi Positions Across Chains"
url: "https://dev.to/walletguy/tracking-your-ai-agents-defi-positions-across-chains-2dcd"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# Tracking Your AI Agent's DeFi Positions Across Chains
**Author:** Wallet Guy
**Published:** March 29, 2026

## Overview
Unified DeFi position aggregation across 14 protocols on EVM and Solana chains through normalized data via a single endpoint, eliminating the need for 14+ separate SDK integrations.

## Key Concepts

### Unified Position Query

```bash
curl http://127.0.0.1:3100/v1/defi/positions \
  -H "Authorization: Bearer wai_sess_<token>"
```

### Response Structure

```json
{
  "positions": [
    {
      "protocol": "aave-v3",
      "chain": "ethereum",
      "type": "lending",
      "asset": "USDC",
      "supplied": "10000.50",
      "apy": "4.2"
    },
    {
      "protocol": "jito-staking",
      "chain": "solana",
      "type": "staking",
      "asset": "jitoSOL",
      "staked": "100.0",
      "apy": "7.1"
    },
    {
      "protocol": "hyperliquid",
      "type": "perpetual",
      "market": "ETH-USD",
      "size": "2.5",
      "side": "long",
      "leverage": "3.0x"
    }
  ]
}
```

### Protocol-Specific Actions

```bash
# Swap on Jupiter
curl -X POST http://127.0.0.1:3100/v1/actions/jupiter-swap/swap \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{"inputMint": "So111...", "outputMint": "EPjF...", "amount": "1000000000"}'

# Supply to Aave V3
curl -X POST http://127.0.0.1:3100/v1/actions/aave-v3/supply \
  -d '{"asset": "0xA0b8...", "amount": "1000000000"}'

# Hyperliquid perp position
curl -X POST http://127.0.0.1:3100/v1/actions/hyperliquid/place-order \
  -d '{"coin": "ETH", "sz": "1.5", "px": "2500.0", "side": "B"}'
```

### Risk Policy Engine

```bash
curl -X POST http://127.0.0.1:3100/v1/policies \
  -d '{"type": "LENDING_LTV_LIMIT", "rules": {"maxLtv": 0.75, "protocols": ["aave-v3"]}}'

curl -X POST http://127.0.0.1:3100/v1/policies \
  -d '{"type": "PERP_MAX_LEVERAGE", "rules": {"maxLeverage": 5.0, "protocols": ["hyperliquid", "drift"]}}'
```

### Quick Start

```bash
git clone https://github.com/minhoyoo-iotrust/WAIaaS.git
cd WAIaaS && docker compose up -d
npm install -g @waiaas/cli
waiaas quickset --mode mainnet
```
