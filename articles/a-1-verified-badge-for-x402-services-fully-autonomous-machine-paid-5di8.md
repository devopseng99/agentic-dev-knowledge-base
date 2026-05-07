---
title: "A $1 verified-badge for x402 services -- fully autonomous, machine-paid"
url: "https://dev.to/afx/a-1-verified-badge-for-x402-services-fully-autonomous-machine-paid-5di8"
author: "AFX"
category: "web3-blockchain-agents"
---

# A $1 verified-badge for x402 services -- fully autonomous, machine-paid

**Author:** AFX
**Published:** May 2, 2026

## Overview

A verification endpoint on x402station for service operators. Costs $1 USDC, provides a 30-day signed certificate plus embeddable badge. The badge automatically re-validates on each render. Currently 59 endpoints meet eligibility criteria.

## The Problem

Of ~35,000 active endpoints probed every 10 minutes, approximately 17% are problematic -- honeypots, zombie services, and defunct endpoints. Legitimate x402 services appear identical to scam services from an agent's perspective.

## What $1 Gets You

```json
{
  "url": "https://your-endpoint.example.com/route",
  "name": "Your Service"
}
```

Response includes: certId, verified status, tier designation (verified or verified_plus), badgeUrl (SVG), pageUrl, htmlSnippet, and validUntil (30 days).

## Audit Criteria

Five predicates evaluated continuously:
- probes_7d >= 20 (sufficient signal volume)
- uptime_7d_pct >= 95% (agent call reliability)
- No active critical signals
- latency_p99_ms <= 5000 (prevents agent timeouts)
- price_usdc between $0.0001 and $5

## Verification Tiers

**Verified:** Passes all five baseline criteria.
**Verified Plus:** Baseline plus Coinbase CDP confirmation of >= 1 paid transaction within 30 days.

## Machine-to-Machine Architecture

1. Operator's CI bot signs X-PAYMENT header with wallet private key
2. Payment verified via Coinbase CDP facilitator
3. Certificate inserted; response includes embed-ready URLs
4. CI bot stores badge URL in environment files

## Distribution

- Machine-readable manifest at .well-known/x402
- OpenAPI specification (12 operations)
- A2A agent card (8 skills)
- Coinbase Bazaar auto-indexing
- MCP tool surface coming in v1.1.0
