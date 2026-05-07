---
title: "Building a simple RAG agent with LlamaIndex"
url: "https://dev.to/vivekalhat/building-a-simple-rag-agent-with-llamaindex-4c6k"
author: "Vivek Alhat"
category: "llamaindex-agent"
---

# Building a simple RAG agent with LlamaIndex

**Author:** Vivek Alhat
**Published:** September 30, 2024

## Overview

Explains how to construct a retrieval-augmented generation (RAG) agent using LlamaIndex, enabling the creation of agents that can dynamically retrieve and reason over specific data.

## Key Concepts

### Installing Dependencies

```bash
pip install llama-index python-dotenv
```

### Setting Up LLM and Loading Documents

```python
from llama_index.core import SimpleDirectoryReader, VectorStoreIndex, Settings
from llama_index.llms.openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

Settings.llm = OpenAI(model="gpt-4o-mini")

documents = SimpleDirectoryReader("./data").load_data()

index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()
```

### Creating Custom Functions

```python
def multiply(a: float, b: float) -> float:
    """Multiply two numbers and returns the product"""
    return a * b

def add(a: float, b: float) -> float:
    """Add two numbers and returns the sum"""
    return a + b
```

### Creating Tools for the Agent

```python
from llama_index.core.tools import FunctionTool, QueryEngineTool

add_tool = FunctionTool.from_defaults(fn=add)
multiply_tool = FunctionTool.from_defaults(fn=multiply)

space_facts_tool = QueryEngineTool.from_defaults(
    query_engine,
    name="space_facts_tool",
    description="A RAG engine with information about fun space facts."
)
```

### Creating the ReAct Agent

```python
from llama_index.core.agent import ReActAgent

agent = ReActAgent.from_tools(
    [multiply_tool, add_tool, space_facts_tool], verbose=True
)
```

### Running the Agent

```python
while True:
    query = input("Query: ")

    if query == "/bye":
        exit()

    response = agent.chat(query)
    print(response)
    print("-" * 10)
```

## How It Works

The agent uses the ReAct framework to reason and act by selecting appropriate tools based on user queries -- either performing calculations using math tools or retrieving information from ingested documents through the vector store.
