---
title: "ERC-8004: Enabling Trustless Autonomous Agents onchain & offchain"
url: "https://dev.to/rollingindo/erc-8004-enabling-trustless-autonomous-agents-onchain-offchain-4024"
author: "rayQu"
category: "web3-blockchain-agents"
---

# ERC-8004: Enabling Trustless Autonomous Agents onchain & offchain
**Author:** rayQu
**Published:** October 24, 2025

## Overview
Proposed standard defining three on-chain registries (Identity, Reputation, Validation) for discovery and interaction of autonomous agents in a permissionless context, providing minimum primitives for differentiated solutions.

## Key Concepts

### Three Registries
- **Identity Registry**: Unique ID, address, domain pointer; capabilities stored off-chain
- **Reputation Registry**: Authorized client feedback with on-chain audit trail, off-chain data
- **Validation Registry**: Supports crypto-economic staking, TEEs/ZK, or social consensus

### Why It Matters
- Shared namespace making agents discoverable by other agents
- Modular trust models (feedback, staking, or hardware enclaves)
- Minimal and future-proof spec with no lock-in

### ROFL Integration
Deploy agent logic into TEE enclave, get cryptographic attestations, register via ERC-8004, optionally register staking validators for higher-assurance tasks.

### What You Can Build
- Task-trading marketplaces (code review bots, DeFi strategy executors)
- Validation systems with off-chain TEE/ZK audits registered on-chain
- Cross-agent collaboration networks with portable reputation
