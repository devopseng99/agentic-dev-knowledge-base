---
title: "Building a News and Stock Assistant with LangGraph and Chainlit"
url: "https://dev.to/jamesbmour/building-a-news-and-stock-assistant-with-langgraph-and-chainlit-1bkk"
author: "James"
category: "agent-ui-frameworks"
---

# Building a News and Stock Assistant with LangGraph and Chainlit
**Author:** James
**Published:** September 1, 2025

## Overview
AI assistant combining news aggregation and stock data using LangGraph orchestration, Chainlit chat UI, Google News, Yahoo Finance via MCP, and LLM backbone.

## Key Concepts

### Tool Definition
```python
@tool
def get_topic_headlines(topic: str) -> str:
    """Get news headlines for a specific topic."""
```

### MCP Integration
```python
async with stdio_client(server_params) as (read, write):
    mcp_tools = await load_mcp_tools(session)
```

- State graph with decision logic for tool calling vs conversation end
- Recursion limits to prevent infinite loops
- Real-time streaming via Chainlit async handling
- Support for Ollama and OpenRouter LLM providers
