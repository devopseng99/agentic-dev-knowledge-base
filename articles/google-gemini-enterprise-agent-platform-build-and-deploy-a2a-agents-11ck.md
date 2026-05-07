---
title: "Google Gemini Enterprise Agent Platform: Build and Deploy A2A Agents"
url: "https://dev.to/jangwook_kim_e31e7291ad98/google-gemini-enterprise-agent-platform-build-and-deploy-a2a-agents-11ck"
author: "Jangwook Kim"
category: "a2a-protocols"
---

# Google Gemini Enterprise Agent Platform: Build and Deploy A2A Agents
**Author:** Jangwook Kim
**Published:** April 26, 2026

## Overview
Google rebranded Vertex AI as Gemini Enterprise Agent Platform. A2A protocol enables interoperability between frameworks.

## Key Concepts
Google rebranded Vertex AI as Gemini Enterprise Agent Platform. A2A protocol enables interoperability between frameworks.

```python
from google.adk.agents import Agent
from google.adk.runners import Runner

agent = Agent(
    name="order-status-agent",
    model="gemini-3.1-flash",
    tools=[lookup_order_status],
)

runner = Runner(agent=agent, app_name="order-service")
runner.serve(host="0.0.0.0", port=8080, enable_a2a=True)
```

Eight core systems: Agent Studio, Runtime, Memory Bank, Gateway, Identity, Registry, Observability, Simulation.
