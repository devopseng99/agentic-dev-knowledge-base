---
title: "Running AI Agents on Cloudflare: Workers, Workflows, and Durable Objects"
url: "https://dev.to/alex_chernysh/running-ai-agents-on-cloudflare-workers-workflows-and-durable-objects-fl"
author: "Alex Chernysh"
category: "ai-agent-cloudflare-workers"
---

# Running AI Agents on Cloudflare: Workers, Workflows, and Durable Objects

**Author:** Alex Chernysh
**Published:** April 21, 2026

## Overview
Bernstein v1.8.4 now supports Cloudflare cloud execution, enabling agents to run on Workers, multi-step tasks via Durable Workflows, artifact storage in R2, and state persistence in D1. This eliminates local machine constraints and allows scaling to 20+ concurrent agents.

## Key Concepts

### Why Local-Only Limits Adoption
- Laptops become bottlenecks for CPU, memory, and network resources
- Long sessions drain battery; closing machine terminates sessions
- Scaling beyond 4-5 concurrent agents on a MacBook hits resource limits

### The Cloudflare Stack
- **Workers:** Handle lightweight, stateless agent execution with sub-50ms cold-start times
- **Durable Workflows:** Orchestrate multi-step tasks with automatic retries and resumption
- **R2:** Stores agent outputs (diffs, test results, generated files)
- **D1:** Maintains orchestration state, task queues, agent assignments, cost metrics, audit logs

### Architecture
The orchestrator runs as a Worker with a Durable Object maintaining tick state. Agent Workers spawn per-task and communicate results through R2 and D1.

## Code Examples

### Deploying the Cloud Stack

```bash
# Authenticate with Cloudflare
wrangler login

# Deploy the Bernstein cloud stack
bernstein cloud deploy --project my-project

# This creates:
#   - Orchestrator Worker + Durable Object
#   - R2 bucket: bernstein-my-project-artifacts
#   - D1 database: bernstein-my-project-state
#   - Workflow definitions for multi-step tasks
```

### Running Tasks

```bash
# Run a goal on cloud infrastructure
bernstein run --goal "Refactor auth module" --cloud

# Monitor from your terminal
bernstein cloud status

# Or check the dashboard
bernstein dashboard --cloud
```

### Cost Considerations
For a typical 50-task session:
- Workers compute: ~$0.50-2.00
- R2 storage: minimal (small artifacts)
- D1 reads/writes: minimal (lightweight operations)

Cloud infrastructure costs represent a small fraction of LLM API expenses.
