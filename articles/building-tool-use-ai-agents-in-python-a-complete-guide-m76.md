---
title: "Building Tool Use AI Agents in Python: A Complete Guide"
url: "https://dev.to/iniyarajan86/building-tool-use-ai-agents-in-python-a-complete-guide-m76"
author: "Iniyarajan"
category: "autonomous-operations"
---
# Building Tool Use AI Agents in Python: A Complete Guide
**Author:** Iniyarajan  **Published:** May 2, 2026

## Overview
Tool use enables agents to "call functions, APIs, and external services" rather than remaining limited to text generation alone. Language models identify when external capabilities are needed and invoke specific functions with appropriate parameters.

## Key Concepts

### Essential Libraries
- **LangChain**: Pre-built tool integrations and `@tool` decorators
- **OpenAI Function Calling**: Reliable structured output
- **Pydantic**: Parameter validation and serialization
- **Requests/httpx**: API integrations

### Weather Tool Definition

```python
from langchain.tools import tool
from pydantic import BaseModel, Field
import requests

class WeatherQuery(BaseModel):
    location: str = Field(description="City name for weather lookup")
    units: str = Field(default="metric", description="Temperature units")

@tool("get_weather", args_schema=WeatherQuery)
def get_weather(location: str, units: str = "metric") -> str:
    """Get current weather for a specific location."""
    api_key = "your_api_key"
    url = f"https://api.openweathermap.org/data/2.5/weather"
    params = {"q": location, "appid": api_key, "units": units}

    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        temp = data["main"]["temp"]
        description = data["weather"][0]["description"]
        return f"Weather in {location}: {temp}°, {description}"
    return f"Could not fetch weather for {location}"
```

### Multi-Tool Agent

```python
from langchain.agents import initialize_agent, AgentType
from langchain.llms import OpenAI
from langchain.tools import tool
from langchain.memory import ConversationBufferMemory
import requests
import math

@tool
def calculate(expression: str) -> str:
    """Safely evaluate mathematical expressions."""
    try:
        allowed_chars = set('0123456789+-*/.() ')
        if not all(c in allowed_chars for c in expression):
            return "Invalid characters in expression"

        result = eval(expression, {"__builtins__": {}, "math": math})
        return str(result)
    except Exception as e:
        return f"Calculation error: {str(e)}"

@tool
def search_web(query: str) -> str:
    """Search the web for current information."""
    search_url = f"https://api.duckduckgo.com/"
    params = {"q": query, "format": "json", "no_html": "1"}

    try:
        response = requests.get(search_url, params=params)
        data = response.json()
        if data.get("Abstract"):
            return data["Abstract"]
        return "No specific results found"
    except Exception as e:
        return f"Search failed: {str(e)}"

tools = [get_weather, calculate, search_web]
memory = ConversationBufferMemory(memory_key="chat_history")
llm = OpenAI(temperature=0)

agent = initialize_agent(
    tools=tools,
    llm=llm,
    agent=AgentType.CONVERSATIONAL_REACT_DESCRIPTION,
    memory=memory,
    verbose=True
)

response = agent.run("What's the weather in Tokyo and what's 15% of 240?")
```

### Advanced Patterns
- **Tool Chaining:** Uses one tool's output as input for another
- **Parallel Execution:** Run independent tools simultaneously
- **Error Recovery:** Agents attempt alternative approaches on failure
- **Context Management:** Tracks results across conversation turns

### Production Best Practices

**Security**
- Validate all tool parameters with Pydantic
- Use allowlists for sensitive operations
- Run tools in sandboxed environments
- Never execute arbitrary code from LLM outputs

**Performance Optimization**
- Implement async operations with `asyncio` and `aiohttp`
- Cache results for identical parameters using Redis
- Select tools strategically based on cost and latency

**Framework Selection**
- LangChain: rapid development
- CrewAI: multi-agent coordination
- AutoGen: conversational patterns
