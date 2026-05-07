---
title: "Three-Layer Safety for Autonomous Agents: Stopping the Infinite Loop"
url: "https://dev.to/futhgar/three-layer-safety-for-autonomous-agents-stopping-the-infinite-loop-3go5"
author: "Guatu"
category: "autonomous-operations"
---
# Three-Layer Safety for Autonomous Agents: Stopping the Infinite Loop
**Author:** Guatu  **Published:** April 30, 2026

## Overview
An agent spent 3+ hours attempting to close a GitHub issue, repeatedly failing and entering an infinite loop due to hallucinated API capabilities. Standard approaches — prompt engineering, Pydantic validation, supervisor agents — proved insufficient. The solution: deterministic boundaries that treat LLMs as probabilistic systems.

## Key Concepts

### The Core Problem
"When you move from a chat window to an autonomous loop, the gap between the LLM's intent and the system's reality becomes a canyon where agents go to die."

### Layer 1: Token-Level Schema Enforcement
Use Ollama v0.5.0+ native `format` parameter to enforce JSON schema at the token-sampling level, preventing malformed output before generation completes.

```python
import httpx
from pydantic import BaseModel, Field

class HomelabHealthReport(BaseModel):
    node_status: dict[str, str]
    critical_alerts: list[str]
    storage_utilization: float = Field(description="Percentage 0-100")

schema = HomelabHealthReport.model_json_schema()

def get_safe_report():
    response = httpx.post(
        "http://ollama:11434/api/chat",
        json={
            "model": "qwen2.5:14b-instruct",
            "stream": False,
            "format": schema,
            "prompt": "Generate a health report for the homelab based on current metrics."
        },
        timeout=30.0
    )
    return response.json()["message"]["content"]
```

**Key Benefit:** Eliminates `ValidationError` loops by making malformed JSON physically impossible at the sampler level.

### Layer 2: Pre-Execution Gate (ActionGate)
Deterministic middleware using hard-coded business logic — not LLM-based — to validate agent actions before execution.

```python
class SafetyException(Exception):
    pass

def check_action_safety(action_name, params, context):
    if action_name == "close_issue":
        issue_id = params.get("issue_id")
        if context.get(f"issue_{issue_id}_has_dependency"):
            raise SafetyException(
                f"Safety Violation: Cannot close issue {issue_id} while dependencies are open."
            )

    if action_name == "reboot_node":
        node_id = params.get("node_id")
        if context.get("is_production") and context.get("peak_hours"):
            raise SafetyException(
                f"Safety Violation: Reboot of {node_id} forbidden during peak hours."
            )

    return True
```

**Key Benefit:** Provides explicit rejection reasons instead of cryptic API errors, forcing strategy pivots rather than retry loops.

### Layer 3: Execution Isolation and Shell Safety
Multi-layer shell interpretation creates "quoting hell" where agent output breaks command syntax.

**Unsafe Approach:**
```bash
ssh node-a "pct exec 101 -- su - user -c 'python3 -c \"print(\"Hello World\")\"'"
```

**Safe Approach:**
```bash
cat ~/bin/helpers/scout-ideas-helper.py | \
  ssh node-a "pct exec 101 -- su - user -c 'python3 -'"
```

**Key Benefit:** Eliminates quote interpretation issues by treating agent output as data (stdin) rather than commands.

### Why This Architecture Works
- Token enforcement removes formatting failures
- ActionGate prevents logically unsafe actions
- Execution isolation prevents infrastructure-level breakdowns

Result: "Moving from a system that is 'mostly working' to one that is 'predictably bounded.'"

### Key Insight
"Building autonomous agents isn't about finding the perfect model; it's about building the perfect cage for that model to operate in."
