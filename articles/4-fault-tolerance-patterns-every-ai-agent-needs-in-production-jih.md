---
title: "4 Fault Tolerance Patterns Every AI Agent Needs in Production"
url: "https://dev.to/klement_gunndu/4-fault-tolerance-patterns-every-ai-agent-needs-in-production-jih"
author: "klement Gunndu"
category: "agent-retry-backoff-pattern"
---

# 4 Fault Tolerance Patterns Every AI Agent Needs in Production

**Author:** klement Gunndu
**Published:** March 2, 2026

## Overview
After deploying a multi-agent system with 14 autonomous teams where three teams crashed within a week despite correct logic, the author shares four essential patterns. Implementing all four reduced unrecoverable failures from 23% to under 2% and cut cost per failure by 85%.

## Key Concepts

### Implementation Order (highest ROI first)
1. Retry policies (simplest, highest ROI)
2. Model fallback chains (cross-provider resilience)
3. Error classification (efficient routing)
4. Checkpointing (worst-case recovery)

## Code Examples

### Pattern 1: Retry with Exponential Backoff

```python
from langgraph.graph import StateGraph, START, END
from langgraph.types import RetryPolicy
from typing import TypedDict

class AgentState(TypedDict):
    query: str
    result: str
    error_count: int

def call_external_api(state: AgentState) -> dict:
    response = external_service.query(state["query"])
    return {"result": response.text}

builder = StateGraph(AgentState)
builder.add_node(
    "call_api",
    call_external_api,
    retry_policy=RetryPolicy(max_attempts=3, initial_interval=1.0),
)
```

Key parameters: max_attempts=3, initial_interval=0.5s, backoff_factor=2.0, max_interval=128s, jitter=True.

### Pattern 2: Model Fallback Chains

```python
from langchain.agents import create_agent
from langchain.agents.middleware import (
    ModelFallbackMiddleware,
    ModelRetryMiddleware,
)

agent = create_agent(
    model="gpt-4.1",
    tools=[search_web, query_database],
    middleware=[
        ModelRetryMiddleware(
            max_retries=3,
            backoff_factor=2.0,
            on_failure="continue",
        ),
        ModelFallbackMiddleware(
            "gpt-4.1-mini",
            "claude-3-5-sonnet-20241022",
        ),
    ],
)
```

### Pattern 3: Error Classification and Routing

```python
from langgraph.types import Command
from typing import Optional

class ToolState(TypedDict):
    query: str
    tool_result: Optional[str]
    tool_error: Optional[str]
    attempts: int

def execute_tool(state: ToolState) -> Command:
    try:
        result = run_database_query(state["query"])
        return Command(
            update={"tool_result": result, "tool_error": None},
            goto="process_result",
        )
    except Exception as e:
        attempts = state.get("attempts", 0) + 1
        if attempts >= 3:
            return Command(
                update={"tool_error": f"Failed after 3 attempts: {e}"},
                goto="handle_failure",
            )
        return Command(
            update={"tool_error": f"Tool error: {e}", "attempts": attempts},
            goto="agent",  # Send back to LLM for reformulation
        )
```

Error categories:
| Category | Response |
|---|---|
| Transient (network/rate limits) | Retry policy |
| LLM-recoverable (tool/parsing) | Return error to agent |
| User-fixable (missing info) | Pause with interrupt |
| Unexpected (bugs) | Propagate exception |

### Pattern 4: Checkpoint-Based Recovery

```python
from langgraph.checkpoint.memory import MemorySaver

memory = MemorySaver()
graph = builder.compile(checkpointer=memory)

config = {"configurable": {"thread_id": "batch-job-001"}}
result = graph.invoke(initial_state, config=config)
```

Production: Use PostgresSaver instead of MemorySaver:

```python
from langgraph.checkpoint.postgres import PostgresSaver

DB_URI = "postgresql://user:pass@localhost:5432/mydb?sslmode=disable"
with PostgresSaver.from_conn_string(DB_URI) as checkpointer:
    checkpointer.setup()
    graph = builder.compile(checkpointer=checkpointer)
```
