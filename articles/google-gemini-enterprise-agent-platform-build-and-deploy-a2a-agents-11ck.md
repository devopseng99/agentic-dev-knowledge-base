---
title: "Google Gemini Enterprise Agent Platform: Build and Deploy A2A Agents"
url: "https://dev.to/jangwook_kim_e31e7291ad98/google-gemini-enterprise-agent-platform-build-and-deploy-a2a-agents-11ck"
author: "Jangwook Kim"
category: "vertex-ai-agent"
---

# Google Gemini Enterprise Agent Platform: Build and Deploy A2A Agents

**Author:** Jangwook Kim
**Published:** April 26, 2026

## Overview

Covers the Gemini Enterprise Agent Platform rebrand, A2A protocol, ADK v1.0, and migration timeline from Vertex AI SDK.

## Key Concepts

### A2A Protocol

The Agent2Agent protocol functions as "to agents what HTTP is to web services." Native A2A support exists in LangGraph, CrewAI, LlamaIndex Agents, Semantic Kernel, and AutoGen.

### ADK Agent with A2A (Python)

```python
from google.adk.agents import Agent
from google.adk.runners import Runner
from google.adk.sessions import InMemorySessionService
from google.adk.tools import ToolContext

def lookup_order_status(order_id: str, tool_context: ToolContext) -> dict:
    """Look up the status of an order by ID."""
    return {"order_id": order_id, "status": "shipped", "eta": "2026-04-28"}

agent = Agent(
    name="order-status-agent",
    model="gemini-3.1-flash",
    description="Looks up order status for customer service queries",
    tools=[lookup_order_status],
)

runner = Runner(
    agent=agent,
    app_name="order-service",
    session_service=InMemorySessionService(),
)

runner.serve(host="0.0.0.0", port=8080, enable_a2a=True)
```

### Deployment

```bash
gcloud agent-platform agents deploy order-status-agent \
  --source . \
  --region us-central1 \
  --runtime-type long-running \
  --a2a-enabled
```

### Migration from Vertex AI SDK

```python
# Before (Vertex AI SDK)
import vertexai
from vertexai.generative_models import GenerativeModel
vertexai.init(project="my-project", location="us-central1")
model = GenerativeModel("gemini-3.1-pro")
response = model.generate_content("Explain what changed")

# After (Google Gen AI SDK)
from google import genai
client = genai.Client(project="my-project", location="us-central1")
response = client.models.generate_content(
    model="gemini-3.1-pro",
    contents="Explain what changed"
)
```

### Migration Timeline

Deprecated Vertex AI SDK modules stop receiving updates on June 24, 2026.
