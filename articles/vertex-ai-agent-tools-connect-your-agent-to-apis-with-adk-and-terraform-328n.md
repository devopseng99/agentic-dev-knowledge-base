---
title: "Vertex AI Agent Tools: Connect Your Agent to APIs with ADK and Terraform"
url: "https://dev.to/suhas_mallesh/vertex-ai-agent-tools-connect-your-agent-to-apis-with-adk-and-terraform-328n"
author: "Suhas Mallesh"
category: "vertex-ai-agent"
---

# Vertex AI Agent Tools: Connect Your Agent to APIs with ADK and Terraform

**Author:** Suhas Mallesh
**Published:** March 20, 2026

## Overview

Teaches how to extend Vertex AI agents with five tool types using ADK and Terraform: Function Tools, OpenAPI Tools, MCP Tools, Built-in Tools, and Agent Tools.

## Key Concepts

### Function Tools

```python
import urllib.request
import json

def get_exchange_rate(currency_from: str, currency_to: str) -> dict:
    """Get the current exchange rate between two currencies.

    Args:
        currency_from: The source currency code (e.g., USD, EUR, GBP).
        currency_to: The target currency code (e.g., USD, EUR, GBP).

    Returns:
        A dictionary with the exchange rate.
    """
    url = f"https://api.frankfurter.dev/v1/latest?base={currency_from}&symbols={currency_to}"
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read())
    rate = data["rates"].get(currency_to, "N/A")
    return {"rate": rate, "from": currency_from, "to": currency_to}
```

### Agent Registration with Tools

```python
from google.adk.agents import Agent
from google.adk.models.vertexai import VertexAi
from tools import get_exchange_rate

model = VertexAi(model=config["model_id"])

agent = Agent(
    name=config["agent_name"],
    model=model,
    instruction=config["instruction"],
    tools=[get_exchange_rate],
)
```

### OpenAPI Tools

```python
from google.adk.tools.openapi_tool.openapi_spec_parser.openapi_toolset import OpenAPIToolset

petstore_toolset = OpenAPIToolset(
    spec_str=open("petstore_openapi.yaml").read(),
    spec_str_type="yaml",
)

agent = Agent(
    name="api-agent",
    model=model,
    instruction="You manage the pet store. Use the API tools to list, create, and look up pets.",
    tools=[petstore_toolset],
)
```

### Authentication for OpenAPI Tools

```python
from google.adk.tools.openapi_tool.auth.auth_helpers import token_to_scheme_credential

toolset = OpenAPIToolset(
    spec_str=open("my_api.yaml").read(),
    spec_str_type="yaml",
    auth_scheme_credential=token_to_scheme_credential("bearer", "my-api-token"),
)
```

### Terraform Secret Management

```hcl
resource "google_secret_manager_secret" "api_keys" {
  for_each  = var.tool_api_keys
  secret_id = "${var.environment}-${each.key}-api-key"
  project   = var.project_id
  replication { auto {} }
}

resource "google_secret_manager_secret_iam_member" "agent_access" {
  for_each  = var.tool_api_keys
  secret_id = google_secret_manager_secret.api_keys[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.agent.email}"
}
```

### Sequential Tool Use

```python
agent = Agent(
    name="research-agent",
    model=model,
    instruction="""You are a research assistant.
    When the user asks for analysis:
    1. First use search_documents to find relevant data
    2. Then use summarize_data to create a summary
    3. Finally use create_report to format the output""",
    tools=[search_documents, summarize_data, create_report],
)
```

Key insight: "Docstrings are your schema." Type hints and clear documentation enable proper tool selection.
