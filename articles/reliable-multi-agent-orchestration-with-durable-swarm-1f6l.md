---
title: "Reliable Multi-Agent Orchestration with Durable Swarm"
url: "https://dev.to/dbos/reliable-multi-agent-orchestration-with-durable-swarm-1f6l"
author: "Qian Li"
category: "multi-cloud-durable"
---

# Reliable Multi-Agent Orchestration with Durable Swarm
**Author:** Qian Li
**Published:** October 17, 2024

## Overview
Introduces Durable Swarm, a drop-in replacement for OpenAI's Swarm framework that adds durable execution capabilities. By persisting workflow execution state to PostgreSQL via DBOS, agentic workflows become resilient to failures and automatically resume from their last completed steps after interruptions.

## Key Concepts

The entire Durable Swarm implementation is fewer than 20 lines of code:

```python
from swarm import Swarm
from dbos import DBOS, DBOSConfiguredInstance

DBOS()

@DBOS.dbos_class()
class DurableSwarm(Swarm, DBOSConfiguredInstance):
    def __init__(self, client=None):
        Swarm.__init__(self, client)
        DBOSConfiguredInstance.__init__(self, "openai_client")

    @DBOS.step()
    def get_chat_completion(self, *args, **kwargs):
        return super().get_chat_completion(*args, **kwargs)

    @DBOS.step()
    def handle_tool_calls(self, *args, **kwargs):
        return super().handle_tool_calls(*args, **kwargs)

    @DBOS.workflow()
    def run(self, *args, **kwargs):
        return super().run(*args, **kwargs)

DBOS.launch()
```

Example multi-agent workflow:

```python
from swarm import Agent
from durable_swarm import DurableSwarm

client = DurableSwarm()

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

Migration requires three steps: install and initialize DBOS, add durable_swarm.py to your project, and replace Swarm with DurableSwarm. DBOS implements optimizations such as batching and async writes to minimize persistence overhead.
