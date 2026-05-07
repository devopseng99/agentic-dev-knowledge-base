---
title: "Exploring My OpenAI Agents Examples Repository"
url: "https://dev.to/gabrielvanderlei/exploring-my-openai-agents-examples-repository-4hhb"
author: "Gabriel Vanderlei"
category: "full-code-examples"
---

# Exploring My OpenAI Agents Examples Repository
**Author:** Gabriel Vanderlei
**Published:** March 22, 2025

## Overview
Structured repository demonstrating OpenAI Agents functionality through examples covering simple agents, handoffs, guardrails, function tools, and agents-as-tools patterns.

## Key Concepts

### Repository Structure
```
openai-agent-examples/
├── 1-5_introduction_examples/
├── 6_simple_chat/
├── 7_simple_chat_with_apis/
├── 8_simple_chat_with_gradio/
├── .env.example
├── .gitignore
└── README.md
```

### Example 1: Simple Agent

```python
from agents import Agent

agent = Agent(
    name="Math Tutor",
    instructions="You provide help with math problems. Explain your reasoning at each step and include examples",
)
```

### Example 2: Handoffs Between Agents

```python
triage_agent = Agent(
    name="Triage Agent",
    instructions="You determine which agent to use based on the user's homework question",
    handoffs=[history_tutor_agent, math_tutor_agent]
)
```

### Example 3: Input Guardrails

```python
from agents import Agent, InputGuardrail, GuardrailFunctionOutput, Runner
from pydantic import BaseModel

class HomeworkOutput(BaseModel):
    is_homework: bool
    reasoning: str
```

### Example 4: Python Functions as Tools

```python
@function_tool
async def fetch_weather(location: Location) -> str:
    """Fetch the weather for a given location."""
    return "sunny"
```

### Example 5: Agents as Tools

```python
orchestrator_agent = Agent(
    name="orchestrator_agent",
    instructions=(
        "You are a translation agent. You use the tools given to you to translate."
        "If asked for multiple translations, you call the relevant tools."
    ),
    tools=[
        spanish_agent.as_tool(
            tool_name="translate_to_spanish",
            tool_description="Translate the user's message to Spanish",
        ),
        french_agent.as_tool(
            tool_name="translate_to_french",
            tool_description="Translate the user's message to French",
        ),
    ],
)
```

### Advanced Examples (6-8)
- Chat systems with API integration (Bitcoin pricing via CoinGecko, weather data)
- Gradio web interface for deployment
