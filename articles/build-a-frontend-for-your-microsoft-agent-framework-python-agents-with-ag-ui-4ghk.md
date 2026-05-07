---
title: "Build a Frontend for your Microsoft Agent Framework (Python) Agents with AG-UI"
url: "https://dev.to/copilotkit/build-a-frontend-for-your-microsoft-agent-framework-python-agents-with-ag-ui-4ghk"
author: "Bonnie"
category: "multi-agent-frameworks"
---

# Build a Frontend for your Microsoft Agent Framework (Python) Agents with AG-UI

**Author:** Bonnie
**Published:** November 21, 2025
**Updated:** February 17, 2026

---

## Overview

This guide teaches developers how to construct a web interface for Python-based AI agents using the Microsoft Agent Framework (MAF), AG-UI Protocol, and CopilotKit. The architecture combines MAF for backend agent logic, CopilotKit for frontend infrastructure, and AG-UI as the communication bridge.

## Key Topics Covered

- Understanding the Microsoft Agent Framework
- Initial setup using CLI tools
- Backend integration with AG-UI protocol
- Frontend development with CopilotKit

---

## What is the Microsoft Agent Framework?

The Microsoft Agent Framework represents "an open-source development kit (SDK) and runtime for building and deploying AI agents." It unifies capabilities from AutoGen (multi-agent orchestration) and Semantic Kernel (enterprise features).

The framework enables developers to create:
- Individual AI agents leveraging large language models
- Multi-agent systems solving complex, sequential tasks

The Python implementation provides an accessible developer experience for rapid prototyping.

---

## Prerequisites

Required before beginning:

- OpenAI or Azure OpenAI credentials
- Python 3.12 or later
- The `uv` package manager
- Node.js 20+
- A package manager (pnpm recommended, npm, yarn, or bun)

---

## Quick Setup with CLI

Initialize a complete stack using:

```bash
npx copilotkit@latest init -m microsoft-agent-framework-py
```

After naming your project, install dependencies:

```bash
pnpm install  # or npm install / yarn install / bun install
```

Configure credentials by creating a `.env` file in the agent folder.

**OpenAI configuration:**
```
OPENAI_API_KEY=sk-...your-key...
OPENAI_CHAT_MODEL_ID=gpt-4o-mini
```

**Azure OpenAI configuration:**
```
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_CHAT_DEPLOYMENT_NAME=gpt-4o-mini
```

Launch the development server:

```bash
pnpm dev  # or npm run dev / yarn dev / bun run dev
```

Access the agent at `http://localhost:3000`.

---

## Backend Integration with AG-UI

### Package Installation

```bash
uv pip install agent-framework, agent-framework-ag-ui, azure-identity
```

### Defining Agent State

Use JSON Schema to structure synchronized state between backend and frontend:

```python
STATE_SCHEMA: dict[str, object] = {
    "proverbs": {
        "type": "array",
        "items": {"type": "string"},
        "description": "Ordered list of the user's saved proverbs."
    }
}
```

### State Configuration

Map state fields to tool functions that modify them:

```python
PREDICT_STATE_CONFIG: dict[str, dict[str, str]] = {
    "proverbs": {
        "tool": "update_proverbs",
        "tool_argument": "proverbs",
    }
}
```

### Defining Agent Tools

Use the `@ai_function` decorator to mark callable tools:

```python
from agent_framework import ai_function
from typing import Annotated
from pydantic import Field

@ai_function(
    name="update_proverbs",
    description="Replace the entire list of proverbs with provided values."
)
def update_proverbs(
    proverbs: Annotated[
        list[str],
        Field(description="The complete source of truth for the user's proverbs.")
    ]
) -> str:
    return f"Proverbs updated. Tracking {len(proverbs)} item(s)."

@ai_function(
    name="get_weather",
    description="Share a quick weather update for a location."
)
def get_weather(
    location: Annotated[str, Field(description="The city or region name.")]
) -> str:
    normalized = location.strip().title() or "the requested location"
    return f"The weather in {normalized} is mild with a light breeze."

@ai_function(
    name="go_to_moon",
    description="Request human approval before lunar launch.",
    approval_mode="always_require"
)
def go_to_moon() -> str:
    return "Mission control requested. Awaiting human approval."
```

### Creating and Configuring the Agent

```python
from agent_framework import ChatAgent, ChatClientProtocol
from agent_framework_ag_ui import AgentFrameworkAgent

def create_agent(chat_client: ChatClientProtocol) -> AgentFrameworkAgent:
    base_agent = ChatAgent(
        name="proverbs_agent",
        instructions="You help users brainstorm, organize, and refine proverbs.",
        chat_client=chat_client,
        tools=[update_proverbs, get_weather, go_to_moon],
    )

    return AgentFrameworkAgent(
        agent=base_agent,
        name="CopilotKitMicrosoftAgentFrameworkAgent",
        description="Manages proverbs, weather snippets, and moon launches.",
        state_schema=STATE_SCHEMA,
        predict_state_config=PREDICT_STATE_CONFIG,
        require_confirmation=False,
    )
```

### Chat Client Configuration

```python
from agent_framework._clients import ChatClientProtocol
from agent_framework.clients import OpenAIChatClient, AzureOpenAIChatClient
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
import os

load_dotenv()

def _build_chat_client() -> ChatClientProtocol:
    if bool(os.getenv("AZURE_OPENAI_ENDPOINT")):
        deployment_name = os.getenv("AZURE_OPENAI_CHAT_DEPLOYMENT_NAME", "gpt-4o-mini")
        return AzureOpenAIChatClient(
            credential=DefaultAzureCredential(),
            deployment_name=deployment_name,
            endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
        )

    if bool(os.getenv("OPENAI_API_KEY")):
        return OpenAIChatClient(
            model_id=os.getenv("OPENAI_CHAT_MODEL_ID", "gpt-4o-mini"),
            api_key=os.getenv("OPENAI_API_KEY"),
        )

    raise ValueError("AZURE_OPENAI_ENDPOINT or OPENAI_API_KEY required")

chat_client = _build_chat_client()
my_agent = create_agent(chat_client)
```

### FastAPI Server Setup

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from agent_framework_ag_ui import add_agent_framework_fastapi_endpoint
import uvicorn

app = FastAPI(title="CopilotKit + Microsoft Agent Framework (Python)")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

add_agent_framework_fastapi_endpoint(
    app=app,
    agent=my_agent,
    path="/",
)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

---

## Key Takeaways

The integration pattern demonstrates how "the frontend to communicate with the backend" through AG-UI, enabling seamless state synchronization and tool execution. The modular approach separates agent logic, client configuration, and API serving, making the architecture maintainable and scalable for enterprise applications.
