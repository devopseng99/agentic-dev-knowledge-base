---
title: "Two Basic Streaming Response Techniques of LangGraph"
url: "https://dev.to/jamesli/two-basic-streaming-response-techniques-of-langgraph-ioo"
author: "James Lee"
category: "llm-streaming"
---

# Two Basic Streaming Response Techniques of LangGraph

**Author:** James Lee
**Published:** November 14, 2024

## Overview
LangGraph's streaming outputs data state of a node each time, unlike traditional LLMs that output word-by-word. Two primary streaming modes: Values and Updates.

## Code Examples

### Values Mode
Returns complete state values after each node executes:

```python
inputs = {"messages": [("human", "What are the top 3 results of the 2024 Beijing Half Marathon?")]}
for chunk in agent.stream(inputs, stream_mode="values"):
    print(chunk["messages"][-1].pretty_print())
```

### Updates Mode
Returns only state modifications incrementally:

```python
for chunk in agent.stream(inputs, stream_mode="updates"):
    print(chunk)
```

## Key Distinction
LangGraph's compiled graph operates as a Runnable component. Unlike conventional LLMs, it outputs the data state of a node each time, offering more granular control and richer data representation.

## Limitation
Despite advances, waiting time is still long for nodes involving LLMs because nodes should maintain inherent streaming characteristics rather than returning complete output afterward.
