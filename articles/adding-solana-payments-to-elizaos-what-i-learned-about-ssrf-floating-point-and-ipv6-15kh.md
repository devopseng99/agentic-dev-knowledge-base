---
title: "Adding Solana Payments to ElizaOS: What I Learned About SSRF, Floating-Point, and IPv6"
url: "https://dev.to/gen_ishinabe/adding-solana-payments-to-elizaos-what-i-learned-about-ssrf-floating-point-and-ipv6-15kh"
author: "Gen.ishinabe"
category: "web3-blockchain-agents"
---

# Adding Solana Payments to ElizaOS: What I Learned About SSRF, Floating-Point, and IPv6
**Author:** Gen.ishinabe
**Published:** March 6, 2026

## Overview
Documents integrating Solana USDC payment support into ElizaOS via x402 protocol, encountering and solving IPv6 SSRF bypass, floating-point precision bugs, and redirect chain exploits.

## Key Concepts

### IPv6 SSRF Prevention

```javascript
const hex = address.split("::ffff:")[1]; // "7f00:1"
const parts = hex.split(":");
const hi = parseInt(parts[0], 16);
const lo = parseInt(parts[1] || "0", 16);
const ipv4 = `${(hi >> 8) & 0xff}.${hi & 0xff}.${(lo >> 8) & 0xff}.${lo & 0xff}`;
```

Node.js converts IPv4-mapped IPv6 addresses to hex, bypassing regex-based security checks.

### Floating-Point Bug
Math.floor(0.005 * 1_000_000) returns 4999 instead of 5000 due to IEEE 754. Math.round fixes it and prevents silent payment rejections.

### Security Measures
- Redirect chains: Fixed via redirect: "error"
- Content-Length exploits: 4MB streaming caps
- Token validation: Only USDC payments accepted
- Keypair format incompatibilities between @solana/web3.js v1 and @solana/kit v2

```bash
npm install @hugen/plugin-x402-solana
```
