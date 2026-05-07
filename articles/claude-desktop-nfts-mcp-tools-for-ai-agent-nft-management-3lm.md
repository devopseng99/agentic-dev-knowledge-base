---
title: "Claude Desktop + NFTs: MCP Tools for AI Agent NFT Management"
url: "https://dev.to/walletguy/claude-desktop-nfts-mcp-tools-for-ai-agent-nft-management-3lm"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# Claude Desktop + NFTs: MCP Tools for AI Agent NFT Management

**Author:** Wallet Guy
**Published:** May 4, 2026

## Overview

WAIaaS integrates NFT functionality with Claude Desktop through Model Context Protocol (MCP), enabling AI agents to manage NFT portfolios within a single conversation -- discovering collections, analyzing metadata, executing transfers, and tracking changes.

## Core NFT Tools

- **list-nfts** -- Browse complete NFT collection with metadata
- **get-nft-metadata** -- Detailed analysis of individual NFTs
- **transfer-nft** -- Execute NFT transfers with policy enforcement
- **get-assets** -- Portfolio view including NFT valuations

## Setup

```bash
npm install -g @waiaas/cli
waiaas init
waiaas start
waiaas quickset --mode mainnet
waiaas mcp setup --all
```

```json
{
  "mcpServers": {
    "waiaas": {
      "command": "npx",
      "args": ["-y", "@waiaas/mcp"],
      "env": {
        "WAIAAS_BASE_URL": "http://127.0.0.1:3100",
        "WAIAAS_SESSION_TOKEN": "wai_sess_eyJhbGciOiJIUzI1NiJ9...",
        "WAIAAS_DATA_DIR": "~/.waiaas"
      }
    }
  }
}
```

## Smart Transfer Execution

```bash
curl -X POST http://127.0.0.1:3100/v1/transactions/nft-transfer \
  -H "Authorization: Bearer wai_sess_<token>" \
  -d '{
    "contractAddress": "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D",
    "tokenId": "4532",
    "to": "0x742d35Cc6664C8532D24C15D8eb18C9C95F5FB45",
    "standard": "ERC721"
  }'
```

## Policy-Protected Operations

```bash
curl -X POST http://localhost:3100/v1/policies \
  -H 'Content-Type: application/json' \
  -H 'X-Master-Password: <password>' \
  -d '{
    "walletId": "<wallet-uuid>",
    "type": "SPENDING_LIMIT",
    "rules": {
      "instant_max_usd": 100,
      "delay_max_usd": 1000,
      "delay_seconds": 300
    }
  }'
```

## Cross-Chain NFT Management

The system handles both Ethereum and Solana NFTs, with Claude comparing portfolios across chains and recommending strategies based on each chain's characteristics.
