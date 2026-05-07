---
title: "Why agent orchestration is harder than kubernetes - Lessons while building Agentflow"
url: "https://dev.to/siddhantkcode/why-agent-orchestration-is-harder-than-kubernetes-lessons-while-building-agentflow-4jm3"
author: "Siddhant Khare"
category: "k8s-native-agents"
---

# Why agent orchestration is harder than kubernetes
**Author:** Siddhant Khare
**Published:** October 23, 2025

## Overview
Lessons from building AgentFlow showing why agent orchestration differs fundamentally from container orchestration: non-determinism, failure detection, resource scheduling, state management, observability, dynamic task decomposition, and the merge problem.

## Key Concepts

### Semantic Checkpointing
```rust
struct AgentCheckpoint {
    task_id: Uuid,
    reasoning_trace: Vec<ReasoningStep>,
    tool_outputs: HashMap<String, ToolResult>,
    partial_results: Vec<Artifact>,
    context_hash: String,
}
```

### Agent Resource Requirements
```rust
struct AgentResourceRequirements {
    cpu_cores: f32,
    memory_gb: f32,
    token_quota: TokenQuota {
        input_tokens_per_minute: u32,
        output_tokens_per_minute: u32,
        provider: Provider,
    },
    model_constraints: ModelConstraints {
        min_context_window: u32,
        required_capabilities: Vec<Capability>,
        max_cost_per_request: f32,
    },
    required_tools: Vec<Tool>,
}
```

### Agent Trace for Observability
```rust
struct AgentTrace {
    duration_ms: u64,
    tokens_used: TokenUsage,
    cost_usd: f32,
    model: String,
    reasoning_steps: Vec<ReasoningStep>,
    tool_calls: Vec<ToolCall>,
    output_quality_score: Option<f32>,
}
```
