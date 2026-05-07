---
title: "Getting Started with PydanticAI - Basics for AI Agents in Python"
url: https://dev.to/hamluk/getting-started-with-pydanticai-basics-for-ai-agents-in-python-4jlo
author: Lukas Hamm
category: pydantic-ai
---

# Getting Started with PydanticAI -- Basics for AI Agents in Python

**Author:** Lukas Hamm
**Published:** October 14, 2025
**Modified:** October 16, 2025
**Tags:** #pydanticai #ai #python #learning

---

## Overview

This article introduces developers to PydanticAI, a Python framework for building AI agents with structured, predictable outputs. The author explains that "AI Agents have the potential to change the way software projects are built, becoming a standard part of future codebases."

## Key Concepts

### Agents
An agent in PydanticAI is a self-contained component that receives instructions, interacts with a language model, and returns results. Unlike direct LLM calls, agents are reusable, predictable, and easily integrated into larger workflows.

### Structured Output
PydanticAI's defining feature enables developers to define response schemas using Pydantic models. This guarantees that AI responses conform to expected data structures, reducing parsing errors and enabling reliable integration with other software components.

## Project Setup

### Installation
```bash
poetry new LearnPydanticAI
cd LearnPydanticAI
poetry add "pydantic-ai-slim[mistral]"
poetry add python-dotenv
```

### Environment Configuration
**.env file:**
```
LLM_MISTRAL_MODEL=<mistral_model>
MISTRAL_API_KEY=<mistral_api_key>
```

## Building Your First Agent

### Basic Agent Implementation
```python
from pydantic_ai.models.mistral import MistralModel
from pydantic_ai.providers.mistral import MistralProvider
from pydantic_ai import Agent
import os

class TaskAgent:
    def __init__(self):
        self.agent = self._init_agent()

    def _init_agent(self) -> Agent:
        agent = Agent(
            model=MistralModel(
                model_name=os.getenv("LLM_MISTRAL_MODEL"),
                provider=MistralProvider(api_key=os.getenv("MISTRAL_API_KEY"))
            ),
            system_prompt="Create a brief task from the user's request."
        )
        return agent

    def run(self, query: str) -> str:
        result = self.agent.run_sync(query)
        return result.output
```

### Basic Usage
```python
from dotenv import load_dotenv
from LearnPydanticAI.agent import TaskAgent

load_dotenv()
agent = TaskAgent()
answer = agent.run("I want to learn more about Pydantic AI")
print(answer)
```

## Adding Structured Output

### Pydantic Model Definition
```python
from pydantic import BaseModel, Field

class TaskModel(BaseModel):
    task: str = Field(description="The title of the task.")
    description: str = Field(description="A brief description of the task specifying its goal.")
    priority: int = Field(description="The task priority on a scale from 1 (high) to 5 (low).")
```

### Integrating with Agent
```python
class TaskAgent:
    def _init_agent(self) -> Agent:
        agent = Agent(
            model=MistralModel(
                model_name=os.getenv("LLM_MISTRAL_MODEL"),
                provider=MistralProvider(api_key=os.getenv("MISTRAL_API_KEY"))
            ),
            output_type=TaskModel,
            system_prompt="Create a brief task from the user's request."
        )
        return agent
```

## Key Takeaways

- PydanticAI enables creation of reusable, predictable AI agents
- Structured output eliminates manual response parsing
- Field descriptions guide model behavior toward more reliable outputs
- The framework supports multiple LLM providers (model-agnostic)
- Agents can be easily integrated into production software workflows

## Next Steps

The author references a follow-up article covering "dependencies, extending agent capabilities, and connecting with external data sources."

**Repository:** [hamluk/LearnPydanticAI/part-1](https://github.com/hamluk/LearnPydanticAI/tree/part-1)
