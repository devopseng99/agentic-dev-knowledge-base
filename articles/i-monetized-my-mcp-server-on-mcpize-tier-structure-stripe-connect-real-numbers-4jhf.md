---
title: "I monetized my MCP server on MCPize: tier structure, Stripe Connect, real numbers"
url: "https://dev.to/sai_93caeceb4f6a4d9969910/i-monetized-my-mcp-server-on-mcpize-tier-structure-stripe-connect-real-numbers-4jhf"
author: "Sai"
category: "startup-monetization"
---
# I monetized my MCP server on MCPize: tier structure, Stripe Connect, real numbers
**Author:** Sai  **Published:** 2026-04-18

## Overview
Launching cipher-x402-mcp, a TypeScript MCP server on MCPize marketplace, using Stripe Connect with 85/15 creator-to-platform split.

## Key Concepts

### The Product
- 8 tools — 7 requiring x402 payments in Base mainnet USDC, 1 free audit tool
- Pricing: $0.005 per breach check to $0.25 per premium playbook chapter
- Stateless relay, never holds caller funds
- GitHub: github.com/cryptomotifs/cipher-x402-mcp

### Platform Selection
Evaluated four directories:
- **Smithery:** Free listing, no monetization
- **mcp.so:** Community index, no billing
- **Pulse.mcp.so:** Similar to mcp.so
- **MCPize:** Selected for Stripe integration, Canadian account support, 15% take

Comparable earnings reference: AWS Security Auditor MCP ($149/month) reportedly achieves ~$8,500/month net revenue.

### Tier Structure

| Tier | Price | Requests/Month |
|------|-------|----------------|
| Free | $0/month | 100 |
| Starter | $9/month | 1,000 |
| Pro | $29/month | 5,000 |
| Team | $99/month | 25,000 |

Overage: $0.005 per request above tier caps.

### Setup Timeline (90 minutes total)
1. Wizard: 4 minutes
2. Stripe Connect OAuth: 12 minutes
3. Listing details: 18 minutes
4. Cover image: 30 seconds
5. Publishing: 1 second

### Future Improvements
- Rename tiers to agent-buyer audience ("Hobby/Indie/Studio/Fleet")
- Add $299 unlimited option
- Enhance cover image with x402 badge

### Key Lesson
Seven-day experiment validated pricing against comparable products before confirmed demand exists.
