---
title: "How to Give Your AI Agent a Crypto Wallet in 5 Minutes"
url: "https://dev.to/openclawcash/how-to-give-your-ai-agent-a-crypto-wallet-in-5-minutes-i8m"
author: "OpenClaw Cash"
category: "web3-blockchain-agents"
---

# How to Give Your AI Agent a Crypto Wallet in 5 Minutes
**Author:** OpenClaw Cash
**Published:** March 13, 2026

## Overview
Step-by-step guide to giving AI agents managed crypto wallets with policy controls, supporting EVM and Solana chains with transfers, balance checks, and DEX swaps.

## Key Concepts

### API Authentication

```
X-Agent-Key: your_agent_key_here
```

### Check Balances

```
GET /api/agent/wallet?address=0xYourWalletAddress
X-Agent-Key: your_agent_key_here
```

### Send Transfer

```
POST /api/agent/transfer
X-Agent-Key: your_agent_key_here

{
  "from": "0xYourWalletAddress",
  "to": "0xRecipientAddress",
  "token": "ETH",
  "amount": "0.01"
}
```

### Execute DEX Swap

```
POST /api/agent/swap
X-Agent-Key: your_agent_key_here

{
  "wallet": "0xYourWalletAddress",
  "fromToken": "ETH",
  "toToken": "USDC",
  "amount": "0.05"
}
```

### Python Integration

```python
import requests

AGENT_KEY = "your_agent_key_here"
BASE_URL = "https://openclawcash.com/api/agent"

def send_transfer(to_address: str, amount: str, token: str = "ETH"):
    response = requests.post(
        f"{BASE_URL}/transfer",
        headers={"X-Agent-Key": AGENT_KEY},
        json={
            "from": "0xYourWalletAddress",
            "to": to_address,
            "token": token,
            "amount": amount
        }
    )
    return response.json()
```

### Key Features
- Managed wallets with policy controls (spending limits, address restrictions)
- Full activity history for audit trails
- Routes through Uniswap (EVM) or Jupiter (Solana) automatically
- Works with LangChain, CrewAI, AutoGPT, or custom frameworks
