---
title: "Controlling Claude Code Expenses: A Comparison of Enterprise AI Gateways"
url: "https://dev.to/kuldeep_paul/controlling-claude-code-expenses-a-comparison-of-enterprise-ai-gateways-3fjj"
author: "Kuldeep Paul"
category: "ai-gateway"
---

# Controlling Claude Code Expenses: A Comparison of Enterprise AI Gateways
**Author:** Kuldeep Paul
**Published:** April 4, 2026

## Overview
Compares five AI gateways for enterprise Claude Code cost governance: Bifrost, Cloudflare AI Gateway, Kong AI Gateway, OpenRouter, and LiteLLM.

## Key Concepts

### Bifrost Setup
```bash
export ANTHROPIC_BASE_URL=http://your-bifrost-instance:8080/anthropic
export ANTHROPIC_API_KEY=your-bifrost-virtual-key
```
Four-level budget structure: Organization, Department, Virtual Key, Route. 11 microseconds per call at 5,000 concurrent requests.

### OpenRouter Setup
```bash
export ANTHROPIC_BASE_URL=https://openrouter.ai/api
export ANTHROPIC_API_KEY=your-openrouter-key
```

### LiteLLM Setup
```bash
export ANTHROPIC_BASE_URL=http://0.0.0.0:4000
export ANTHROPIC_AUTH_TOKEN=$LITELLM_MASTER_KEY
```
