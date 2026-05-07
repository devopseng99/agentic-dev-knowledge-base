---
title: "Learn How to Build AI Agents & Chatbots with LangGraph!"
url: "https://dev.to/pavanbelagatti/learn-how-to-build-ai-agents-chatbots-with-langgraph-20o6"
author: "Pavan Belagatti"
category: "building chatbot agent"
---

# Learn How to Build AI Agents & Chatbots with LangGraph!

**Author:** Pavan Belagatti
**Published:** September 25, 2024

## Overview

Step-by-step tutorial for building AI agents and chatbots using LangGraph, an open-source framework for creating and managing AI agents and multi-agent applications through nodes, states, and edges.

## Key Concepts

### Environment Setup

```bash
!pip install langgraph langsmith
!pip install langchain langchain_groq langchain_community
```

```python
import os
os.environ['LANGCHAIN_TRACING_V2'] = 'true'
os.environ['LANGCHAIN_API_KEY'] = 'Add your LangChain API Key'
os.environ['LANGCHAIN_PROJECT'] = 'LiveLanggraph'
```

### LLM Configuration

```python
from langchain_groq import ChatGroq

groq_api_key = "Add your Groq API Key"
llm = ChatGroq(groq_api_key=groq_api_key, model_name='Gemma2-9b-It')
```

### Graph State and Chatbot Node

```python
from typing import Annotated
from typing_extensions import TypedDict
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import add_messages

class State(TypedDict):
    messages: Annotated[list, add_messages]

graph_builder = StateGraph(State)

def chatbot(state: State):
    return {"messages": llm.invoke(state['messages'])}

graph_builder.add_node("chatbot", chatbot)
```

### Building and Compiling the Graph

```python
graph_builder.add_edge(START, "chatbot")
graph_builder.add_edge("chatbot", END)

graph = graph_builder.compile()
```

### Visualization

```python
from IPython.display import Image, display

try:
    display(Image(graph.get_graph().draw_mermaid_png()))
except Exception:
    pass
```

### Interactive Chat Loop

```python
while True:
    user_input = input("User: ")
    if user_input.lower() in ["quit", "q"]:
        print("Good Bye")
        break
    for event in graph.stream({'messages': ("user", user_input)}):
        print(event.values())
        for value in event.values():
            print(value['messages'])
            print("Assistant:", value["messages"].content)
```

GitHub repository: https://github.com/pavanbelagatti/LangGraph-Chatbot-Tutorial
