---
title: "Create an AI Agent with PydanticAI in Minutes"
url: "https://dev.to/business24ai/create-an-ai-agent-with-pydanticai-in-minutes-3k07"
author: "Kiu"
category: "agent-sdks"
---

# Create an AI Agent with PydanticAI in Minutes
**Author:** Kiu
**Published:** January 18, 2025

## Overview
Step-by-step guide to building a functional AI agent using PydanticAI and OpenAI with environment setup, model configuration, and result inspection.

## Key Concepts

### Setup
```python
python -m venv venv
source venv/bin/activate
pip install pydantic-ai
```

### Agent Definition and Execution
```python
from pydantic_ai import Agent
from pydantic_ai.models.openai import OpenAIModel

model = OpenAIModel("gpt-4o")
agent = Agent(
    model=model,
    system_prompt="Be concise, reply with one sentence.",
)

result = agent.run_sync("What does AGI mean?")
print(result.data)
print(result.usage())
print(result.all_messages())
```
