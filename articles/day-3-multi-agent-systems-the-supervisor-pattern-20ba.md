---
title: "Day 3: Multi-Agent Systems - The Supervisor Pattern"
url: "https://dev.to/ravidasari/day-3-multi-agent-systems-the-supervisor-pattern-20ba"
author: "Ravi"
category: "supervisor-agent-pattern"
---

# Day 3: Multi-Agent Systems - The Supervisor Pattern

**Author:** Ravi
**Published:** December 4, 2025

## Overview

Part of a 4-day series on Agentic AI with LangChain/LangGraph. Introduces the supervisor pattern where specialized agents (Researcher and Writer) share a common state and are coordinated by a supervisor LLM.

## Key Concepts

### Specialized Agent Creation

```javascript
const createAgent = (model, systemPrompt, tools = []) => {
  const modelWithTools = model.bindTools(tools);
  return async (state) => {
    const messages = [
      new SystemMessage(systemPrompt),
      ...state.messages,
    ];
    const response = await modelWithTools.invoke(messages);
    return { messages: [response] };
  };
};
```

### Workflow Graph

```javascript
const { StateGraph, MessagesAnnotation } = require("@langchain/langgraph");

const workflow = new StateGraph(MessagesAnnotation)
  .addNode("researcher", researcherNode)
  .addNode("tools", toolNode)
  .addNode("writer", writerNode)
  .addEdge("__start__", "researcher")
  .addConditionalEdges("researcher", (state) => {
    const last = state.messages[state.messages.length - 1];
    return last.tool_calls?.length ? "tools" : "writer";
  })
  .addEdge("tools", "researcher")
  .addEdge("writer", "__end__");

const app = workflow.compile();
```

### Researcher Agent

```javascript
const researcherNode = createAgent(
  model,
  "You are a researcher. Use the search tool to find information about the topic.",
  [searchTool]
);
```

### Writer Agent

```javascript
const writerNode = createAgent(
  model,
  "You are a writer. Take the research provided and write a compelling article."
);
```

### Shared State

The magic happens in `MessagesAnnotation` -- it enables shared state where the Researcher's findings become immediately available to the Writer, supporting separation of concerns.

Full code: https://github.com/RaviDasari/learn-ai-langgraph/blob/main/day3-multi-agent/team.js
