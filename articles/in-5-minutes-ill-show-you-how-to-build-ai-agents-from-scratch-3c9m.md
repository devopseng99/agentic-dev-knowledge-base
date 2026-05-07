---
title: "How to build AI agents from scratch"
url: "https://dev.to/proflead/in-5-minutes-ill-show-you-how-to-build-ai-agents-from-scratch-3c9m"
author: "Vladislav Guzey"
category: "full-code-examples"
---

# How to build AI agents from scratch
**Author:** Vladislav Guzey
**Published:** December 7, 2025

## Overview
Tutorial building AI agents using Google's ADK (Agent Development Kit), an open-source framework. Covers single agents, multi-agent systems with tool delegation, and web interface deployment.

## Key Concepts

### GitHub Repository
https://github.com/proflead/how-to-build-ai-agents-from-scratch

### Project Setup

```shell
mkdir my_first_agent
cd my_first_agent
python -m venv .venv
source .venv/bin/activate
pip install google-adk
adk create my_agent
```

### API Key Configuration
```shell
GOOGLE_API_KEY="your-key-here"
```

### Multi-Agent System

```python
from google.adk.agents.llm_agent import Agent
from google.adk.tools import google_search, AgentTool

research_agent = Agent(
    name="Researcher",
    model="gemini-2.5-flash-lite",
    instruction="""You are a specialized research agent. Your only job is to use the
    google_search tool to find top 5 AI news for a give topic.""",
    tools=[google_search],
    output_key="research_result",
)

summarizert = Agent(
    name="Summarizert",
    model="gemini-2.5-flash-lite",
    instruction="""
    Read the research findings {research_result} and create a summary for each topic
    with the link to read more
    """,
    output_key="summary_result",
)

root_agent = Agent(
    model='gemini-2.5-flash-lite',
    name='root_agent',
    description='A helpful assistant for user questions.',
    instruction="""
    You are coordinator. First delegate to 'research_agent' to gather information.
    Second pass findings to 'summarizert' to create a summary.
    Finally, compile the summaries into a final response.
    """,
    tools=[
        AgentTool(research_agent),
        AgentTool(summarizert),
    ]
)
```

### Running

```shell
adk run my_agent
adk web --port 8000  # Web interface
```
