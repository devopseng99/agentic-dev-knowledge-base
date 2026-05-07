---
title: "Why AI Broke Your Rate Limits -- And What to Do About It"
url: "https://dev.to/slickstef11/why-ai-broke-your-rate-limits-and-what-to-do-about-it-3a84"
author: "Stefan"
category: "ai-agent-rate-limiting"
---

# Why AI Broke Your Rate Limits -- And What to Do About It

**Author:** Stefan
**Published:** April 25, 2025

## Overview
Rate limiting was built for browsers and apps with people clicking buttons. AI agents call APIs independently, make decisions, pull data, and post content. Traditional safeguards do not adequately protect against misuse of API data by AI clients.

## Key Concepts

### The Core Problem
Traditional rate limiting restricts frequency of access. For AI agents, the issue is how data is utilized, not just how often it is accessed.

### Harm Limiting (Proposed Solution)
Instead of restricting frequency, tag API responses with contextual metadata:
- Data safety for public reuse
- Requirements for human review before publication
- Internal-only usage designations

### Key References
- **Model Context Protocol (MCP):** Anthropic's framework for agents to negotiate access with defined boundaries
- **Microsoft AI Shared Responsibility Model:** Distributes accountability across stakeholders
- **MAESTRO Framework:** Cloud Security Alliance tool for AI-specific threat modeling

### Recommendation
Build API-level guidance into responses -- structured, machine-readable metadata that influences responsible AI behavior without blocking access entirely.
