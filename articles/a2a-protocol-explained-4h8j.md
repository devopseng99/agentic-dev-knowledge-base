---
title: "A2A Protocol Explained"
url: https://dev.to/cnych/a2a-protocol-explained-4h8j
author: cnych
category: a2a-protocol
---

# A2A Protocol Explained

**Author:** cnych
**Published:** July 16, 2025

---

## Overview

"A2A, short for `Agent to Agent` protocol, is an open-source framework launched by Google to facilitate communication and interoperability among AI agents."

The protocol addresses a fundamental challenge: enabling AI agents built by different teams, using different technologies, and owned by different organizations to communicate and collaborate effectively.

---

## Why A2A Is Needed

Complex tasks often require coordination across specialized agents. The article illustrates this with an international trip planning scenario requiring:

- Flight booking agent
- Hotel reservation agent
- Tour recommendations agent
- Currency conversion and travel advisory agent

Without standardized communication protocols, integrating disparate agents becomes costly and difficult to scale.

---

## Application Scenarios

**Enterprise Automation:** Agents coordinate across siloed systems and applications without vendor lock-in.

**Multi-Agent Collaboration:** Agents retain individual capabilities while handling complex tasks through true collaboration.

**Cross-Platform Integration:** AI agents operate across diverse enterprise ecosystems including CRM systems, knowledge bases, and project management tools.

---

## Core Concepts

### Participants

- **User:** End user initiating requests
- **A2A Client:** Agent representing the user requesting actions
- **A2A Server:** Remote agent exposing an HTTP endpoint

### Communication Elements

**Agent Card:** JSON metadata document discoverable at `/.well-known/agent.json` describing identity, capabilities, endpoints, and authentication.

**Task:** Represents work requiring completion, progressing through states like `submitted`, `working`, `completed`, or `failed`.

**Message:** Single communication turn with a `role` and `Part` objects containing content.

**Part:** Fundamental content unit available as `TextPart`, `FilePart`, or `DataPart`.

**Artifact:** Output results from agent task processing.

### Interaction Mechanisms

**Request/Response (Polling):** Client sends request, server responds. For long tasks, client periodically polls until completion.

**Streaming (SSE):** Client initiates with `message/stream`. Server maintains open connection sending Server-Sent Events for task updates and artifacts.

**Push Notifications:** Server sends asynchronous HTTP POST notifications to client-provided webhook for significant state changes.

---

## A2A vs. MCP

These protocols complement each other:

- **MCP:** Connects AI models with external tools and data (Model-to-Data)
- **A2A:** Enables communication between multiple AI agents (Agent-to-Agent)

An agent application might use A2A for inter-agent communication while employing MCP internally for tool interactions.

---

## Implementation Example

### Server Implementation

The Python SDK provides `A2AStarletteApplication` for building servers:

```python
import uvicorn
from a2a.server.apps import A2AStarletteApplication
from a2a.server.request_handlers import DefaultRequestHandler
from a2a.server.tasks import InMemoryTaskStore
from a2a.types import AgentCard, AgentSkill, AgentCapabilities

skill = AgentSkill(
    id='hello_world',
    name='Returns hello world',
    description='just returns hello world',
    tags=['hello world'],
    examples=['hi', 'hello world'],
)

agent_card = AgentCard(
    name='Hello World Agent',
    description='Just a hello world agent',
    url='http://0.0.0.0:9999/',
    version='1.0.0',
    defaultInputModes=['text'],
    defaultOutputModes=['text'],
    capabilities=AgentCapabilities(streaming=True),
    skills=[skill],
    supportsAuthenticatedExtendedCard=True,
)

request_handler = DefaultRequestHandler(
    agent_executor=HelloWorldAgentExecutor(),
    task_store=InMemoryTaskStore(),
)

server = A2AStarletteApplication(
    agent_card=agent_card,
    http_handler=request_handler,
)

uvicorn.run(server.build(), host='0.0.0.0', port=9999)
```

### Agent Executor

Implement the `AgentExecutor` interface for core agent logic:

```python
from a2a.server.agent_execution import AgentExecutor, RequestContext
from a2a.server.events import EventQueue
from a2a.utils import new_agent_text_message

class HelloWorldAgentExecutor(AgentExecutor):
    async def execute(
        self,
        context: RequestContext,
        event_queue: EventQueue,
    ) -> None:
        result = "Hello World"
        await event_queue.enqueue_event(new_agent_text_message(result))

    async def cancel(
        self, context: RequestContext, event_queue: EventQueue
    ) -> None:
        raise Exception('cancel not supported')
```

### Client Implementation

```python
from a2a.client import A2ACardResolver, A2AClient
from a2a.types import SendMessageRequest, MessageSendParams

async with httpx.AsyncClient() as httpx_client:
    resolver = A2ACardResolver(
        httpx_client=httpx_client,
        base_url='http://localhost:9999',
    )

    agent_card = await resolver.get_agent_card()
    client = A2AClient(
        httpx_client=httpx_client,
        agent_card=agent_card
    )

    request = SendMessageRequest(
        id=str(uuid4()),
        params=MessageSendParams(
            message={
                'role': 'user',
                'parts': [{'kind': 'text', 'text': 'hello'}],
                'messageId': uuid4().hex,
            }
        )
    )

    response = await client.send_message(request)
```

---

## Real-World Use Case: Employee Onboarding

An `OnboardingPro` agent orchestrates multiple department agents:

| Agent | Responsibilities |
|-------|------------------|
| `hr-agent.company.com` | Create records, send documents |
| `it-agent.company.com` | Set up email, order laptops |
| `facilities-agent.company.com` | Assign desks, print badges |

The orchestrator discovers capabilities, delegates tasks, receives streaming updates, collects artifacts, and notifies completion.

---

## Key Takeaways

- A2A enables standardized agent-to-agent communication across organizational boundaries
- The protocol supports multiple interaction patterns: polling, streaming, and webhooks
- Agent cards provide capability discovery and configuration
- A2A and MCP are complementary, not competitive technologies
- Python SDK simplifies implementation of both servers and clients
