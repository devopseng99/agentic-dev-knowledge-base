---
title: "Building AI Agents with Haystack and Gaia Node: A Practical Guide"
url: "https://dev.to/gaiaai/building-ai-agents-with-haystack-and-gaia-node-a-practical-guide-5993"
author: "Harish Kotra"
category: "agent-sdks"
---

# Building AI Agents with Haystack and Gaia Node
**Author:** Harish Kotra
**Published:** August 27, 2025

## Overview
Combining Haystack framework with self-hosted LLMs via Gaia Node for private, infrastructure-controlled AI agents with web search capabilities.

## Key Concepts

```python
from haystack_experimental.components.agents import Agent
from haystack.components.generators.chat import OpenAIChatGenerator
from haystack.utils import Secret

chat_generator = OpenAIChatGenerator(
    api_key=Secret.from_env_var("GAIA_API_KEY"),
    api_base_url=os.getenv("GAIA_NODE_URL"),
    model=os.getenv("GAIA_MODEL_NAME", "llama3b")
)

tool_calling_agent = Agent(
    chat_generator=chat_generator,
    system_prompt="You are a helpful agent with web search capabilities...",
    tools=[web_tool]
)
```

Three-component stack: Haystack (framework), Gaia Node (self-hosted inference), SerperDev (web search).
