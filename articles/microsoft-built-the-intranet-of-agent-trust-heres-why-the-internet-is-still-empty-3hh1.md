---
title: "Microsoft Built the Intranet of Agent Trust. Here's Why the Internet Is Still Empty."
url: "https://dev.to/piiiico/microsoft-built-the-intranet-of-agent-trust-heres-why-the-internet-is-still-empty-3hh1"
author: "Pico"
category: "startup-monetization"
---
# Microsoft Built the Intranet of Agent Trust. Here's Why the Internet Is Still Empty.
**Author:** Pico  **Published:** 2026-04-16

## Overview
Microsoft's Agent Governance Toolkit (AGT) has excellent internal infrastructure but lacks cross-organizational agent trust systems. This mirrors 1990s corporate intranets: excellent internal security but useless for external transactions.

## Key Concepts

### What AGT Gets Right (Inter-Agent Trust Protocol / IATP)

1. **Cryptographic Identity** — Every agent receives an Ed25519 keypair, eliminating ambiguity about request origins.
2. **Behavioral Trust Scoring** — Agents undergo real-time evaluation based on actions, policy compliance, and peer vouching.
3. **Runtime Enforcement** — Policy engines between agents and actions, supporting YAML, OPA Rego, and Cedar policy languages.

### The Boundary Problem
AGT excels within organizations but falters externally. Third-party agents start with trust score = 0, regardless of track record elsewhere.

**The Cold-Start Problem:**
- External agents start with score = 0
- Meaningful scores require time in your environment
- Scores don't transfer across organizations
- Veteran agents serving thousands of organizations appear identical to fresh malicious agents

### Historical Parallels That Solve This
- **Email reputation** — Spam filters aggregate sender signals across millions of sources
- **TLS certificates** — CA/Browser Forum established interorganizational trust verification
- **Credit scores** — Financial history aggregation enables instant trust assessment with unknown institutions

### Requirements for Cross-Org Trust

1. **Persistent portable identity** — Credentials verifiable across deployments
2. **Behavioral telemetry aggregation** — Signals from multiple organizations combined while preserving privacy
3. **Cold-start signals** — Initial trust bootstrapping via developer identity, commit history, certifications, or peer vouching
4. **Zero-knowledge architecture** — Aggregation systems cannot access individual interactions, only derived trust scores

### Implications for Builders
- Deploy AGT for internal governance
- Issue portable credentials (EdDSA/JWTs with public endpoints)
- Prepare for trust graph competition — organizations with established cross-org reputations gain advantages
