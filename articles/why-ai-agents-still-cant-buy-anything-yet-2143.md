---
title: "Why AI agents still can't buy anything yet"
url: "https://dev.to/emmanuel39hanks/why-ai-agents-still-cant-buy-anything-yet-2143"
author: "Emmanuel Haankwenda"
category: "web3-blockchain-agents"
---

# Why AI agents still can't buy anything yet

**Author:** Emmanuel Haankwenda
**Published:** May 7, 2026

## Overview

The article examines why current AI agents lack the infrastructure to autonomously conduct transactions on the open internet. While "AI agents" are often just chatbots with tools, true autonomous systems require fundamentally different web primitives than those designed for human users.

## Key Missing Capabilities

1. **Autonomous Wallets** - Real money agents can move programmatically (not API keys or credit cards)
2. **Machine Identity** - Systems to identify agents, verify permissions, and assess reputation
3. **Dynamic HTTP Billing** - Payment negotiation within request/response cycles, eliminating signup flows
4. **Portable Memory** - Agent-owned data storage independent of platform providers
5. **Defensible Decisions** - Cryptographic proof of agent reasoning for audit trails

## Emerging Protocol Solutions

**x402 (Coinbase):** Revives the HTTP 402 "Payment Required" status code. Servers respond with pricing; agents sign ERC-3009 authorizations; resources unlock without account creation.

**OKX APP:** Extends x402 with deferred aggregation (batching 100 payments into one settlement) and session-based budgets for long-running workflows.

**ERC-3009:** Gasless USDC signing standard eliminating agent ETH requirements.

**0G Stack:** Provides verifiable receipts through decentralized storage (content-addressed hashing) and on-chain anchoring, creating three-layer proof trails.

**TEE-Backed Inference:** Hardware-isolated computation preventing model providers from viewing sensitive business logic or prompts.

## Reference Implementation: Coal

The author built Coal as a working demonstration running on Base + 0G, integrating:
- Agent-discoverable merchant catalogs on 0G Storage
- Dual protocol support (x402-v1 and app-v2)
- USDC settlement with ~2-second confirmation
- Receipt anchoring on 0G Chain
- Policy decisions in TEEs

## Remaining Challenges

- Fragmented discovery (no unified "Google for agent services")
- Immature agent reputation systems
- Complex cross-chain user experience
- Early async billing implementation
- Rough TEE developer tooling

Infrastructure is finally enabling a shift from orchestration-focused agents toward autonomous payments, machine-native identity, and verifiable decisions.
