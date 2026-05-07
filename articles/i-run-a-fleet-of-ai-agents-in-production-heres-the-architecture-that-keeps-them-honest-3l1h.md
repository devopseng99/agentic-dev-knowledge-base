---
title: "I Run a Fleet of AI Agents in Production — Here's the Architecture That Keeps Them Honest"
url: "https://dev.to/nesquikm/i-run-a-fleet-of-ai-agents-in-production-heres-the-architecture-that-keeps-them-honest-3l1h"
author: "Mike"
category: "immutable-arch-rust-flink"
---
# I Run a Fleet of AI Agents in Production — Here's the Architecture That Keeps Them Honest
**Author:** Mike  **Published:** February 27, 2026

## Overview
Production fleet of specialized AI agents with sidecar proxy pattern, append-only immutable logging, and model stratification. Monthly fleet costs under $500 despite hundreds of daily tasks. Every prompt-response is logged to an append-only store for full auditability.

## Key Concepts
- **One Agent, One Job**: Crash tracker, analytics agent, telemetry analyzer, code reviewer, channel scanner, PR creator
- **Model Stratification**: 80% small models (Haiku-tier), 20% frontier models — ~$0.02 per task
- **Sidecar Proxy Pattern**: Every agent container has co-located proxy mediating all external communication
- **Append-only Logging**: Full prompt-response capture with correlation IDs

Sidecar proxy request format:
```json
{
  "action": "query",
  "service": "analytics",
  "params": { "metric": "dau", "range": "7d" },
  "workflow_id": "wf-7829",
  "agent": "analytics-agent"
}
```

E2E Workflow: telemetry spike → pull request in ~4 minutes, cost <$0.30, human time: 2 minutes for review.

Proxy enforces: request validation against role definitions, authentication injection, rate limits, metadata stripping before returning data to agent.

Agents never access credentials directly or discover available services through enumeration.
