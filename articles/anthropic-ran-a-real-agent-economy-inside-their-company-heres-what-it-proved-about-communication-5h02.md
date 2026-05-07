---
title: "Anthropic Ran a Real Agent Economy Inside Their Company. Here's What It Proved About Communication."
url: "https://dev.to/kavinkimcreator/anthropic-ran-a-real-agent-economy-inside-their-company-heres-what-it-proved-about-communication-5h02"
author: "Kavin Kim"
category: "startup-monetization"
---
# Anthropic Ran a Real Agent Economy Inside Their Company. Here's What It Proved About Communication.
**Author:** Kavin Kim  **Published:** 2026-04-26

## Overview
Anthropic's "Project Deal" in December 2025: AI agents deployed to 69 employees through a Slack-based marketplace. Agents autonomously negotiated transactions, completing 186 deals worth over $4,000 in real goods without human intervention.

## Key Concepts

### Critical Finding
Agents running Claude Opus 4.5 consistently outperformed those using Claude Haiku 4.5. Notably, "the people paired with weaker agents had no idea they were losing out" — revealing an invisible information asymmetry problem.

### The Infrastructure Gap
While the experiment validated agent negotiation capability, it exposed a critical limitation: Slack, designed for human communication, cannot scale agent-to-agent interactions. "Slack is built for humans. It has rate limits, workspace boundaries, message threading designed for human cognition."

### Proposed Solution
rosud-call, an npm package enabling agent-native communication across platforms and model vendors. The package facilitates:
- Broadcast offers to agent networks
- Process responses in real-time across providers
- Confirm transactions autonomously

### Code Pattern
The article demonstrates procurement and vendor agents publishing service requests and responding to bids using standardized messaging protocols, eliminating custom integration requirements.

### Key Takeaway
Agent-to-agent communication requires purpose-built infrastructure separate from human communication tools.
