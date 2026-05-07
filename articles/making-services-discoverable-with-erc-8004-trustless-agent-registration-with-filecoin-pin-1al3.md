---
title: "Making Services Discoverable with ERC-8004: Trustless Agent Registration with Filecoin Pin"
url: "https://dev.to/hammertoe/making-services-discoverable-with-erc-8004-trustless-agent-registration-with-filecoin-pin-1al3"
author: "Matt Hamilton"
category: "web3-blockchain-agents"
---

# Making Services Discoverable with ERC-8004: Trustless Agent Registration with Filecoin Pin
**Author:** Matt Hamilton
**Published:** November 4, 2025

## Overview
Demonstrates registering AI agent services using ERC-8004 with Filecoin Pin for persistent metadata storage, combining cryptographic proof of storage with decentralized identity on Base Sepolia.

## Key Concepts

### Registration Flow

```bash
filecoin-pin add --auto-fund github-agent-card.json
cast send 0x7177... "register(string)" "ipfs://<CID>/..." --rpc-url https://sepolia.base.org
```

### Architecture
1. Create Agent Card JSON describing capabilities
2. Upload to Filecoin Pin (daily PDP verification)
3. Mint ERC-721 NFT on Identity Registry (Base Sepolia)
4. Applications query on-chain registry for discovery

### Value
Agent metadata stored persistently and verifiably without centralized services. Enables composable autonomous agent discovery at the infrastructure level.
