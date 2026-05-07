---
title: "Multi-Agent Orchestration in LangGraph: Supervisor vs Swarm, Tradeoffs and Architecture"
url: "https://dev.to/focused_dot_io/multi-agent-orchestration-in-langgraph-supervisor-vs-swarm-tradeoffs-and-architecture-1b7e"
author: "Austin Vance"
category: "supervisor-agent-pattern"
---

# Multi-Agent Orchestration in LangGraph: Supervisor vs Swarm, Tradeoffs and Architecture

**Author:** Austin Vance (Focused)
**Published:** April 14, 2026

## Overview

Compares two architectural patterns for orchestrating multiple AI agents using LangGraph: the Supervisor pattern and the Swarm pattern, with concrete performance benchmarks.

## Key Concepts

### Performance Comparison

| Metric | Supervisor | Swarm |
|--------|-----------|-------|
| Single-domain latency | ~4.2s | ~2.8s |
| Handoff latency | ~9.1s | ~5.4s |
| Routing accuracy | 94% | 91% |
| LLM calls | 2-4 | Fewer |

### Supervisor Pattern

A central orchestrator receives messages, classifies intent via structured output, and routes to specialist agents. Control returns to the supervisor after each interaction.

```python
from langgraph_supervisor import create_supervisor

supervisor = create_supervisor(
    agents=[billing_agent, support_agent, sales_agent],
    model=ChatOpenAI(model="gpt-4o"),
    prompt="Route customer requests to the appropriate specialist."
)
```

### Swarm Pattern

Agents hand off directly to each other using `Command` objects. No supervisor intermediary.

```python
from langgraph.types import Command

def billing_agent(state):
    # If this is a support issue, hand off directly
    if is_support_issue(state):
        return Command(goto="support_agent", update=state)
    # Otherwise handle billing
    return handle_billing(state)
```

### Practical Guidance

- Start with the supervisor for clarity and routing accuracy
- Graduate to swarm when latency becomes a bottleneck
- Implement routing accuracy evaluations before scaling
- Use per-agent tracing via `@traceable` decorators for debugging

### Common Failure Modes

- **Routing loops**: Supervisor re-routing the same question endlessly
- **Context loss**: Swarm agents repeat questions during handoffs
- **Supervisor bottleneck**: Central node becomes throughput limiter at scale
- **Agent ping-pong**: Without recursion limits, agents bounce control back and forth
