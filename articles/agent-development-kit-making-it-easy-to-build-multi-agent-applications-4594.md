---
title: "Agent Development Kit: Making it easy to build multi-agent applications"
url: "https://dev.to/googleai/agent-development-kit-making-it-easy-to-build-multi-agent-applications-4594"
author: "Erwin Huizenga (Google AI)"
category: "multi-agent-frameworks"
---

# Agent Development Kit: Making it easy to build multi-agent applications

**Author:** Erwin Huizenga (Google AI)
**Date Published:** July 29, 2025
**Tags:** #googlecloud #machinelearning #ai #webdev

---

## Overview

Google introduced the Agent Development Kit (ADK) at Cloud NEXT 2025, an open-source framework designed to simplify building production-ready multi-agent systems. The framework powers agents in Google products like Agentspace and the Customer Engagement Suite.

---

## Core Pillars of ADK

The framework provides capabilities across the agent development lifecycle:

- **Multi-Agent by Design:** Compose specialized agents hierarchically with coordination and delegation
- **Rich Model Ecosystem:** Support for Gemini, Vertex AI models, and LiteLLM integration (Anthropic, Meta, Mistral, etc.)
- **Rich Tool Ecosystem:** Pre-built tools, MCP support, third-party library integration
- **Built-in Streaming:** Bidirectional audio/video streaming for natural interactions
- **Flexible Orchestration:** Sequential, parallel, loop workflows plus LLM-driven dynamic routing
- **Integrated Developer Experience:** CLI, Web UI, step-by-step debugging
- **Built-in Evaluation:** Systematic assessment of response quality and execution trajectories
- **Easy Deployment:** Container-based deployment or Vertex AI integration

---

## Getting Started: Basic Agent Example

```python
from google.adk.agents import LlmAgent
from google.adk.tools import google_Search

dice_agent = LlmAgent(
    model="gemini-2.0-flash-exp",  # Required: Specify the LLM
    name="question_answer_agent",  # Required: Unique agent name
    description="A helpful assistant agent that can answer questions.",
    instruction="""Respond to the query using google search""",
    tools=[google_search],  # Provide an instance of the tool
)
# Run with: adk web
```

---

## Multi-Agent Applications: Weather Agent Example

### Step 1: Define a Tool

```python
def get_weather(city: str) -> Dict:
    # Log tool execution for debugging
    print(f"--- Tool: get_weather called for city: {city} ---")
    city_normalized = city.lower().replace(" ", "")

    # Mock weather database
    mock_weather_db = {
        "newyork": {"status": "success",
                   "report": "The weather in New York is sunny with a temperature of 25C."},
        "london": {"status": "success",
                  "report": "It's cloudy in London with a temperature of 15C."},
        "tokyo": {"status": "success",
                 "report": "Tokyo is experiencing light rain and a temperature of 18C."},
        "chicago": {"status": "success",
                   "report": "The weather in Chicago is sunny with a temperature of 25C."},
        "toronto": {"status": "success",
                   "report": "It's partly cloudy in Toronto with a temperature of 30C."},
        "chennai": {"status": "success",
                   "report": "It's rainy in Chennai with a temperature of 15C."},
    }

    # Handle errors gracefully
    if city_normalized in mock_weather_db:
        return mock_weather_db[city_normalized]
    else:
        return {"status": "error",
               "error_message": f"Sorry, I don't have weather information for '{city}'."}
```

### Step 2: Define Agents and Hierarchy

```python
greeting_agent = Agent(
    model=LiteLlm(model="anthropic/claude-3-sonnet-20240229"),
    name="greeting_agent",
    instruction="You are the Greeting Agent. Your ONLY task is to provide a friendly greeting to the user.",
    description="Handles simple greetings and hellos",
)

farewell_agent = Agent(
    model=LiteLlm(model="anthropic/claude-3-sonnet-20240229"),
    name="farewell_agent",
    instruction="You are the Farewell Agent. Your ONLY task is to provide a polite goodbye message.",
    description="Handles simple farewells and goodbyes",
)

root_agent = Agent(
    name="weather_agent_v2",
    model="gemini-2.0-flash-exp",
    description="You are the main Weather Agent, coordinating a team. Provide weather using the `get_weather` tool. Delegate greetings to `greeting_agent` and farewells to `farewell_agent`. Handle weather requests yourself.",
    tools=[get_weather],
    sub_agents=[greeting_agent, farewell_agent]
)
```

### How Delegation Works

- The LLM evaluates the query against agent descriptions
- If another agent is a better fit, it initiates a transfer
- Clear, distinct descriptions are vital for effective routing

---

## Evaluation and Deployment

Before production, systematically evaluate agents against test datasets like `evaluation.test.json` using:
- `AgentEvaluator.evaluate()` for programmatic testing
- ADK CLI eval command
- Web UI evaluation tools

Deploy via container runtime or leverage Vertex AI Agent Engine's managed, scalable runtime.

---

## ADK vs. Genkit Comparison

| Aspect | ADK | Genkit |
|--------|-----|--------|
| Focus | Complex multi-agent systems | Flexible GenAI experiences |
| Abstractions | Higher-level agent behaviors | Fundamental building blocks |
| Streaming | Bidirectional audio/video | Standard support |
| Model Support | Gemini, LiteLLM, Vertex AI | Broad third-party plugins |

**Selection Guide:** Choose ADK for collaborative multi-agent frameworks; choose Genkit for broader flexibility across GenAI projects.

---

## ADK and Google Cloud Integration

ADK optimizes for Google Cloud through:

- Native Gemini model integration (including Gemini 2.5 Pro Experimental)
- Direct deployment to Vertex AI's enterprise-grade runtime
- 100+ pre-built enterprise connectors
- Seamless integration with AlloyDB, BigQuery, NetApp
- Secure API management through Apigee

---

## Key Takeaways

ADK empowers developers to build sophisticated, production-ready multi-agent systems with:

- Precise behavioral control and orchestration
- Extensive tool and integration ecosystem
- Comprehensive developer tooling for debugging
- Robust evaluation framework
- Clear path to enterprise deployment

**Documentation:** [Official ADK Documentation](https://google.github.io/adk-docs)
