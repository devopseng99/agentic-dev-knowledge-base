---
title: "Best Ways to Monitor Claude Code Token Usage and Costs in 2026"
url: "https://dev.to/kuldeep_paul/best-ways-to-monitor-claude-code-token-usage-and-costs-in-2026-5j3"
author: "Kuldeep Paul"
category: "ai-gateway"
---

# Best Ways to Monitor Claude Code Token Usage and Costs in 2026
**Author:** Kuldeep Paul
**Published:** March 15, 2026

## Overview
Covers monitoring strategies for Claude Code token usage at organizational scale using LLM gateways as control planes.

## Key Concepts

### The Problem
Claude Code stores usage data locally in `~/.claude/projects/`, preventing aggregation across developers. No proactive limits, threshold alerts, or budget enforcement.

### Bifrost Setup

```shell
export ANTHROPIC_API_KEY=your-bifrost-virtual-key
export ANTHROPIC_BASE_URL=http://localhost:8080/anthropic
```

Bifrost exposes Prometheus metrics: `bifrost_input_tokens_total`, `bifrost_output_tokens_total`, `bifrost_cost_total`. Virtual Keys enable per-developer, per-team cost attribution. Hierarchical budget controls block requests when thresholds are exceeded.

### Cloudflare AI Gateway
Teams configure `ANTHROPIC_BASE_URL` pointing to Cloudflare endpoints. Supports exact match caching, but lacks per-developer cost attribution and hierarchical budget controls.
