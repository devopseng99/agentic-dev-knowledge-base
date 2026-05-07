---
title: "The New OAuth Problem Is Agent Delegation"
url: "https://dev.to/maninderpreet_singh/the-new-oauth-problem-is-agent-delegation-44hc"
author: "Maninderpreet Singh"
category: "oauth-agents"
---

# The New OAuth Problem Is Agent Delegation
**Author:** Maninderpreet Singh
**Published:** May 4, 2026

## Overview
AI agents introduce a novel security challenge beyond traditional OAuth frameworks. The traditional OAuth model breaks down when agents plan, delegate, chain tools, invoke other agents, and operate over time.

## Key Concepts

### Four Common Failures
1. Service-account skeleton keys: Broad backend credentials collapse user intent with service privilege
2. Over-delegated child agents: Specialist agents inherit parent authority rather than narrower task-specific grants
3. Single-hop trust: Downstream APIs verify only immediate callers, ignoring delegation chain validity
4. Unmodeled revocation: Withdrawn authority may persist in queued jobs

### Proposed Solutions
Proof-carrying delegation patterns (OAuth Token Exchange, Macaroons, Biscuit tokens). Delegation artifacts should carry:
- Agent identity and authorizing entity
- Specific task boundaries
- Delegation depth limits
- Verifiable attenuation at each hop
- Expiration and revocation propagation mechanisms

### Design Principles
- Short-lived, task-bound authority
- Attenuating delegation hierarchies
- Machine-verifiable provenance
- Explicit delegation depth limits
- Cascade revocation semantics
