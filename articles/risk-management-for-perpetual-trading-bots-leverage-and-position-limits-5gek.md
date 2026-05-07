---
title: "Risk Management for Perpetual Trading Bots: Leverage and Position Limits"
url: "https://dev.to/walletguy/risk-management-for-perpetual-trading-bots-leverage-and-position-limits-5gek"
author: "Wallet Guy"
category: "web3-blockchain-agents"
---

# Risk Management for Perpetual Trading Bots: Leverage and Position Limits

**Author:** Wallet Guy
**Published:** May 3, 2026

## Overview

Without proper leverage limits and position controls, even profitable strategies can blow up accounts during extreme price moves or flash crashes. WAIaaS provides 21 policy types across 4 security tiers.

## Three Core Perpetual Policies

1. **PERP_MAX_LEVERAGE** - Per-market tiers: BTC-USD 3x, ETH-USD 4x, ALT-USD 2x
2. **PERP_MAX_POSITION_USD** - Caps position sizes with individual market limits
3. **PERP_ALLOWED_MARKETS** - Restricts trading to approved contracts only

## Additional Risk Controls

- SPENDING_LIMIT circuit breakers: $1K instant, $5K notify, $20K delay, above requires approval
- RATE_LIMIT: 100 transactions per hour maximum
- ACTION_CATEGORY_LIMIT: Isolates spending budgets by protocol type

## Integration Features

- Native Hyperliquid support for perpetual and spot trading
- Gas-conditional execution
- Transaction dry-run API for testing
- Cross-protocol position tracking across 15 DeFi protocols
