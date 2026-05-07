---
title: "Add DeFi Superpowers to Claude with MCP Skills"
url: "https://dev.to/walletguy/add-defi-superpowers-to-claude-with-mcp-skills-147g"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# Add DeFi Superpowers to Claude with MCP Skills
**Author:** Wallet Guy
**Published:** March 27, 2026

## Overview
Guide to adding 45 blockchain MCP tools to Claude Desktop for wallet management, DeFi operations, NFT support, and cross-chain transactions using WAIaaS infrastructure.

## Key Concepts

### MCP Configuration

```json
{
  "mcpServers": {
    "waiaas": {
      "command": "npx",
      "args": ["-y", "@waiaas/mcp"],
      "env": {
        "WAIAAS_BASE_URL": "http://127.0.0.1:3100",
        "WAIAAS_SESSION_TOKEN": "wai_sess_<your-token>",
        "WAIAAS_DATA_DIR": "~/.waiaas"
      }
    }
  }
}
```

### Quick Start

```bash
npm install -g @waiaas/cli
waiaas init --auto-provision
waiaas start
waiaas quickset --mode mainnet
waiaas mcp setup --all
npx @waiaas/skills add all
```

### 45 MCP Tools in 5 Categories
- Wallet Management: get-address, get-balance, get-assets, list-credentials
- Transaction Execution: send-token, transfer-nft, sign-transaction, simulate-transaction
- DeFi Operations: get-defi-positions, action-provider, get-health-factor, 14 protocol integrations
- NFT Support: list-nfts, get-nft-metadata for EVM and Solana standards
- Advanced: x402-fetch for micropayments, erc8004-get-reputation, wc-connect for human approval

### 4-Tier Security Policy
- INSTANT: Small amounts, immediate execution
- NOTIFY: Medium amounts with real-time alerts
- DELAY: Larger amounts with cancellation windows
- APPROVAL: High-value transactions requiring human approval

### Multi-Agent Configuration

```json
{
  "mcpServers": {
    "waiaas-trading": {
      "command": "npx",
      "args": ["-y", "@waiaas/mcp"],
      "env": {
        "WAIAAS_AGENT_ID": "019c47d6-51ef-7f43-a76b-d50e875d95f4",
        "WAIAAS_AGENT_NAME": "trading-agent"
      }
    },
    "waiaas-treasury": {
      "command": "npx",
      "args": ["-y", "@waiaas/mcp"],
      "env": {
        "WAIAAS_AGENT_ID": "019c4cd2-86e8-758f-a61e-9c560307c788",
        "WAIAAS_AGENT_NAME": "treasury-manager"
      }
    }
  }
}
```

GitHub: https://github.com/minhoyoo-iotrust/WAIaaS
