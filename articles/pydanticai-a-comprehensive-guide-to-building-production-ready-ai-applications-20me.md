---
title: "PydanticAI: A Comprehensive Guide to Building Production-Ready AI Applications"
url: "https://dev.to/yashddesai/pydanticai-a-comprehensive-guide-to-building-production-ready-ai-applications-20me"
author: "Yash Desai"
category: "agent-sdks"
---

# PydanticAI: A Comprehensive Guide to Building Production-Ready AI Applications
**Author:** Yash Desai
**Published:** December 29, 2024

## Overview
Comprehensive PydanticAI reference covering agents, system prompts, function tools, dependencies, structured results, conversations, usage limits, dynamic tools, and unit testing.

## Key Concepts

### Structured Results
```python
from pydantic import BaseModel
from pydantic_ai import Agent

class CityLocation(BaseModel):
    city: str
    country: str

agent = Agent('gemini-1.5-flash', result_type=CityLocation)
result = agent.run_sync('Where were the olympics held in 2012?')
print(result.data)  # city='London' country='United Kingdom'
```

### Function Tools with Dependencies
```python
@agent.tool
def get_player_name(ctx: RunContext[str]) -> str:
    return ctx.deps

@agent.tool_plain
def roll_die() -> str:
    return str(random.randint(1, 6))
```

### Dynamic Tools
```python
async def only_if_42(ctx: RunContext[int], tool_def: ToolDefinition) -> Union[ToolDefinition, None]:
    if ctx.deps == 42:
        return tool_def

@agent.tool(prepare=only_if_42)
def hitchhiker(ctx: RunContext[int], answer: str) -> str:
    return f'{ctx.deps} {answer}'
```
