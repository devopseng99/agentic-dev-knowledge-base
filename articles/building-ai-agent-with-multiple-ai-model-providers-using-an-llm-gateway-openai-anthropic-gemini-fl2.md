---
title: "Building AI Agent With Multiple AI Model Providers Using an LLM Gateway"
url: "https://dev.to/crosspostr/building-ai-agent-with-multiple-ai-model-providers-using-an-llm-gateway-openai-anthropic-gemini-fl2"
author: "Bonnie"
category: "rust-go-java-agents"
---

# Building AI Agent With Multiple AI Model Providers Using an LLM Gateway
**Author:** Bonnie
**Published:** February 24, 2026

## Overview
Builds a multi-model AI agent using Bifrost LLM gateway with LangGraph. Each agent node uses a different provider: Claude for planning, GPT-4o for tool execution, Gemini Flash for summarization. Bifrost handles routing, failover, and load balancing with <15 microseconds overhead at 5,000 RPS.

## Key Concepts

```python
planner_llm = ChatOpenAI(model="openrouter/claude-3.7-sonnet", base_url=f"{BIFROST_URL}/v1", api_key="dummy")
executor_llm = ChatOpenAI(model="openai/gpt-4o", base_url=f"{BIFROST_URL}/v1", api_key="dummy")
summarizer_llm = ChatOpenAI(model="gemini/gemini-2.0-flash", base_url=f"{BIFROST_URL}/v1", api_key="dummy")

graph = StateGraph(AgentState)
graph.add_node("planner", planner_node)
graph.add_node("executor", executor_node)
graph.add_node("tools", tool_node)
graph.add_node("summarizer", summarizer_node)
graph.set_entry_point("planner")
graph.add_edge("planner", "executor")
graph.add_conditional_edges("executor", should_use_tools, {"tools": "tools", "summarizer": "summarizer"})
```
