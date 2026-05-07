---
title: "A2A - Understanding the Basics and Building Multi-Agent Flight Management System"
url: https://dev.to/cloudx/a2a-understanding-the-basics-and-building-multi-agent-flight-management-system-39c7
author: Eze Quiroga
category: a2a-protocol
---

# A2A - Understanding the Basics and Building Multi-Agent Flight Management System

**Author:** Eze Quiroga
**Date Published:** July 9, 2025
**Source:** DEV Community

## Overview

This comprehensive guide explores Google's Agent-to-Agent (A2A) protocol, announced April 9, 2025, which standardizes how AI agents communicate and collaborate. The article walks through building a command-line multi-agent system for corporate flight management using Python 3.13.5.

## Key Concepts

### What is A2A?

The A2A protocol enables standardized communication between AI agents. According to the article, the protocol's primary goals include:

- **Interoperability:** "Bridge the communication gap between disparate agentic systems"
- **Collaboration:** Agents can delegate tasks and exchange context
- **Discovery:** Agents dynamically find other agents' capabilities
- **Flexibility:** Support synchronous requests, streaming, and asynchronous push notifications
- **Security:** Enterprise-suitable communication patterns
- **Asynchronicity:** Native support for long-running tasks

Communication uses HTTP(S) with JSON-RPC 2.0 format and Server-Sent Events (SSE) for streaming.

## Core Architecture

The system comprises three specialized A2A agents:

1. **Employee Flight Request Agent:** Manages booking status using internal databases; responds immediately
2. **Airport Knowledge Base Agent:** Provides airport information via fuzzy matching; uses streaming responses
3. **Flight Search Agent:** Performs real-time flight searches from Aviation Stack API; sends push notifications

A centralized LangChain ReAct agent coordinates between these specialized agents and handles user interaction.

## Core Components

The article identifies essential A2A elements:

- **Agent Card:** JSON metadata describing identity, capabilities, skills, endpoint URL, and authentication
- **Task:** Fundamental work unit with unique ID and defined lifecycle
- **Message:** Communication turn with role (user/agent) containing Parts
- **Part:** Smallest content unit (TextPart, FilePart, DataPart)
- **Artifact:** Agent-generated output composed of Parts

## Communication Patterns

Three distinct patterns enable different scenarios:

- **Standard HTTP(S):** Single request-response cycle
- **Streaming (SSE):** Real-time incremental updates via Server-Sent Events
- **Push Notifications:** Asynchronous updates via server-initiated POST to client webhook URLs

## Implementation Details

### Agent Card Example

```python
public_agent_card = AgentCard(
    name='Employee Flight Request Management Agent',
    description='Agent for managing and checking employee flight requests',
    url='http://localhost:9992/',
    version='1.0.0',
    defaultInputModes=['text'],
    defaultOutputModes=['text'],
    capabilities=AgentCapabilities(streaming=False),
    skills=[
        list_pending_requests_skill,
        list_booked_requests_skill,
        check_employee_request_skill
    ],
    supportsAuthenticatedExtendedCard=False,
)
```

### Agent Executor Implementation

```python
class EmployeeFlightRequestAgentExecutor(AgentExecutor):
    """Employee flight request management agent executor."""

    def __init__(self):
        self.agent = EmployeeFlightRequestAgent()

    async def execute(
        self,
        context: RequestContext,
        event_queue: EventQueue,
    ) -> None:
        query = context.get_user_input()
        response = await self.agent.invoke(query)
        await event_queue.enqueue_event(new_agent_text_message(response))

    async def cancel(
        self, context: RequestContext, event_queue: EventQueue
    ) -> None:
        await event_queue.enqueue_event(
            new_agent_text_message("Flight request operation cancelled")
        )
```

### Streaming Implementation

For streaming responses, agents use `TaskUpdater`:

```python
class AirportKnowledgeBaseAgentExecutor(AgentExecutor):
    def __init__(self):
        self.agent = AirportKnowledgeBaseAgent()

    async def execute(self, context: RequestContext, event_queue: EventQueue) -> None:
        query = context.get_user_input()
        task = context.current_task
        if not task:
            task = new_task(context.message)

        updater = TaskUpdater(event_queue, task.id, task.contextId)
        await self.agent.invoke(task, updater, query)
```

Within the agent's invoke method, status updates stream via:

```python
await updater.update_status(
    TaskState.working,
    new_agent_text_message("Accessing airport knowledge base..."),
)
```

### Push Notifications

The `CustomRequestHandler` extends `DefaultRequestHandler` and overrides `on_message_send_stream` to manage push notification logic, storing endpoint information and sending updates asynchronously.

## Agent Skills

Skills represent specific capabilities. The article demonstrates:

```python
list_pending_requests_skill = AgentSkill(
    id='list_pending_requests',
    name='List Pending Flight Requests',
    description='List all employee flight requests not yet booked',
    tags=['flight', 'requests', 'pending', 'left', 'available', 'not booked', 'employee'],
    examples=[
        'list pending flight requests',
        'show pending requests',
        'which flights are not booked',
        'display remaining requests'
    ],
)
```

## Setup Requirements

**Python Version:** 3.13.5

**Installation Note:** The A2A SDK must be installed via UV (not pip) to avoid dependency conflicts:

```shell
uv add a2a-sdk
```

The project uses virtual environments for dependency management.

## Key Takeaways

1. A2A provides a standardized protocol for agent interoperability across different systems
2. Agents expose capabilities through cards, enabling dynamic discovery
3. Three communication patterns (synchronous, streaming, asynchronous) accommodate varying use cases
4. The official SDK abstracts JSON-RPC complexity, simplifying agent development
5. Custom request handlers allow agents to implement specialized communication behaviors
6. Task management and state tracking enable long-running operations with client awareness

## Resources

- Official A2A Documentation: https://a2aproject.github.io/A2A/
- Project Implementation: https://github.com/ezequiroga/a2a-bases
