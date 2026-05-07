---
title: "Add governance to Hugging Face smolagents in 4 lines"
url: "https://dev.to/jagmarques/add-governance-to-hugging-face-smolagents-in-4-lines-192h"
author: "Joao Andre Gomes Marques"
category: "smolagents-huggingface"
---

# Add governance to Hugging Face smolagents in 4 lines

**Author:** Joao Andre Gomes Marques
**Published:** April 12, 2026

## Overview

Addresses a governance gap in Hugging Face's smolagents framework. Agents run tools, make decisions, and call APIs but leave no audit trail of these actions. The solution introduces asqav, a tool that adds cryptographic signing to smolagent tool executions.

## Key Concepts

### The Problem

Smolagents in production run tools, make decisions, and call APIs without any verifiable record of what happened. For compliance teams and auditors, this is unacceptable.

### The Solution

```bash
pip install asqav[smolagents]
```

```python
from asqav.extras.smolagents import AsqavSmolagentsHook

hook = AsqavSmolagentsHook(agent_name="my-smolagent")
signed_tool = hook.wrap_tool(my_tool)
```

### Events Signed

The wrapper signs three event types:
- `tool:start` - when tools are called with input parameters
- `tool:end` - upon completion with output
- `tool:error` - if exceptions occur with details

### Cryptographic Details

Signatures use **ML-DSA-65** (FIPS 204 post-quantum standard) applied server-side. The design is "fail-open" -- if the signing service fails, the agent continues operating with a warning logged.

## Full Example

```python
from smolagents import CodeAgent, HfApiModel, tool
from asqav.extras.smolagents import AsqavSmolagentsHook

@tool
def get_weather(city: str) -> str:
    """Get weather for a city."""
    return f"Sunny in {city}"

hook = AsqavSmolagentsHook(agent_name="weather-agent")
signed_weather = hook.wrap_tool(get_weather)

agent = CodeAgent(
    tools=[signed_weather],
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct")
)

agent.run("What's the weather in Paris?")
# All tool calls are now cryptographically signed and auditable
```

### Dashboard

Audit trail viewable at asqav.com/dashboard showing signed events with timestamps and cryptographic proofs.
