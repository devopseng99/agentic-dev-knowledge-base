---
title: "I built a memory API that AI agents can pay for"
url: "https://dev.to/pat9000/i-built-a-memory-api-that-ai-agents-can-pay-for-3p0i"
author: "Patrick Hughes"
category: "web3-blockchain-agents"
---

# I built a memory API that AI agents can pay for

**Author:** Patrick Hughes
**Published:** April 29, 2026

## Overview

A payment-enabled memory API where AI agents store, recall, and delete data by making HTTP calls and paying in USDC on Base blockchain. "An LLM just paid me $0.001 to remember something. The agent has no account, no API key, no credit card."

## How It Works

1. Agent calls `POST /api/memory/store` without authentication
2. Server responds with 402 Payment Required, quoting price (1000 atomic USDC)
3. Agent's wallet signs EIP-3009 `TransferWithAuthorization` transaction
4. Agent encodes signature in `X-PAYMENT` header and replays request
5. Edge middleware verifies signature; transfer broadcasts on-chain
6. Memory stores; server returns 200 OK

Complete process takes approximately three seconds. USDC arrives within ten seconds.

## Significance

This eliminates traditional barriers: "The signature was the access. The vendor never learned who I was and never needed to." Enables agents to access services across the open web without account signup or API key provisioning.

Extends to memory services, search, inference, vector databases, and other agent tools priced at the protocol layer.
