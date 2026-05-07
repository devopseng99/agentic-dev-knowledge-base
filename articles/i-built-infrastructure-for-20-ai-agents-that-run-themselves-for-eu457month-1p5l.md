---
title: "I Built Infrastructure for 20 AI Agents That Run Themselves - For 4.57 Euro per Month"
url: "https://dev.to/vystartasv/i-built-infrastructure-for-20-ai-agents-that-run-themselves-for-eu457month-1p5l"
author: "Vilius"
category: "llmops-infra"
---

# I Built Infrastructure for 20 AI Agents That Run Themselves
**Author:** Vilius
**Published:** May 5, 2026

## Overview
Self-sustaining infrastructure supporting 20 autonomous AI agents on a Hetzner CX23 VPS for under 5 EUR/month. Includes Knowledge API, LLM config registry, operations layer, and a 10-pattern methodology developed over 5 months.

## Key Concepts

### Infrastructure Components
- **workswithagents.dev** - Knowledge API for agent queries (facts, skills, known issues)
- **workswithagents.io** - Registry of verified LLM configurations with hardware-specific performance
- **workswithagents.com** - Educational content and methodology
- **bastiongateway.com** - Operations layer (licensing, monitoring, agent proxying)

### 10-Pattern Methodology
1. **Boot** - Initial session setup with documentation and foundational memory
2. **Skills** - 153 queryable reusable procedural knowledge items
3. **Memory** - Persistent facts preventing repeated explanations
4. **Decision Protocols** - Autonomous vs approval-required actions
5. **Tool Composition** - Optimal tool selection per task
6. **Orchestration** - Parallel specialist agents (3x throughput)
7. **Pipelines** - Background processes via cron without human intervention
8. **Resilience** - Continuous operation with error recovery
9. **Verify** - Automated validation (77% pass rate across 61 tests)
10. **Compounding** - Knowledge accumulation for qualitative improvement

### Results
- 20 autonomous agents managing self-improvement cycles
- 111 web parts and 5 backend services scaffolded autonomously in 3 days
- Zero human intervention across 11 consecutive builds
- Cross-agent error detection and correction
