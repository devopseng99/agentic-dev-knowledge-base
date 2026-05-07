---
title: "OpenAI Swarm: Exploring Lightweight Multi-Agent Orchestration"
url: "https://dev.to/fotiecodes/openai-swarm-exploring-lightweight-multi-agent-orchestration-gim"
author: "fotiecodes"
category: "swarm-agent-openai"
---

# OpenAI Swarm: Exploring Lightweight Multi-Agent Orchestration

**Author:** fotiecodes
**Published:** October 21, 2024

## Overview
Swarm is an experimental, educational framework from OpenAI for lightweight multi-agent orchestration. Powered by the Chat Completions API, stateless between calls. Not intended for production use. Revolves around two primary concepts: Agents and Handoffs.

## Key Concepts

### Installation

```shell
pip install git+https://github.com/openai/swarm.git
```

### Basic Agent Setup with Handoffs

```python
from swarm import Swarm, Agent

client = Swarm()

def transfer_to_agent_b():
    return agent_b

agent_a = Agent(
    name="Agent A",
    instructions="You are a helpful agent.",
    functions=[transfer_to_agent_b],
)

agent_b = Agent(
    name="Agent B",
    instructions="Only speak in Haikus.",
)

response = client.run(
    agent=agent_a,
    messages=[{"role": "user", "content": "I want to talk to agent B."}],
)
print(response.messages[-1]["content"])
```

### Key Abstractions
- **Agents** -- Encapsulation of instructions and tools for specific tasks
- **Handoffs** -- An agent passes control to another agent based on conditions

### Use Cases
- **Customer support bots** -- Different agents handle billing vs technical support
- **Personal assistants** -- Specialized agents for scheduling, shopping, weather
- **Workflow automation** -- Agents manage specific steps of a workflow

### Limitations
- Not for production (experimental)
- No state retention between calls
- No active maintenance planned
