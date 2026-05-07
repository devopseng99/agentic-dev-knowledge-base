---
title: "Build an AI Agent from Scratch - No Frameworks, Just Python"
url: https://dev.to/shashi_kiran_bcfdbb223140/build-an-ai-agent-from-scratch-no-frameworks-just-python-3850
author: Shashi Kiran
category: ai-agent-python-scratch
---

# Build an AI Agent from Scratch -- No Frameworks, Just Python

**Author:** Shashi Kiran
**Published:** March 9, 2026
**Tags:** #ai #openai #machinelearning #python

---

## Overview

The article demonstrates how to construct a functional AI agent using only Python and the OpenAI API, bypassing framework abstractions like LangChain or AutoGen. The tutorial emphasizes understanding the underlying mechanisms rather than relying on black-box tools.

## Core Concept: The ReAct Pattern

The foundational loop operates as: "Think -> Act -> Observe -> Repeat"

An AI agent differs from standard LLM calls by:
- Reasoning about required actions
- Accessing external tools
- Iterating based on observations

## Implementation Overview

### Step 1: Tool Definitions

Two sample tools are created:

```python
def calculator(expression: str) -> str:
    """Safely evaluate a math expression."""
    try:
        result = eval(expression, {"__builtins__": {}}, {"sqrt": math.sqrt, "pow": pow})
        return str(result)
    except Exception as e:
        return f"Error: {e}"

def get_weather(city: str) -> str:
    """Return fake weather data for demo purposes."""
    fake_data = {
        "london": "Cloudy, 15C",
        "new york": "Sunny, 22C",
        "tokyo": "Rainy, 18C",
    }
    return fake_data.get(city.lower(), "Weather data not available for this city.")
```

Tools are registered with JSON schemas describing their function signatures for the LLM.

### Step 2: Agent Loop Implementation

```python
from openai import OpenAI

client = OpenAI()

def run_agent(user_query: str):
    print(f"\nUser: {user_query}\n")

    messages = [
        {
            "role": "system",
            "content": (
                "You are a helpful assistant. Use tools when needed. "
                "Once you have enough information, provide a final answer."
            ),
        },
        {"role": "user", "content": user_query},
    ]

    while True:
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=messages,
            tools=TOOL_SCHEMAS,
            tool_choice="auto",
        )

        message = response.choices[0].message

        if not message.tool_calls:
            print(f"Agent: {message.content}")
            return message.content

        messages.append(message)

        for tool_call in message.tool_calls:
            tool_name = tool_call.function.name
            tool_args = json.loads(tool_call.function.arguments)

            print(f"Calling tool: {tool_name}({tool_args})")

            tool_fn = TOOLS.get(tool_name)
            if tool_fn:
                result = tool_fn(**tool_args)
            else:
                result = f"Error: tool '{tool_name}' not found."

            print(f"Tool result: {result}\n")

            messages.append({
                "role": "tool",
                "tool_call_id": tool_call.id,
                "content": result,
            })
```

### Step 3: Execution

```python
if __name__ == "__main__":
    run_agent("What is the square root of 144, and what's the weather like in Tokyo?")
```

Expected output demonstrates the agent calling calculator and weather tools sequentially.

## Key Mechanics

The LLM serves as the decision-making entity but never executes tools directly. Instead:
1. The model indicates which tool to invoke
2. Application code performs execution
3. Results feed back into the message history
4. The loop continues until no additional tool calls are needed

## Advantages of Building From Scratch

- Complete control over every LLM message
- Simplified debugging without hidden logic
- Deeper comprehension of framework internals

## Extension Possibilities

The article suggests potential enhancements:
- Adding web search capabilities via API integration
- Persistent memory systems using databases
- Multi-agent architectures
- Token streaming for real-time responses

## Prerequisites

- Python 3.9 or later
- OpenAI API credentials
- `openai` library installation

---

**Key Takeaway:** "Agents aren't magic. They're just LLMs in a loop with access to tools." The demonstration provides an 80-line foundation for understanding how enterprise agent frameworks operate at their core.
