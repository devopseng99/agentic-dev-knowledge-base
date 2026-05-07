---
title: "I Told Claude Code to Build an Autonomous DeFi Liquidation Bot. Here's What Actually Happened"
url: "https://dev.to/thebrierfox/i-told-claude-code-to-build-an-autonomous-defi-liquidation-bot-heres-what-actually-happened-41i2"
author: "~K1yle Million"
category: "web3-blockchain-agents"
---

# I Told Claude Code to Build an Autonomous DeFi Liquidation Bot. Here's What Actually Happened

**Author:** ~K1yle Million
**Published:** May 1, 2026

## Overview

The author tasked Claude Code with building an autonomous DeFi strategy on Base that scans for profit opportunities and executes trades when conditions align, with Telegram notifications.

## Versions 1-4: DEX Arbitrage Failure

Initial attempts focused on DEX arbitrage using flash loans. Claude Code correctly implemented pool detection, route scoring, and quote fetching via Balancer V2 flash loans. However, "Flashblocks on Base (100ms block times) means MEV bots are processing opportunities faster than any external scanner can even detect them." After testing 23 pools across 146 routes with zero profitable executions: `best spread = -$1.06 per $1000 flash. Market at equilibrium.`

## The Pivot: Morpho Blue Liquidations

Liquidation opportunities aren't race conditions like DEX arb. When a position crosses the liquidation threshold (health factor < 1.0), it doesn't disappear in 100ms -- it sits there until someone closes it.

## Architecture (v7)

829-line Python daemon with:
- **Borrower indexing:** Seeds from Morpho API (129 borrowers across 5 markets), monitors via `eth_getLogs`
- **Health factor calculation:** Reads supply/borrow shares, converts using market state, fetches oracle prices, computes HF
- **Liquidation execution:** Balancer V2 flash loan repays debt and seizes collateral atomically via `LiquidationExecutor.sol`
- **Watchdog:** Bash loop provides restart capability and Telegram failure alerts

## Critical Bugs and Fixes

### Bug 1: Health Factor Formula Error
Initial computation omitted the oracle price term, making HF dimensionally invalid. Claude Code self-diagnosed via live data testing when logging impossible values like HF=2847391847483.5, rewrote the formula correctly.

### Bug 2: RPC Rate-Limiting
Free-tier Infura exhausted within hours at Base's 2-second block times (400+ calls/minute). Solution: Use public nodes for slow indexing, reserve paid RPC for latency-sensitive multicalls.

### Bug 3: Stale Endpoint
Environment variable changes weren't picked up by running daemon, causing silent 402 errors for 20 hours. Fix: Kill process for watchdog restart with new .env, implement heartbeat logging every 150 blocks.

## Current Status

The daemon runs continuously, tracking 129 borrowers across 5 markets, computing health factors per block. Blockers:
- Hot wallet has 0.001 ETH; liquidations require ~0.009 ETH gas
- All tracked positions currently healthy (HF > 1.0)
- Code is production-ready; capital is the constraint

## Claude Code Assessment

**Succeeded at:** Production-grade event-driven infrastructure from research specs, self-debugging math errors against live data, multi-contract orchestration (Morpho, Chainlink, Balancer, Multicall3), autonomous operation with recovery and monitoring.

**Could not:** Fund gas wallets from zero capital, predict market efficiency saturation before implementation, guarantee correctness on first implementation.
