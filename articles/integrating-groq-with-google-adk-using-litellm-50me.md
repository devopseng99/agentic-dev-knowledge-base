---
title: "Integrating Groq with Google ADK using LiteLLM"
url: "https://dev.to/mmtq/integrating-groq-with-google-adk-using-litellm-50me"
author: "Mir Md Tarhimul Quader"
category: "groq-api-agent"
---

# Integrating Groq with Google ADK using LiteLLM

**Author:** Mir Md Tarhimul Quader
**Published:** September 29, 2025

## Overview
Shows how to integrate Groq models with Google ADK through LiteLLM as a bridge, since there is no official documentation on either side for direct integration.

## Key Concepts

LiteLLM serves as a bridge between Groq and ADK. Groq models are accessed using the format: `groq/<groq-model-name>`

### Code Example

```python
from dotenv import load_dotenv
from google.adk.agents import Agent
from google.adk.models.lite_llm import LiteLlm

load_dotenv()

model = LiteLlm(
    model="groq/llama-3.3-70b-versatile",
)

root_agent = Agent(
    name="greeting_agent",
    model=model,
    description="This agent greets the user.",
    instruction="""
    You are a helpful assistant that greets the users. Ask for the user's name and greet them by name.
    """
)
```

This minimal setup demonstrates successful agent functionality using Groq's models orchestrated through Google ADK.
