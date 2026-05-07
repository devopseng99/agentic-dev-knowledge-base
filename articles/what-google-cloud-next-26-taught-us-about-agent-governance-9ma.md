---
title: "What Google Cloud NEXT 26 Taught Us About Agent Governance"
url: "https://dev.to/bridget_amana/what-google-cloud-next-26-taught-us-about-agent-governance-9ma"
author: "Bridget Amana"
category: "cloud-agents"
---

# What Google Cloud NEXT 26 Taught Us About Agent Governance
**Author:** Bridget Amana
**Published:** April 30, 2026

## Overview
An analysis of agent governance lessons from Google Cloud NEXT '26, where a live demo showed an agent with write access to a financial database being talked into making an unauthorized budget change through normal conversation -- not through a hack, just a user asking nicely. Covers Agent Gateway, Agent Identity, and Model Armor as Google's response.

## Key Concepts

### The Vulnerability Demonstrated
During the Developer Keynote, the Planner Agent had access to a Finance MCP server with both read and write tools, with no policies preventing unauthorized changes. When asked to increase a race budget, the agent complied without restriction.

### The Fix: Agent Gateway Policies
The solution involved navigating to Agent Gateway, selecting the Planner agent, locating the Finance MCP server in its allowed tools, adding a read-only-finance condition (ReadOnly=True), and saving. The same prompt then failed gracefully.

### Agent Identity: Zero-Trust for Agents
Each deployed agent receives a unique cryptographic identity. Policies attach to that identity, and the gateway enforces them on every call -- a zero-trust model rather than service-account master keycards.

### Key Takeaway
Agents behave like eager-to-please interns who will do whatever they are asked unless someone explicitly wrote down that they should not. Organizations deploy agents faster than they define permissions, creating risks where overprivileged agents require only persuasive prompting rather than actual hacking.

### Platform-Level Security
Richard Seroter framed this as requiring platforms to "shift down, not left" on security -- moving responsibility from individual developers to the platform itself.
