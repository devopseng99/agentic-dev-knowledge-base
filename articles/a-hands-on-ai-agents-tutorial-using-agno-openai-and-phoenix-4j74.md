---
title: "A Hands-On AI Agents Tutorial Using Agno, OpenAI, and Phoenix"
url: "https://dev.to/maria-dac/a-hands-on-ai-agents-tutorial-using-agno-openai-and-phoenix-4j74"
author: "Maria Siewierska"
category: "phidata-agent"
---

# A Hands-On AI Agents Tutorial Using Agno, OpenAI, and Phoenix

**Author:** Maria Siewierska
**Published:** March 12, 2026

## Overview

Practical tutorial on AI agents explaining what an LLM really is, how tokens and context windows shape behavior, and how agents are built by orchestrating systems around an LLM. Uses Agno for agent orchestration, OpenAI for tokenization, and Arize Phoenix for observability.

## Key Concepts

### What Is an AI Agent?

An AI agent is not just an LLM. It is a system architecture that combines:
- Language models for reasoning
- Context management for relevant information
- Memory for conversation continuity
- Tools for external actions
- Guardrails for safety
- Orchestration logic for coordination

### Technology Stack

- **Agno**: Agent framework for orchestrating LLM calls, conversation history, session management, and tool execution
- **OpenAI**: Tokenizer tool for understanding token economics
- **Arize Phoenix**: Monitoring and observability platform

### Progressive Agent Building

```python
from agno.agent import Agent
from agno.models.openai import OpenAIChat

# Level 1: Stateless Agent
stateless_agent = Agent(
    model=OpenAIChat(id="gpt-4o"),
    description="You are a helpful assistant.",
)

# Level 2: Agent with Session History
from agno.memory import Memory

session_agent = Agent(
    model=OpenAIChat(id="gpt-4o"),
    memory=Memory(),
    description="You remember our conversation.",
)

# Level 3: Agent with Persistent Memory
from agno.storage import SqliteStorage

persistent_agent = Agent(
    model=OpenAIChat(id="gpt-4o"),
    memory=Memory(),
    storage=SqliteStorage(db_file="agent_memory.db"),
    description="You remember across sessions.",
)
```

### Observability with Phoenix

```python
from phoenix.otel import register
from openinference.instrumentation.agno import AgnoInstrumentor

# Initialize tracing
tracer_provider = register(project_name="my-agent")
AgnoInstrumentor().instrument(tracer_provider=tracer_provider)

# All agent calls are now traced in Phoenix dashboard
```

### Key Takeaways

- Start with stateless agents, add memory incrementally
- Use observability from day one to understand agent behavior
- Token economics determine cost and context window management
- Session management is critical for production agents
