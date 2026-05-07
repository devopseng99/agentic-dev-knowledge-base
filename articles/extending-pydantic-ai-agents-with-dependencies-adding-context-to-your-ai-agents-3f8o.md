---
title: "Extending Pydantic AI Agents with Dependencies"
url: "https://dev.to/hamluk/extending-pydantic-ai-agents-with-dependencies-adding-context-to-your-ai-agents-3f8o"
author: "Lukas Hamm"
category: "agent-sdks"
---

# Extending Pydantic AI Agents with Dependencies
**Author:** Lukas Hamm
**Published:** October 15, 2025

## Overview
Tutorial on adding contextual dependencies to PydanticAI agents using type-safe dependency injection for user and project awareness.

## Key Concepts

### Dependency Definition
```python
from dataclasses import dataclass

@dataclass
class TaskDependency:
    username: str
    project: str
```

### Agent with Dependencies
```python
class TaskAgent():
    def _init_agent(self) -> Agent:
        agent = Agent(
            model=MistralModel(model_name=os.getenv("LLM_MISTRAL_MODEL"),
                              provider=MistralProvider(api_key=os.getenv("MISTRAL_API_KEY"))),
            output_type=TaskModel,
            deps_type=TaskDependency,
        )

        @agent.system_prompt
        def create_system_prompt(ctx: RunContext[TaskDependency]) -> str:
            return f"Create a brief task from the user's request. The task is created by {ctx.deps.username}. The task belongs to the project {ctx.deps.project}."

        return agent
```
