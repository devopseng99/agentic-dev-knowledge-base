---
title: "Building AI Agents with Tool Use: Patterns That Work in Production (2026)"
url: "https://dev.to/young_gao/practical-guide-to-building-ai-agents-with-tool-use-patterns-that-actually-work-in-production-455b"
author: "Young Gao"
category: "agent-tool-use"
---

# Building AI Agents with Tool Use: Patterns That Work in Production (2026)

**Author:** Young Gao
**Published:** March 21, 2026

## Overview

Addresses the gap between AI agent demos and production-ready implementations. Provides a minimal agent framework in ~100 lines of Python plus production patterns for error handling, rate limiting, cost tracking, and audit logging.

## Key Concepts

### Minimal Agent Framework

```python
import json
import anthropic
from typing import Any, Callable

TOOLS: dict[str, Callable] = {}
TOOL_SCHEMAS: list[dict] = []

def tool(name: str, description: str, input_schema: dict):
    """Decorator to register a function as an agent tool."""
    def decorator(func: Callable) -> Callable:
        TOOLS[name] = func
        TOOL_SCHEMAS.append({
            "name": name,
            "description": description,
            "input_schema": input_schema,
        })
        return func
    return decorator

@tool(
    name="calculator",
    description="Evaluate a mathematical expression. Returns the numeric result.",
    input_schema={
        "type": "object",
        "properties": {
            "expression": {
                "type": "string",
                "description": "A Python math expression, e.g. '2 ** 10 + 5'"
            }
        },
        "required": ["expression"],
    },
)
def calculator(expression: str) -> str:
    allowed = set("0123456789+-*/().% ")
    if not all(c in allowed for c in expression):
        return f"Error: expression contains disallowed characters"
    try:
        result = eval(expression, {"__builtins__": {}}, {})
        return str(result)
    except Exception as e:
        return f"Error: {e}"

@tool(
    name="lookup_user",
    description="Look up a user by ID. Returns their name and email.",
    input_schema={
        "type": "object",
        "properties": {
            "user_id": {"type": "string", "description": "The user ID"}
        },
        "required": ["user_id"],
    },
)
def lookup_user(user_id: str) -> str:
    fake_db = {
        "u_001": {"name": "Alice Chen", "email": "alice@example.com"},
        "u_002": {"name": "Bob Park", "email": "bob@example.com"},
    }
    user = fake_db.get(user_id)
    if user:
        return json.dumps(user)
    return f"Error: user '{user_id}' not found"

def run_agent(
    task: str,
    max_steps: int = 10,
    max_tokens_per_turn: int = 1024,
    model: str = "claude-sonnet-4-20250514",
) -> str:
    client = anthropic.Anthropic()
    messages = [{"role": "user", "content": task}]
    system = "You are a helpful assistant. Use the provided tools when needed."

    for step in range(max_steps):
        response = client.messages.create(
            model=model,
            max_tokens=max_tokens_per_turn,
            system=system,
            tools=TOOL_SCHEMAS,
            messages=messages,
        )

        assistant_content = response.content
        messages.append({"role": "assistant", "content": assistant_content})

        if response.stop_reason == "end_turn":
            text_parts = [b.text for b in assistant_content if b.type == "text"]
            return "\n".join(text_parts)

        tool_results = []
        for block in assistant_content:
            if block.type == "tool_use":
                func = TOOLS.get(block.name)
                if func is None:
                    result = f"Error: unknown tool '{block.name}'"
                else:
                    try:
                        result = func(**block.input)
                    except Exception as e:
                        result = f"Error executing {block.name}: {e}"
                tool_results.append({
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": result,
                })

        messages.append({"role": "user", "content": tool_results})

    return "Error: agent exceeded maximum steps"
```

### Structured Error Returns

```python
def execute_tool(name: str, args: dict) -> str:
    func = TOOLS.get(name)
    if func is None:
        return json.dumps({"error": "unknown_tool",
            "message": f"No tool named '{name}'. Available: {list(TOOLS.keys())}"})
    try:
        result = func(**args)
        return result
    except TypeError as e:
        return json.dumps({"error": "invalid_arguments", "message": str(e),
            "hint": "Check the required parameters and their types."})
    except TimeoutError:
        return json.dumps({"error": "timeout",
            "message": f"Tool '{name}' timed out after 30s."})
    except Exception as e:
        return json.dumps({"error": "execution_error", "message": str(e)})
```

### Rate Limiting

```python
from collections import defaultdict

class ToolRateLimiter:
    def __init__(self, max_calls_per_tool: int = 5):
        self.counts: dict[str, int] = defaultdict(int)
        self.max_calls = max_calls_per_tool

    def check(self, tool_name: str) -> bool:
        self.counts[tool_name] += 1
        return self.counts[tool_name] <= self.max_calls

    def reject_message(self, tool_name: str) -> str:
        return json.dumps({
            "error": "rate_limited",
            "message": f"Tool '{tool_name}' has been called too many times."
        })
```

### Cost Tracking

```python
PRICING = {
    "claude-sonnet-4-20250514": {"input": 3.00, "output": 15.00},
    "claude-opus-4-20250514": {"input": 15.00, "output": 75.00},
    "gpt-4o": {"input": 2.50, "output": 10.00},
}

def calculate_cost(model: str, input_tokens: int, output_tokens: int) -> float:
    rates = PRICING.get(model, {"input": 5.0, "output": 15.0})
    input_cost = (input_tokens / 1_000_000) * rates["input"]
    output_cost = (output_tokens / 1_000_000) * rates["output"]
    return round(input_cost + output_cost, 6)
```

### Idempotent Tool Pattern

```python
@tool(
    name="create_or_update_ticket",
    description="Create a ticket or update if exists. Uses idempotency_key.",
    input_schema={
        "type": "object",
        "properties": {
            "idempotency_key": {"type": "string"},
            "title": {"type": "string"},
            "body": {"type": "string"},
        },
        "required": ["idempotency_key", "title", "body"],
    },
)
def create_or_update_ticket(idempotency_key: str, title: str, body: str) -> str:
    existing = db.tickets.find_one({"idempotency_key": idempotency_key})
    if existing:
        db.tickets.update_one(
            {"idempotency_key": idempotency_key},
            {"$set": {"title": title, "body": body}}
        )
        return json.dumps({"status": "updated", "id": existing["id"]})
    else:
        ticket_id = db.tickets.insert_one({
            "idempotency_key": idempotency_key,
            "title": title, "body": body
        }).inserted_id
        return json.dumps({"status": "created", "id": str(ticket_id)})
```

### Key Takeaway

"Teams try to use these in production and discover they hallucinate tool calls, burn through API budgets in minutes, and get stuck in infinite loops." Success requires treating agents as production systems with proper monitoring, cost controls, and error handling.
