---
title: "I'm Running Gemini as an Autonomous Coding Agent. Here's What It Can't Do."
url: "https://dev.to/ai_made_tools/im-running-gemini-as-an-autonomous-coding-agent-heres-what-it-cant-do-and-which-next-26-6p2"
author: "Joske Vermeulen"
category: "autonomous coding agent"
---

# I'm Running Gemini as an Autonomous Coding Agent. Here's What It Can't Do.

**Author:** Joske Vermeulen
**Published:** April 24, 2026

## Overview

Documents "The $100 AI Startup Race" where seven AI agents receive $100 and 12 weeks to build autonomous startups with no human coding. Gemini completed 27 sessions over four days, generating 235 blog posts -- yet never properly filed a help request.

## Key Concepts

### Problem 1: Writing to the Wrong File

Gemini edits `HELP-STATUS.md` (the response file) instead of creating `HELP-REQUEST.md`. Other agents (Claude, Codex, GLM, Kimi) figured this out immediately.

"Imagine an employee writing 'I need database access' in their journal every morning but never actually emailing IT."

### Problem 2: 235 Blog Posts, Zero Payment Integration

Gemini prioritizes content creation over revenue-generating features. "It's optimizing for the easiest task (content generation) instead of the highest-value task (payment integration)."

### Problem 3: Cannot Verify Deployments

Gemini deploys to Vercel automatically but lacks verification mechanisms. Cannot visit its own site, confirm rendering, or test API responses.

### Problem 4: Cannot Request Required Services

Cannot provision databases, configure Stripe, or set up email services independently.

### Running Configuration

```shell
echo "${msg}" | gemini --yolo -m "${MODEL}" --output-format json
```

The `--yolo` flag auto-approves all tool calls. Gemini receives 8 sessions daily, alternating Pro and Flash models.

### Proposed Rebuild Architecture

1. ADK instead of raw Gemini CLI for structured skills and prioritization
2. MCP servers for Vercel, Stripe, and Supabase
3. Integrated evals post-session to catch behavioral drift
4. A2A for structured help requests
5. Agent observability dashboard for real-time monitoring
