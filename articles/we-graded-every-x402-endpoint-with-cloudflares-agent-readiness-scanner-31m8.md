---
title: "We graded every x402 endpoint with Cloudflare's agent-readiness scanner"
url: "https://dev.to/afx/we-graded-every-x402-endpoint-with-cloudflares-agent-readiness-scanner-31m8"
author: "AFX"
category: "web3-blockchain-agents"
---

# We graded every x402 endpoint with Cloudflare's agent-readiness scanner

**Author:** AFX
**Published:** April 29, 2026

## Overview

Cloudflare shipped isitagentready.com -- a public scanner grading URLs for AI-agent readiness on a 0-5 scale across 19 checks. x402station ran it against every active host on the x402 catalog: 549 unique hosts covering 25,950 endpoints.

## Key Findings

- 53.3% of endpoints are at level 0 -- no agent-readiness signals beyond 1995 web servers
- Only 6 hosts (1.5%) have x402 detected by the scanner
- Five small experimental hosts hit level 5 (highest grade), beating Cloudflare's own site (level 4)
- 96.6% of catalog by endpoint reach emits no agent-readiness signals

## Level Distribution

| Level | Hosts | Description |
|-------|-------|-------------|
| 0 | 58.8% | Basic web missing |
| 1 | 9.5% | robots.txt + sitemap |
| 2 | 1.5% | Bot-Aware |
| 3 | 0.2% | Agent-Readable |
| 4 | 0.5% | Agent-Integrated |
| 5 | 0.9% | Agent-Native |

## Volume vs Readiness Anti-Correlation

The five level-5 hosts run 1-2 endpoints each. The top two providers run 20,000+ at level 0/1. lowpaymentfee.com (10,659 endpoints, 41.1% of catalog) is level 0. Hands-on builders out-build big providers.

## Methodology

```javascript
const catalog = await fetch("https://api.agentic.market/services").then((r) => r.json());
const hosts = new Map();
for (const svc of catalog.services) {
  for (const ep of svc.endpoints ?? []) {
    const u = new URL(ep.url);
    if (!hosts.has(u.host)) hosts.set(u.host, ep.url);
  }
}

for (const [host, url] of hosts) {
  const res = await fetch("https://isitagentready.com/api/scan", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ url }),
  });
  await new Promise((r) => setTimeout(r, 20_000));
}
```

## How to Reach Level 5

x402station climbed from level 1 to level 5 in an afternoon + two hours:
- robots.txt with Content-Signal
- MCP server card JSON
- Markdown content negotiation
- Link headers, bazaar extension
- API Catalog (RFC 9727), OAuth stubs (RFC 9728, 8414)

Total cost: ~$0.014 in self-pay USDC.
