---
title: "Agents 101: Build and Deploy AI Agents to Production using LangChain"
url: "https://dev.to/manishmshiva/agents-101-build-and-deploy-ai-agents-to-production-using-langchain-535k"
author: "Manish Shivanandhan"
category: "langchain-production"
---

# Agents 101: Build and Deploy AI Agents to Production using LangChain

**Author:** Manish Shivanandhan
**Date Published:** November 26, 2025

---

## Overview

This comprehensive guide demonstrates how to construct production-ready AI agents using LangChain, transforming language models into intelligent systems capable of reasoning, taking action, and maintaining context through conversation.

---

## Key Concepts

### What is an AI Agent?

The article describes agents as "a teammate with a brain and hands." The brain comprises the language model, while tools serve as the hands. The system prompt establishes behavioral rules, enabling agents to plan, act, remember, and respond predictably without hardcoded routing logic.

### Core Components

1. **Language Model** - The reasoning engine
2. **Tools** - Functions the agent can invoke
3. **System Prompt** - Behavioral instructions
4. **Context** - User-specific information
5. **Memory** - Conversation persistence
6. **Response Schema** - Output structure enforcement

---

## Code Examples

### Basic Agent Creation

```python
from langchain.agents import create_agent

def get_weather(city: str) -> str:
    """Get weather for a given city."""
    return f"It's always sunny in {city}!"

agent = create_agent(
    model="gpt-5-mini",
    tools=[get_weather],
    system_prompt="You are a helpful assistant",
)

agent.invoke(
    {"messages": [{"role": "user", "content": "what is the weather in sf"}]}
)
```

### System Prompt Example

```
You are an expert weather forecaster, who speaks in puns. You have access
to two tools: get_weather_for_location and get_user_location. If a user
asks for weather, make sure you know the location.
```

### Tool Definition with Context

```python
from dataclasses import dataclass
from langchain.tools import tool, ToolRuntime

@dataclass
class Context:
    user_id: str

@tool
def get_user_location(runtime: ToolRuntime[Context]) -> str:
    """A context-aware tool that reads user_id from runtime."""
    user_id = runtime.context.user_id
    return "Florida" if user_id == "1" else "SF"
```

### Model Configuration

```python
from langchain.chat_models import init_chat_model

model = init_chat_model(
    "gpt-5-mini",
    temperature=0.5,  # Balances creativity and consistency
    timeout=10,
    max_tokens=1000
)
```

### Response Schema Definition

```python
from dataclasses import dataclass

@dataclass
class ResponseFormat:
    punny_response: str
    weather_conditions: str | None = None
```

### Complete Agent Assembly

```python
from langchain.agents import create_agent
from langchain.output_parsers.tools import ToolStrategy
from langgraph.checkpoint.memory import InMemorySaver

checkpointer = InMemorySaver()

agent = create_agent(
    model=model,
    system_prompt=SYSTEM_PROMPT,
    tools=[get_user_location, get_weather_for_location],
    context_schema=Context,
    response_format=ToolStrategy(ResponseFormat),
    checkpointer=checkpointer
)

config = {"configurable": {"thread_id": "1"}}

response = agent.invoke(
    {"messages": [{"role": "user", "content": "what is the weather outside?"}]},
    config=config,
    context=Context(user_id="1")
)

print(response['structured_response'])
```

---

## Key Takeaways

- **Describe, Don't Hardcode**: Models decide when to use tools based on natural language instructions rather than rigid routing logic

- **Structure Ensures Reliability**: Response schemas transform free-form text outputs into machine-readable, predictable formats suitable for production integration

- **Memory Creates Continuity**: Thread IDs enable agents to maintain conversation context across multiple messages, eliminating amnesia-like behavior

- **Context Personalizes Behavior**: ToolRuntime enables context-aware tools that adapt responses based on user identity without manual parameter passing

- **Configuration Controls Stability**: Temperature, timeout, and token limits determine how consistently the agent behaves across different requests

---

## Production Considerations

Deployment requires:
- Replacing placeholder tools with real API calls
- Migrating in-memory storage (InMemorySaver) to persistent databases
- Implementing authentication and authorization
- Enabling LangSmith tracing for observability
- Adding error handling, retries, and circuit breakers
- Tuning model settings based on cost-reliability tradeoffs

---

## Resources

- Google Colab Notebook for hands-on practice
- Author's newsletter: TuringTalks.ai
- Related comparison: LangChain vs. LangGraph
