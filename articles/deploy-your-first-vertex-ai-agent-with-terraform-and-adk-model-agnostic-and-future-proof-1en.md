---
title: "Deploy Your First Vertex AI Agent with Terraform and ADK: Model-Agnostic and Future-Proof"
url: "https://dev.to/suhas_mallesh/deploy-your-first-vertex-ai-agent-with-terraform-and-adk-model-agnostic-and-future-proof-1en"
author: "Suhas Mallesh"
category: "vertex-ai-agent"
---

# Deploy Your First Vertex AI Agent with Terraform and ADK

**Author:** Suhas Mallesh
**Published:** March 14, 2026

## Overview

Demonstrates deploying a Vertex AI Agent using Google's Agent Development Kit (ADK) and Terraform infrastructure-as-code. Separates infrastructure provisioning from agent logic, enabling model swaps through configuration changes.

## Key Concepts

### Terraform Variables

```hcl
variable "agent_model" {
  type = object({
    id      = string
    display = string
  })
  default = {
    id      = "gemini-2.5-flash"
    display = "Gemini 2.5 Flash"
  }
}
```

### Environment-Specific Overrides

```hcl
# environments/dev.tfvars
agent_model = { id = "gemini-2.5-flash", display = "Gemini 2.5 Flash" }

# environments/prod.tfvars
agent_model = { id = "gemini-2.5-pro", display = "Gemini 2.5 Pro" }
```

### Infrastructure Setup

```hcl
resource "google_project_service" "required" {
  for_each = toset(["aiplatform.googleapis.com", "compute.googleapis.com", "cloudbuild.googleapis.com"])
  project = var.project_id
  service = each.value
}

resource "google_service_account" "agent" {
  account_id   = "${var.environment}-${var.agent_name}-agent"
  display_name = "Agent SA: ${var.agent_model.display}"
  project      = var.project_id
}
```

### ADK Agent Definition

```python
import json
from google.adk.agents import Agent
from google.adk.models.vertexai import VertexAi

with open("config.json") as f:
    config = json.load(f)

model = VertexAi(model=config["model_id"])

agent = Agent(
    name=config["agent_name"],
    model=model,
    instruction=config["instruction"],
    description="A helpful assistant deployed via Terraform and ADK",
)
```

### Model-Agnostic Alternative (LiteLLM)

```python
from google.adk.models.lite_llm import LiteLlm
model = LiteLlm(model="vertex_ai/claude-sonnet-4-20250514")
```

### Agent Engine Deployment

```python
import vertexai
from vertexai.agent_engines import AdkApp

vertexai.init(project=config["project_id"], location=config["location"])
app = AdkApp(agent=agent)

deployed = vertexai.agent_engines.create(
    agent_engine=app,
    requirements=["google-cloud-aiplatform[agent_engines,adk]"],
    display_name=config["agent_name"],
)
```

### Querying Deployed Agent

```python
adk_app = client.agent_engines.get(name="RESOURCE_ID")
session = await adk_app.async_create_session(user_id="user-123")

async for event in adk_app.async_stream_query(
    user_id="user-123", session_id=session.id,
    message="What were our Q3 revenue numbers?"
):
    if event.get("content", {}).get("parts"):
        for part in event["content"]["parts"]:
            if "text" in part:
                print(part["text"], end="")
```
