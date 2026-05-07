---
title: "MCP tool spoofing succeeds 100% of the time: 12 security risks across 4 agent protocols"
url: "https://dev.to/n_asuy/mcp-tool-spoofing-succeeds-100-of-the-time-a-new-paper-maps-12-security-risks-across-4-agent-6i3"
author: "nasuy"
category: "a2a-protocols"
---

# MCP Tool Spoofing: 12 Security Risks Across 4 Agent Protocols
**Author:** nasuy
**Published:** March 15, 2026

## Overview
Analysis of a February 2026 paper from the Canadian Institute for Cybersecurity and Mastercard identifying security vulnerabilities across MCP, A2A, Agora, and ANP protocols.

## Key Concepts

### Four Protocols Analyzed
- **MCP** (Anthropic): Production-ready, OAuth 2.1
- **A2A** (Google): Agent-to-agent, draft stage
- **Agora**: Research-stage meta-protocol
- **ANP**: Network layer using W3C DID

### 12 Risks in Three Lifecycle Phases
**Creation:** Weak identity, missing data integrity, no namespace separation, undefined policies
**Operation:** Insufficient execution verification, overly broad permissions, absent rate limiting
**Update:** Inactive credentials, missing rollback protection, unsigned packages, dependency drift

### Tool Spoofing Experiment
When multiple servers share identical tool names:
- First-match mode: **100% failure rate**
- Best-match mode: **52% failure rate**

Without cryptographic signatures, tool spoofing works reliably.

### Recommendations
Cryptographic signatures for tool identity, supply chain security, least-privilege defaults, MITRE ATLAS monitoring.
