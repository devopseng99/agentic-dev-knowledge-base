---
title: "My experience and feedback on Hugging Face (smolagent) Agent Course (so far)"
url: "https://dev.to/aairom/my-experience-and-feedback-on-hugging-face-smolagent-agent-course-so-far-mee"
author: "Alain Airom"
category: "smolagents-huggingface"
---

# My experience and feedback on Hugging Face (smolagent) Agent Course

**Author:** Alain Airom (Ayrom)
**Published:** February 27, 2025

## Overview

A review of the Hugging Face smolagent Agent Course, described as a multi-level course on AI Agents covering understanding agents, LLMs' roles, tools/actions, and agent workflows. The "Frameworks for AI Agents" exam requires 80% completion through five code samples.

## Key Concepts

### Q1 - Basic Code Agent with Web Search

```python
from smolagents import CodeAgent, DuckDuckGoSearchTool, HfApiModel

agent = CodeAgent(
    tools=[DuckDuckGoSearchTool()],
    model=HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct")
)
response = agent.run("best music for a party")
```

### Q2 - Multi-Agent System

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

### Q4 - Tool-Calling Agent

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

### Q5 - Model Integration

```python
from smolagents import HfApiModel, LiteLLMModel

hf_model = HfApiModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct")
litellm_model = LiteLLMModel(model_id="anthropic/claude-3-sonnet")
model = hf_model
```

## Recommendations

The author recommends the course absolutely for newcomers to AI agents, emphasizing its value for those beginning in this field. Several attempts may be needed for the exam, and over-providing code is unnecessary.
