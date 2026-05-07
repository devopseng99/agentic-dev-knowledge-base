---
title: "Multi-Agent Orchestration on Azure: Workflow Patterns with Agent Framework and Terraform"
url: https://dev.to/suhas_mallesh/multi-agent-orchestration-on-azure-workflow-patterns-with-agent-framework-and-terraform-5ge1
author: Suhas Mallesh
category: multi-agent-orchestration
---

# Multi-Agent Orchestration on Azure: Workflow Patterns with Agent Framework and Terraform

**Author:** Suhas Mallesh
**Published:** March 23, 2026
**Series:** AI Infra on Azure with Terraform (Part 10 of 15)

---

## Overview

The article explains how to build multi-agent systems on Azure using Microsoft Agent Framework. Rather than relying on single agents, complex workflows benefit from specialized agents working together through orchestration patterns.

---

## Three Agent Types in Foundry

| Type | Definition | Use Case |
|------|-----------|----------|
| Prompt agents | Configuration-only | Quick prototyping |
| Workflow agents | Visual/YAML definitions | Multi-step processes |
| Hosted agents | Custom containerized code | Complex systems |

---

## Four Orchestration Patterns

### 1. Sequential Pipeline
Agents execute one after another, with each agent receiving prior output as context. Example: researcher -> writer -> editor.

```python
from agent_framework.azure import AzureOpenAIChatClient
from agent_framework.orchestrations import SequentialBuilder
from azure.identity import AzureCliCredential

client = AzureOpenAIChatClient(credential=AzureCliCredential())

researcher = client.as_agent(
    name="researcher",
    instructions="Research the given topic thoroughly. Provide detailed findings.",
)

writer = client.as_agent(
    name="writer",
    instructions="Based on the research provided, write a clear blog post draft.",
)

editor = client.as_agent(
    name="editor",
    instructions="Review the draft for clarity, grammar, and tone.",
)

pipeline = (
    SequentialBuilder()
    .add(researcher)
    .add(writer)
    .add(editor)
    .build()
)

result = await pipeline.invoke("Write about the impact of AI on healthcare")
```

### 2. Concurrent Execution
Independent tasks run simultaneously to reduce latency.

```python
from agent_framework.orchestrations import ConcurrentBuilder

energy_analyst = client.as_agent(
    name="energy_analyst",
    instructions="Analyze renewable energy market trends.",
)

ev_analyst = client.as_agent(
    name="ev_analyst",
    instructions="Analyze electric vehicle adoption trends.",
)

concurrent = (
    ConcurrentBuilder()
    .add(energy_analyst)
    .add(ev_analyst)
    .build()
)

results = await concurrent.invoke("Analyze 2025 sustainability trends")
```

### 3. Handoff Chain
One agent transfers control to another based on conversation context. Useful for customer support spanning multiple domains.

```python
from agent_framework.orchestrations import HandoffBuilder

order_agent = client.as_agent(
    name="order_agent",
    instructions="""Handle order lookups and cancellations.
    If asking about payments or refunds, transfer to payments_agent.""",
)

payments_agent = client.as_agent(
    name="payments_agent",
    instructions="""Handle refunds and billing inquiries.
    If asking about order status, transfer to order_agent.""",
)

handoff = (
    HandoffBuilder()
    .add(order_agent)
    .add(payments_agent)
    .build()
)

result = await handoff.invoke(
    "I need to cancel order #1234 and get a refund"
)
```

### 4. Group Chat
Multiple agents collaborate on a shared conversation.

```python
from agent_framework.orchestrations import GroupChatBuilder

analyst = client.as_agent(
    name="analyst",
    instructions="Analyze data and provide insights.",
)

strategist = client.as_agent(
    name="strategist",
    instructions="Develop strategies based on analysis.",
)

critic = client.as_agent(
    name="critic",
    instructions="Challenge assumptions and identify risks.",
)

group = (
    GroupChatBuilder()
    .add(analyst)
    .add(strategist)
    .add(critic)
    .set_max_rounds(3)
    .build()
)

result = await group.invoke("Should we expand into the European market?")
```

---

## Terraform Infrastructure

Use separate model deployments for orchestration versus specialist tasks to optimize cost and performance.

```hcl
# agents/deployments.tf

resource "azurerm_cognitive_deployment" "orchestrator_model" {
  name                 = "${var.environment}-orchestrator"
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id

  sku {
    name     = var.orchestrator_model.sku
    capacity = var.orchestrator_model.tpm
  }

  model {
    format  = "OpenAI"
    name    = var.orchestrator_model.name
    version = var.orchestrator_model.version
  }
}

resource "azurerm_cognitive_deployment" "specialist_model" {
  name                 = "${var.environment}-specialist"
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id

  sku {
    name     = var.specialist_model.sku
    capacity = var.specialist_model.tpm
  }

  model {
    format  = "OpenAI"
    name    = var.specialist_model.name
    version = var.specialist_model.version
  }
}
```

**Environment Configuration (prod.tfvars):**

```hcl
orchestrator_model = {
  name    = "gpt-4o"
  version = "2024-11-20"
  sku     = "GlobalStandard"
  tpm     = 80
}

specialist_model = {
  name    = "gpt-4o-mini"
  version = "2024-07-18"
  sku     = "GlobalStandard"
  tpm     = 120
}
```

---

## Combining Patterns

Nest patterns for complex workflows. Example: concurrent data gathering followed by sequential response drafting and review.

```python
data_gathering = (
    ConcurrentBuilder()
    .add(order_lookup_agent)
    .add(payment_lookup_agent)
    .build()
)

full_pipeline = (
    SequentialBuilder()
    .add_orchestration(data_gathering)
    .add(response_drafter)
    .add(quality_reviewer)
    .build()
)

result = await full_pipeline.invoke(
    "Customer asking about order #1234 refund status"
)
```

---

## Key Takeaways

- **Clear agent instructions** determine handoff success; vague boundaries cause agents to overreach
- **Token cost multiplies** with each agent in the pipeline -- use cost-effective models for specialists
- **Always set `max_rounds`** in group chat to prevent infinite looping
- **State management** built into Agent Framework handles long-running workflows
- **Streaming supported** across all orchestration patterns
