---
title: "I Needed a Workflow Engine for AI Agents. None of Them Fit. So I Built One."
url: "https://dev.to/ubcent/i-needed-a-workflow-engine-for-ai-agents-none-of-them-fit-so-i-built-one-mjf"
author: "Dmitry Bondarchuk"
category: "multi-cloud-durable"
---

# I Needed a Workflow Engine for AI Agents. None of Them Fit. So I Built One.
**Author:** Dmitry Bondarchuk
**Published:** March 27, 2026

## Overview
Traditional workflow engines (Airflow, Temporal, BullMQ) require knowing steps upfront via fixed DAGs. AI agent workflows need a "living graph" where nodes spawn additional nodes during execution based on outputs. Introduces Grael, a Go-based workflow engine implementing this pattern.

## Key Concepts

The living graph concept -- nodes spawn additional nodes during execution:

```
Workflow starts:
  [scout] -> ???

Scout runs, analyzes codebase, returns:
  output: { complexity: "high", touchedModules: ["payments", "api"] }
  spawn: [
    { id: "council",   dependsOn: ["scout"] },
    { id: "implement", dependsOn: ["council"] },
    { id: "sec-review",dependsOn: ["implement"] },
    { id: "reviewer",  dependsOn: ["implement"] },
    { id: "arbiter",   dependsOn: ["reviewer", "sec-review"] },
    { id: "pr",        dependsOn: ["arbiter"] }
  ]
```

Core features: event-based state management via append-only event log (crash recovery, auditable history, deterministic replay), worker polling architecture, compensation activities (Saga pattern), and human checkpoints as first-class citizens.

The entire workflow state is derived by replaying events from the write-ahead log. Crashes are recoverable and history is auditable. GitHub: github.com/ubcent/grael
