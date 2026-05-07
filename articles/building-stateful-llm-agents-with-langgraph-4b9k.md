---
title: "Building Stateful LLM Agents with LangGraph"
url: "https://dev.to/cypriantinasheaarons/building-stateful-llm-agents-with-langgraph-4b9k"
author: "CyprianTinasheAarons"
category: "langgraph-agents"
---

# Building Stateful LLM Agents with LangGraph

**Author:** CyprianTinasheAarons
**Published:** October 4, 2024 (Edited December 16, 2024)
**Tags:** #nlp #langchain #langgraph #llm

---

## Overview

LangGraph enables developers to construct stateful, multi-actor applications using large language models by modeling agent workflows as graphs. This guide demonstrates building a simple agent using OpenAI and TavilySearch as core components.

---

## Getting Started

### Setup Instructions

```bash
git clone https://github.com/CyprianTinasheAarons/basic-bot-langgraph
cd basic-bot
python -m venv .venv
```

**Activate virtual environment:**
- Windows: `.venv\Scripts\activate`
- macOS/Linux: `source .venv/bin/activate`

```bash
pip install -r requirements.txt
```

Configure `.env` file with required API keys (OpenAI and TavilySearch).

---

## Key Libraries

```python
import os
from typing import Literal
from langchain_core.messages import HumanMessage
from langchain_openai import ChatOpenAI
from langgraph.graph import END, START, StateGraph, MessagesState
from langgraph.prebuilt import ToolNode
from dotenv import load_dotenv
from langchain_community.tools.tavily_search import TavilySearchResults
from loguru import logger
```

---

## Configuration

### Logging Setup
```python
logger.add("bot.log", rotation="10 MB")
```

### Environment Variables
```python
load_dotenv()
logger.info("Environment variables loaded")
```

---

## Tools and Nodes

### Web Search Tool
```python
web_search = TavilySearchResults(max_results=2)

def search(query: str):
    """Call to surf the web."""
    logger.debug(f"Performing web search for query: {query}")
    return web_search.invoke({"query": query})

tools = [search]
tool_node = ToolNode(tools)
logger.info("Tool node created")
```

---

## LLM Initialization

```python
llm = ChatOpenAI(
    model="gpt-4o",
    temperature=0,
    api_key=os.getenv("OPENAI_API_KEY")
)
logger.info("LLM model initialized")

llm_with_tools = llm.bind_tools(tools)
```

---

## Workflow Logic

### Routing Function
```python
def should_continue(state: MessagesState) -> Literal["tools", END]:
    messages = state['messages']
    last_message = messages[-1]
    if last_message.tool_calls:
        logger.debug("Routing to tools node")
        return "tools"
    logger.debug("Ending conversation")
    return END
```

### Model Invocation
```python
def call_model(state: MessagesState):
    messages = state['messages']
    logger.debug(f"Calling LLM with {len(messages)} messages")
    response = llm_with_tools.invoke(messages)
    return {"messages": [response]}
```

---

## Building the Graph

```python
graph = StateGraph(MessagesState)
logger.info("StateGraph initialized")

graph.add_node("weatherbot", call_model)
graph.add_node("tools", tool_node)
logger.info("Nodes added to the graph")

graph.add_edge(START, "weatherbot")
graph.add_conditional_edges("weatherbot", should_continue)
graph.add_edge("tools", 'weatherbot')
logger.info("Graph edges configured")

app = graph.compile()
logger.info("Graph compiled successfully")
```

---

## Graph Visualization

```python
try:
    graph_png = app.get_graph().draw_mermaid_png()
    with open("graph.png", "wb") as f:
        f.write(graph_png)
    logger.info("Graph visualization saved as graph.png")
except Exception as e:
    logger.error(f"Failed to save graph visualization: {e}")
```

---

## Running the Agent

```python
logger.info("Invoking the app with a sample query")
final_state = app.invoke(
    {"messages": [HumanMessage(content="what is the weather in sf")]},
    config={"configurable": {"thread_id": 42}}
)
```

Execute the bot:
```bash
python bot.py
```

---

## Key Takeaways

- LangGraph models agent workflows as graphs for flexible, interactive implementations
- Tools are bound to LLMs to enable external function calls
- Conditional edges route execution based on agent output
- State management tracks conversation history across nodes
- The compiled graph handles the complete execution flow automatically

---

## Resources

- [LangGraph Documentation](https://langchain-ai.github.io/langgraph/)
- [LangChain Python Documentation](https://python.langchain.com/docs/introduction/)
