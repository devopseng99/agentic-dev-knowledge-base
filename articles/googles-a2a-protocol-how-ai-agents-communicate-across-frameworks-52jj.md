---
title: "Google's A2A Protocol: How AI Agents Communicate Across Frameworks"
url: https://dev.to/agentsindex/googles-a2a-protocol-how-ai-agents-communicate-across-frameworks-52jj
author: Agents Index
category: a2a-protocol
---

# Google's A2A Protocol: How AI Agents Communicate Across Frameworks

**Author:** Agents Index
**Published:** April 24, 2026
**Original Source:** agentsindex.ai

---

## Overview

The Agent2Agent Protocol (A2A) is an open communication standard developed by Google and released April 9, 2025, enabling AI agents to discover, authenticate, and delegate tasks across different frameworks. Governed by the Linux Foundation with 150+ organizational supporters, A2A operates over HTTP/JSON-RPC 2.0 with five official language SDKs.

---

## Key Concepts

### What A2A Does

A2A facilitates agent-to-agent task delegation through three phases: capability discovery via JSON Agent Cards, authentication using OAuth 2.0/OIDC, and structured task execution with artifact exchange. The protocol implements an "opaque agent" model where remote agents never expose internal tools—only declared capabilities and outputs.

### A2A vs. MCP

| Dimension | MCP (Anthropic) | A2A (Google) |
|-----------|-----------------|--------------|
| **Purpose** | Connect agents to tools/data | Connect agents to agents |
| **Direction** | Vertical (agent → tool) | Horizontal (agent ↔ agent) |
| **Transport** | JSON-RPC over stdio/HTTP SSE | HTTP/JSON-RPC 2.0 with SSE/webhooks |
| **Best for** | Tool access & capabilities | Multi-agent coordination |

A2A and MCP are complementary layers, not competitors.

---

## Technical Implementation

### Discovery Via Agent Cards

Agents publish capabilities at `/.well-known/agent.json` declaring supported task types, communication modalities (text, audio, video), authentication requirements, and endpoint URLs. No centralized registry required.

### Communication Patterns

- **Synchronous**: Request/response for quick operations
- **Streaming**: Server-Sent Events for incremental results
- **Asynchronous**: Webhooks for long-running workflows

### Task Lifecycle States

The protocol defines five states: submitted, working, input-required, completed, and failed.

---

## Ecosystem Support

**Founding Partners (50+):** Atlassian, Salesforce, SAP, ServiceNow, PayPal, Workday, Accenture, BCG, Deloitte, McKinsey, PwC

**Post-Linux Foundation Growth:** 150+ organizations including IBM (whose competing ACP merged with A2A in 2025)

**Official SDKs:** Python, Go, JavaScript, Java, .NET

---

## Security Considerations

Research identified vulnerabilities in baseline A2A implementations. Per arXiv:2505.12490, unprotected agents showed "60% to 100% data leakage under prompt injection attacks." Enhanced security patterns address this through:

- Ephemeral tokens (30-second to 5-minute validity)
- Granular per-operation OAuth scopes
- Explicit consent orchestration
- USER_CONSENT_REQUIRED task state

Implementing these patterns achieved zero data leakage across 45 test attempts.

**Deployment Guidance:**
- Internal tooling: baseline A2A sufficient
- Cross-team coordination: enhanced security recommended
- PII/payments/identity: enhanced security required

---

## Key Takeaways for Developers

1. **Use A2A for agent-to-agent delegation; pair with MCP for agent-to-tool connections**
2. **Implement Agent Cards before anything else**
3. **Apply enhanced security patterns for sensitive workloads**
4. **Leverage five official SDKs rather than building custom integrations**
5. **Google ADK defaults to A2A—you're using it implicitly**

**Implementation Timeline:** Developers report reaching functional first message exchange within 1–2 hours of starting implementation.

---

## Market Context

Search interest accelerated significantly: 'a2a protocol' grew 22% month-over-month and 52% quarter-over-quarter as of April 2026. The protocol consolidation parallels historical infrastructure standardization cycles (TCP/IP, Kubernetes, OpenTelemetry).
