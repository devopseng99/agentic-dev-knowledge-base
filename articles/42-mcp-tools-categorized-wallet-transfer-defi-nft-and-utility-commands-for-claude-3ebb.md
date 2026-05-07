---
title: "42 MCP Tools Categorized: Wallet, Transfer, DeFi, NFT, and Utility Commands for Claude"
url: "https://dev.to/walletguy/42-mcp-tools-categorized-wallet-transfer-defi-nft-and-utility-commands-for-claude-3ebb"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# 42 MCP Tools Categorized: Wallet, Transfer, DeFi, NFT, and Utility Commands for Claude

**Author:** Wallet Guy
**Published:** May 7, 2026

## Overview

WAIaaS is an MCP server providing 45 tools enabling Claude AI agents to execute real blockchain transactions across multiple categories including wallet management, transfers, DeFi, NFTs, and utilities.

## Tool Categories (45 Total)

### Wallet Tools (8 tools)
- `get-balance` -- Native token balance checks
- `get-address` -- Retrieve wallet address
- `get-assets` -- List all token balances
- `get-wallet-info` -- Wallet metadata
- `list-credentials` -- Available signing methods
- `get-nonce` -- Transaction nonce
- `resolve-asset` -- Symbol to contract address conversion
- `get-tokens` -- Supported token registry

### Transfer Tools (7 tools)
- `send-token` -- Native and token transfers
- `transfer-nft` -- NFT transfers with metadata
- `send-batch` -- Atomic multiple transactions
- `approve-token` -- ERC-20 approvals
- `sign-transaction` -- Arbitrary transaction signing
- `sign-message` -- Message signing for authentication
- `simulate-transaction` -- Dry-run execution

### DeFi Tools (12 tools)
- `action-provider` -- List available protocols
- `get-defi-positions` -- Lending/staking positions
- `get-health-factor` -- Liquidation risk metrics
- `hyperliquid` -- Perpetual futures trading
- `polymarket` -- Prediction market positions
- `get-provider-status` -- Protocol availability

### NFT Tools (4 tools)
- `list-nfts` -- NFT collection inventory
- `get-nft-metadata` -- Metadata with image caching
- `transfer-nft` -- NFT transfers

### Utility Tools (14 tools)
- `x402-fetch` -- HTTP requests with automatic crypto payments
- `call-contract` -- Smart contract interactions
- `encode-calldata` -- ABI encoding
- `get-transaction` -- Transaction details
- `list-transactions` -- Wallet history
- `erc8004-get-agent-info` -- Onchain agent reputation
- `build-userop` -- ERC-4337 UserOperation construction
- `wc-connect` -- WalletConnect pairing

## Setup

```bash
npm install -g @waiaas/cli
waiaas init
waiaas start
waiaas quickset --mode mainnet
```

### Claude Desktop Configuration

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

## Security Implementation

7-stage transaction pipeline with 21 policy types across 4 security tiers:
- INSTANT -- Small amounts execute immediately
- NOTIFY -- Medium amounts with notifications
- DELAY -- Large amounts with 15-minute delay (cancellable)
- APPROVAL -- Very large amounts require human approval

## Advanced Patterns

- x402 Payments: `x402-fetch` enables automatic cryptocurrency payments for API access
- Smart Contracts: `call-contract` and `encode-calldata` for any smart contract interaction
- Account Abstraction: `build-userop` creates gasless ERC-4337 transactions

Platform supports 15 networks across EVM and Solana chains with 631+ tests validating reliability.
