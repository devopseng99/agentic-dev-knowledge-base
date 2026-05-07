---
title: "Microsoft Agent Framework 1.0: Build AI Agents in .NET and Python"
url: "https://dev.to/jangwook_kim_e31e7291ad98/microsoft-agent-framework-10-build-ai-agents-in-net-and-python-kka"
author: "Jangwook Kim"
category: "agent orchestration framework"
---

# Microsoft Agent Framework 1.0: Build AI Agents in .NET and Python

**Author:** Jangwook Kim
**Published:** April 15, 2026

## Overview
Microsoft released Agent Framework 1.0 on April 3, 2026, representing the convergence of Semantic Kernel and AutoGen (75,000+ combined GitHub stars). The framework provides production-ready agent orchestration for .NET and Python with MCP integration, YAML declarative workflows, and five stabilized multi-agent patterns.

## Key Concepts

### MCP Tool Discovery

```python
from agent_framework import Agent, AgentConfig
from agent_framework.tools.mcp import McpServerToolProvider

tool_provider = McpServerToolProvider(server_url="http://localhost:8080")

agent = Agent(
    config=AgentConfig(
        instructions="You are a helpful assistant with access to external tools.",
        model="azure-openai/gpt-4o",
    ),
    tool_providers=[tool_provider],
)

response = await agent.run("Summarize the latest PRs from my GitHub repo")
print(response.content)
```

### Basic Agent with Tool

```python
from agent_framework import Agent, AgentConfig
from agent_framework.tools import tool

@tool(description="Get the current weather for a city")
def get_weather(city: str) -> str:
    return f"The weather in {city} is currently 72F and sunny."

agent = Agent(
    config=AgentConfig(
        name="WeatherAssistant",
        instructions="You help users check weather conditions. Always be concise.",
        model="azure-openai/gpt-4o",
    ),
    tools=[get_weather],
)

import asyncio

async def main():
    response = await agent.run("What's the weather like in Seattle?")
    print(response.content)

asyncio.run(main())
```

### YAML Agent Configuration

```yaml
name: research-pipeline
description: Multi-agent research and summarization pipeline

agents:
  - id: searcher
    model: azure-openai/gpt-4o
    instructions: |
      You are a research specialist. Find relevant information
      on the given topic from multiple perspectives.
    tools:
      - type: mcp
        server_url: http://search-mcp-server:8080

  - id: synthesizer
    model: azure-openai/gpt-4o
    instructions: |
      You synthesize research into clear, structured summaries.
      Always cite your sources.

workflow:
  type: sequential
  steps:
    - agent: searcher
    - agent: synthesizer
```

### Loading YAML Pipeline

```python
from agent_framework import WorkflowLoader

loader = WorkflowLoader()
pipeline = loader.load("agents/research-pipeline.yaml")

result = await pipeline.run("Summarize recent advances in quantum error correction")
print(result.final_output)
```

### Middleware Implementation

```python
from agent_framework.middleware import AgentMiddleware, MiddlewareContext

class AuditMiddleware(AgentMiddleware):
    async def on_turn_start(self, ctx: MiddlewareContext) -> None:
        print(f"[AUDIT] Agent {ctx.agent_id} started turn {ctx.turn_id}")

    async def on_turn_end(self, ctx: MiddlewareContext) -> None:
        print(f"[AUDIT] Turn {ctx.turn_id} completed in {ctx.elapsed_ms}ms")
        print(f"[AUDIT] Tokens used: {ctx.token_usage.total}")

agent = Agent(
    config=AgentConfig(model="azure-openai/gpt-4o"),
    middleware=[AuditMiddleware()],
)
```

### Installation

```bash
pip install agent-framework
# Or selective:
pip install agent-framework-core agent-framework-openai
```

### Five Orchestration Patterns
Sequential, Concurrent, Handoff, Group Chat, and Magentic-One.
