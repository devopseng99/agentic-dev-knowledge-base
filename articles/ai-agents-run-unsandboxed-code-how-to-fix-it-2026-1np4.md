---
title: "AI Agents Run Unsandboxed Code -- How to Fix It (2026)"
url: "https://dev.to/serenitiesai/ai-agents-run-unsandboxed-code-how-to-fix-it-2026-1np4"
author: "Serenities AI"
category: "agent-sandbox"
---

# AI Agents Run Unsandboxed Code -- How to Fix It (2026)

**Author:** Serenities AI
**Published:** February 16, 2026

## Overview
Exposes how major frameworks (LangChain, AutoGen, SWE-Agent) execute LLM-generated code via exec() and subprocess without sandboxing. Covers three sandboxing approaches (Docker, VM, WASM) with practical implementation examples.

## Key Concepts

### Framework Risk Levels
| Framework | Execution Method | Risk Level |
|-----------|------------------|-----------|
| LangChain | exec(command, globals, locals) | Critical |
| AutoGen | subprocess.run() | High |
| SWE-Agent | subprocess.run(["bash", ...]) | High |

### Three Sandboxing Approaches
1. **Docker:** Mature, good isolation, shares kernel with host
2. **Virtual Machines:** Strongest isolation, heavy resource usage
3. **WASM:** Lightweight, fast startup, memory-safe by design

## Code Examples

### WASM-based Sandboxing with Amla

```python
from amla_sandbox import create_sandbox_tool

def get_weather(city: str) -> dict:
    return {"city": city, "temp": 72}

sandbox = create_sandbox_tool(tools=[get_weather])
result = sandbox.run(
    "const w = await get_weather({city: 'SF'}); return w;",
    language="javascript"
)
```

### Capability Constraints

```python
sandbox = create_sandbox_tool(
    tools=[transfer_money],
    constraints={
        "transfer_money": {
            "amount": "<=1000",
            "currency": ["USD", "EUR"],
        },
    },
    max_calls={"transfer_money": 10},
)
```

### Docker-based Isolation

```python
import docker

client = docker.from_env()

def run_sandboxed(code: str) -> str:
    result = client.containers.run(
        "python:3.11-slim",
        f"python -c '{code}'",
        remove=True,
        network_disabled=True,
        read_only=True,
        mem_limit="128m",
        cpu_period=100000,
        cpu_quota=50000,
    )
    return result.decode()
```

### Defense in Depth Layers
- Sandbox isolation: restricts damage to isolated environment
- Capability constraints: limits possible actions
- Rate limiting: prevents runaway execution
- Audit logging: creates visibility into AI attempts
