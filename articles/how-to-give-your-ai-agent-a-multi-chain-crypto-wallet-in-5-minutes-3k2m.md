---
title: "How to Give Your AI Agent a Multi-Chain Crypto Wallet in 5 Minutes"
url: "https://dev.to/emblemai/how-to-give-your-ai-agent-a-multi-chain-crypto-wallet-in-5-minutes-3k2m"
author: "EmblemAI"
category: "web3-blockchain-agents"
---

# How to Give Your AI Agent a Multi-Chain Crypto Wallet in 5 Minutes
**Author:** EmblemAI
**Published:** April 14, 2026

## Overview
Single npm package giving any AI agent a deterministic crypto wallet spanning 7 blockchains (Solana, Ethereum, Base, BSC, Polygon, Hedera, Bitcoin) with 200+ autonomous trading tools across 14 categories.

## Key Concepts

### Installation

```bash
npm install -g @emblemvault/agentwallet
emblemai --help
```

### Agent Mode Operations

```bash
emblemai --agent -m "What are my wallet addresses?"
emblemai --agent -m "Show my balances across all chains"
emblemai --agent -m "Swap 20 dollars worth of SOL to USDC on Solana"
emblemai --agent -m "Bridge 50 USDC from Ethereum to Solana"
emblemai --agent -m "What are the best yield opportunities for USDC right now?"
emblemai --agent -m "What tokens are trending on Solana today?"
```

### Multi-Agent with Separate Wallets

```bash
emblemai --agent -p "agent-alice-wallet-001" -m "What are my balances?"
emblemai --agent -p "agent-bob-wallet-002" -m "What are my balances?"
```

### Python Integration

```python
import subprocess
import json

def agent_wallet_query(message: str) -> str:
    result = subprocess.run(
        ["emblemai", "--agent", "-m", message],
        capture_output=True, text=True
    )
    return result.stdout

balances = agent_wallet_query("Show my portfolio summary")
```
