---
title: "Toward Reproducible Agent Workflows -- A Kafka-Based Orchestration Design"
url: "https://dev.to/nesquikm/toward-reproducible-agent-workflows-a-kafka-based-orchestration-design-5b3p"
author: "Mike"
category: "flink-kafka-agents"
---

# Toward Reproducible Agent Workflows -- A Kafka-Based Orchestration Design
**Author:** Mike
**Published:** March 27, 2026

## Overview
A Kafka-based orchestration architecture for multi-agent systems that enables workflow reproducibility, auditable routing decisions, and explicitly bounded agent loops. The fundamental principle: the orchestration graph is code, the agents are LLMs -- keep them separate. Routing decisions remain deterministic code; no LLM chooses which agent executes next.

## Key Concepts

### Architecture: 7 Layers

**Layer 1: Git-Stored Workflow Definitions**

```yaml
# workflows/code-review.yaml
name: code-review
version: "1.0"
agents:
  - id: analyzer
    image: agents/code-analyzer:latest
    runtime: openai-api-compatible
    input_schema: schemas/analyzer-input.json
    output_schema: schemas/analyzer-output.json
  - id: security-checker
    image: agents/security-check:latest
  - id: code-fixer
    image: agents/code-fixer:latest
    runtime: claude-agent-sdk
  - id: quality-gate
    image: agents/quality-validator:latest
    runtime: deterministic

edges:
  - from: quality-gate
    to: code-fixer
    condition:
      field: output.passed
      equals: false
    loop:
      exit_conditions:
        - field: output.quality_score
          convergence:
            delta: 0.05
            window: 1
        - field: output.quality_score
          gte: 0.9
      max_iterations: 5
      on_exhaustion: escalate
```

**Layer 2: Kafka as the Validation Bus**
Topic topology per agent: `workflow.code-review.analyzer.input`, `workflow.code-review.analyzer.output`, etc. Every message validates against registered schemas.

**Layer 3: Kafka-Based Orchestrator (TypeScript + KafkaJS)**

```typescript
function route(runState: RunState, nodeOutput: NodeOutput): RoutingDecision {
  const currentNode = runState.currentNode;
  for (const edge of workflow.edgesFrom(currentNode)) {
    if (!evaluateCondition(edge.condition, nodeOutput)) continue;
    if (edge.loop) {
      const counter = runState.loopCounters[edge.id] ?? 0;
      const prevOutput = runState.previousOutputs[edge.id];
      if (edge.loop.exitConditions) {
        if (checkConvergence(prevOutput, nodeOutput, edge.loop.exitConditions)) {
          return routeTo(edge.loop.convergenceTarget ?? "$output", nodeOutput);
        }
        if (checkThreshold(nodeOutput, edge.loop.exitConditions)) {
          return routeTo(edge.loop.convergenceTarget ?? "$output", nodeOutput);
        }
      }
      if (counter >= edge.loop.maxIterations) {
        return handleExhaustion(edge.loop.onExhaustion);
      }
      runState.loopCounters[edge.id] = counter + 1;
    }
    if (runState.budget.exceeded()) {
      return terminate(runState, "budget_exceeded");
    }
    return routeTo(edge.target, nodeOutput);
  }
  return terminate(runState, "no_matching_edge");
}
```

**Layer 4: Provider-Agnostic Agent Runtime**
Agents are Docker containers consuming from Kafka input topic and producing to output topic. Supports OpenAI-API-compatible and Claude Agent SDK runtimes.

**Layer 5: Zero-Trust Agent Sandboxing**
Agents run with `--network none`, communicating only via Unix domain sockets to a sidecar proxy. Short-lived JWTs minted per workflow run.

**Layer 6: Observability and Deterministic Replay**
Every message carries `run_id`. Given identical agent outputs, the orchestrator always makes the same routing decisions. Enables model comparison, regression detection, cost optimization, and compliance auditing.

**Layer 7: Meta-Workflows**
- Watchdog: Real-time anomaly detector
- Optimizer: Proposes improvements as PRs to workflow definitions
- Auditor: Compliance verification
- Canary: Safe deployment of workflow changes

### Stack (All Open-Source)
| Component | Technology |
|-----------|-----------|
| Message bus | Apache Kafka |
| Schema enforcement | Apicurio Registry |
| Orchestrator | KafkaJS + TypeScript |
| Agent containers | Docker |
| Kernel isolation | gVisor |
| LLM client | OpenAI Node SDK |
| Sidecar proxy | Envoy |
