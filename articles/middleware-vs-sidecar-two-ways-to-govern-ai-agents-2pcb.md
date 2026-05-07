---
title: "Middleware vs Sidecar: two ways to govern AI agents"
url: "https://dev.to/fl7_93dc7dc638d86979/middleware-vs-sidecar-two-ways-to-govern-ai-agents-2pcb"
author: "Marc Verchiani"
category: "flink-kafka-agents"
---

# Middleware vs Sidecar: two ways to govern AI agents
**Author:** Marc Verchiani
**Published:** April 6, 2026

## Overview
Comparison of two governance approaches for AI agents: Microsoft AGT (middleware, runs inside agent process) vs agent-mesh (sidecar proxy, intercepts at protocol level). Maps both to OWASP Agentic Top 10 security risks. Author built governance layers for Kafka and Kong before building agent-mesh.

## Key Concepts

### agent-mesh Configuration

```yaml
policies:
  - name: claude
    agent: "claude"
    rules:
      - tools: ["filesystem.read_*", "filesystem.list_*"]
        action: allow
      - tools: ["filesystem.write_file"]
        action: human_approval
      - tools: ["filesystem.move_file"]
        action: deny
  - name: default
    agent: "*"
    rules:
      - tools: ["*"]
        action: deny    # fail closed
```

### Integration

```bash
claude mcp add agent-mesh -- ./agent-mesh --mcp --config config.yaml
```

### Architecture

```
Agent CLI / Framework
     |
AI Gateway (Kong/Gravitee) <- LLM routing, PII, rate limits
     |
Governance Mesh (agent-mesh) <- semantic policy, agent identity, trace
     |
Tools (GitHub, DB, APIs)
```

### Middleware vs Sidecar Decision
- **Middleware**: Own the code, single framework, sub-ms overhead
- **Sidecar**: Heterogeneous agents (CLI + frameworks), unified YAML policy, no code changes

Protocol-level wins long-term -- same way Envoy won over framework-specific circuit breakers. Nobody runs just one framework.

GitHub: [agent-mesh](https://github.com/KTCrisis/agent-mesh)
