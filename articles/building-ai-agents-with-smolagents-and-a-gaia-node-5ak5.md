---
title: "Building AI Agents with smolagents and a Gaia Node"
url: "https://dev.to/gaiaai/building-ai-agents-with-smolagents-and-a-gaia-node-5ak5"
author: "Harish Kotra"
category: "agent-framework"
---

# Building AI Agents with smolagents and a Gaia Node

**Author:** Harish Kotra (he/him)
**Organization:** Gaia
**Published:** August 17, 2025

---

## Overview

This article demonstrates how to construct intelligent agents using the smolagents framework integrated with Gaia Node infrastructure. The tutorial covers three primary learning objectives.

## Key Topics Covered

1. Configuring smolagents with a Gaia Node
2. Defining reusable tools using the `@tool` decorator
3. Creating agents that interpret natural language queries

---

## Code Example: Weather Agent Implementation

```python
from smolagents.agents import ToolCallingAgent
from smolagents import tool, LiteLLMModel
from typing import Optional
import requests

# Configure the model with Gaia's tooling node
model = LiteLLMModel(
    model_id="openai/llama",  # Using OpenAI format for Gaia compatibility
    api_base="https://llama3b.gaia.domains/v1",  # Gaia's tooling node
    api_key="gaia-"  # API key for Gaia node
)

@tool
def get_weather(location: str, celsius: Optional[bool] = True) -> str:
    """
    Get current weather conditions for a location using wttr.in service.

    This function fetches weather data in a human-readable format without requiring
    any API keys. It provides comprehensive weather information including temperature,
    conditions, and forecast.

    Args:
        location: The city name or location to get weather for
        celsius: Whether to return temperature in Celsius (True) or Fahrenheit (False)

    Returns:
        A formatted string containing current weather conditions
    """
    try:
        unit = 'm' if celsius else 'u'
        url = f"https://wttr.in/{location}?format=3&{unit}"

        response = requests.get(url, headers={'User-Agent': 'curl'}, timeout=10)
        response.raise_for_status()

        weather_data = response.text.strip()

        detailed_response = (
            f"Weather Report for {location}:\n"
            f"{weather_data}\n\n"
            f"Temperature is shown in {'Celsius' if celsius else 'Fahrenheit'}"
        )

        return detailed_response

    except requests.exceptions.RequestException as e:
        return f"I apologize, but I couldn't fetch the weather data: {str(e)}"

# Create our weather-capable agent
agent = ToolCallingAgent(tools=[get_weather], model=model)

def demonstrate_weather_queries():
    """
    Demonstrate various weather queries to show the agent's capabilities.
    This function shows how the agent can handle different types of weather requests.
    """
    print("Weather Agent Demonstration\n" + "="*25 + "\n")

    test_queries = [
        "What's the weather like in London?",
        "Tell me the current conditions in Tokyo",
        "How's the weather in New York City with temperatures in Fahrenheit?",
        "What's the weather like in Paris, France?"
    ]

    for query in test_queries:
        print(f"\nQuery: {query}")
        try:
            response = agent.run(query)
            print(f"Response: {response}")
        except Exception as e:
            print(f"Error processing query: {str(e)}")
        print("-" * 50)

if __name__ == "__main__":
    demonstrate_weather_queries()
```

---

## Key Takeaways

- **Model Configuration:** The example illustrates setting up a language model via Gaia's infrastructure with LiteLLMModel
- **Tool Decoration:** The `@tool` decorator enables simple function wrapping for agent accessibility
- **Error Handling:** Robust exception management ensures graceful degradation when external services become unavailable
- **Agent Execution:** Natural language commands trigger tool invocation without explicit programming

---

## Prerequisites

Users require a Gaia Developer API key, obtainable through the official documentation.
