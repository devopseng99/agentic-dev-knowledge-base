---
title: "A2A: How AI Agents Communicate"
url: "https://dev.to/alisterbaroi/a2a-how-ai-agents-communicate-35d5"
author: "Alister Baroi"
category: "a2a-protocols"
---

# A2A: How AI Agents Communicate
**Author:** Alister Baroi
**Published:** February 26, 2026

## Overview
Deep dive into A2A protocol on Kubernetes, covering agent discovery, governance, observability, and the complementary technology stack (MCP, agentgateway, x402).

## Key Concepts

### Agents on Kubernetes
AI agents run as pods or deployments, communicating via cluster networks. Frameworks like Kagent define agents as first-class Kubernetes workloads using CRDs.

### A2A Protocol
Remote agents publish Agent Cards (JSON profiles at `/.well-known/agent-card.json`) describing identities, endpoints, authentication, and skills. Clients discover cards, select agents, and send task objects.

### Governance Gap
Organizations need to understand which client agents invoke which skills on which remote agents, over what data, under which permissions. K8s tools remain blind to A2A concepts like tasks, skills, and roles.

### Supporting Technologies
- **MCP**: Standardizes agent connections to tools, APIs, data sources
- **agentgateway**: Data plane for AI agents governing A2A, MCP, and agent-to-LLM traffic
- **x402**: Embeds payments directly into HTTP for agent micropayments
