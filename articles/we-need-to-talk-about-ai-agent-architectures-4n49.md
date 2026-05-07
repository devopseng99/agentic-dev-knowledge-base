---
title: "We Need To Talk About AI Agent Architectures"
url: "https://dev.to/aws/we-need-to-talk-about-ai-agent-architectures-4n49"
author: "Morgan Willis"
category: "agent-microservices"
---

# We Need To Talk About AI Agent Architectures

**Author:** Morgan Willis
**Published:** December 8, 2025

## Overview
Many developers are wiring UIs directly to their agents as if the agent runtime is the entire backend. This article argues that the agent itself is not the system -- it is a capability inside the system.

## Key Concepts

### Why Direct Client-to-Agent Architecture Fails

1. **Cost and traffic control issues** - Without upstream boundaries, no mechanism for rate limiting or load shedding
2. **Monolithic deployment blast radius** - All changes exist in one unit, slowing iteration
3. **Brittle refactoring** - Single entrypoints eliminate natural separation points

### Architectural Responsibilities

**Upstream layers should handle:** Input validation, rate limiting, core business logic, service orchestration, workflow state and durability

**Agents should handle:** LLM invocation, tool selection logic, session state and memory

**Tools should handle:** Data reading/writing, system queries, deterministic code execution, API invocation

### Three AWS Architecture Patterns

**1. Minimal API Gateway Pattern**
Client -> API Gateway + WAF -> AgentCore Runtime -> Downstream services
Use when moving from prototype to production with basic security needs.

**2. Traditional Backend + Agent Pattern**
Client -> Load Balancer + WAF -> Web servers -> AgentCore Runtime -> Downstream services
Use when integrating with existing backends or complex orchestration needs.

**3. Deep Automation Pattern**
EventBridge -> Step Functions -> Lambda -> AgentCore Runtime -> Downstream systems
Use when backend processes drive agent value, not chat UIs.

## Key Principle
The agent is the brain. The architecture is the body. You need both.
