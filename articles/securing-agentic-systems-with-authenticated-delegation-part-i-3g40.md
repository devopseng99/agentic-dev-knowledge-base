---
title: "Securing Agentic Systems with Authenticated Delegation - Part I"
url: "https://dev.to/uenyioha/securing-agentic-systems-with-authenticated-delegation-part-i-3g40"
author: "Ugo Enyioha"
category: "oauth-agents"
---

# Securing Agentic Systems with Authenticated Delegation - Part I
**Author:** Ugo Enyioha
**Published:** April 9, 2025

## Overview
Framework extending OAuth 2.0/OpenID Connect for AI agent authenticated delegation using a three-token architecture.

## Key Concepts

### Three-Token Architecture
1. **User's ID-token**: Standard OIDC token for human identity
2. **Agent-ID token**: Verifiable information about the AI agent (capabilities, vendor, identifiers)
3. **Delegation Token**: Cryptographically binds user, agent, and approved scope with validity conditions

### Threat Mitigations
- Confused Deputy: explicit scope limitations
- Memory poisoning: context-specific credentials
- Tool misuse: granular resource controls
- Privilege escalation: enforced least privilege
- Identity spoofing: verifiable cryptographic linkage

### Key Distinction
While workload identity establishes agent identity and API security provides resource protection, authenticated delegation fills the gap by linking user authorization, agent identity, and scoped permissions into a verifiable chain of trust.
