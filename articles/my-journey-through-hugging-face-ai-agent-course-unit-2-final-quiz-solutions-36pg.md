---
title: "My Journey through Hugging Face AI Agent Course - Unit 2.1 Final Quiz Solutions"
url: "https://dev.to/roberto_cemeri/my-journey-through-hugging-face-ai-agent-course-unit-2-final-quiz-solutions-36pg"
author: "Roberto Cemeri"
category: "smolagents-huggingface"
---

# My Journey through Hugging Face AI Agent Course - Unit 2.1 Final Quiz Solutions

**Author:** Roberto Cemeri
**Published:** February 27, 2025

## Overview

Solutions from completing the Hugging Face AI Agent Course Unit 2.1 Final Quiz, covering five key implementation tasks using smolagents.

## Key Concepts

### Question 1: Basic Code Agent with Web Search

```python
from smolagents import CodeAgent, DuckDuckGoSearchTool, HfApiModel

agent = CodeAgent(
    tools=[DuckDuckGoSearchTool()],
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct")
)
response = agent.run("best music for a party")
```

### Question 2: Multi-Agent System

```python
from smolagents import CodeAgent, ToolCallingAgent, DuckDuckGoSearchTool, HfApiModel, VisitWebpageTool

web_agent = ToolCallingAgent(
    tools=[DuckDuckGoSearchTool(), VisitWebpageTool()],
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct"),
    max_steps=10,
    name="search",
    description="Agent to perform web searches and visit webpages."
)

manager_agent = CodeAgent(
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct"),
    managed_agents=[web_agent],
    additional_authorized_imports=["pandas", "time", "numpy"]
)
```

### Question 3: Agent Security Configuration

Implements security using E2BSandbox to isolate execution environments and restricts imports to authorized libraries like numpy.

```python
from smolagents import CodeAgent, HfApiModel
from smolagents.sandbox import E2BSandbox

agent = CodeAgent(
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct"),
    sandbox=E2BSandbox(),
    additional_authorized_imports=["numpy"]
)
```

### Question 4: Tool-Calling Agent

```python
from smolagents import ToolCallingAgent, HfApiModel, DuckDuckGoSearchTool

agent = ToolCallingAgent(
    tools=[DuckDuckGoSearchTool()],
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct"),
    name="SearchAgent",
    description="An agent that uses DuckDuckGo to search the web.",
    max_steps=5,
)
```

### Question 5: Model Integration

```python
from smolagents import HfApiModel, LiteLLMModel

hf_model = HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct")
litellm_model = LiteLLMModel(model_id="anthropic/claude-3-sonnet")

# Switch between models based on requirements
model = hf_model  # or litellm_model
```

## Key Takeaways

- Tool integration extends agent capabilities
- Security practices are essential for safe deployment
- Model flexibility enables task-specific optimization
- Multi-agent architectures support complex system design
