---
title: "Building Multi-Agent Systems with LangGraph-Supervisor"
url: "https://dev.to/sreeni5018/building-multi-agent-systems-with-langgraph-supervisor-138i"
author: "Seenivasa Ramadurai"
category: "supervisor-agent-pattern"
---

# Building Multi-Agent Systems with LangGraph-Supervisor

**Author:** Seenivasa Ramadurai
**Published:** March 9, 2025

## Overview

Introduces LangGraph-Supervisor, a Python library for creating hierarchical multi-agent systems. Demonstrates a practical implementation with three specialized agents (resume parser, Google search, Q&A) coordinated by a supervisor.

## Key Concepts

### Architecture

A central supervisor agent controls all communication flow and task delegation, making intelligent decisions about which agent to invoke based on the user's request.

### Implementation

```python
from langgraph.prebuilt import create_react_agent
from langgraph_supervisor import create_supervisor
from langchain_openai import AzureChatOpenAI
from langgraph.checkpoint.memory import InMemorySaver

# Initialize LLM
llm = AzureChatOpenAI(
    azure_deployment="gpt-4o",
    temperature=0,
)

# Create specialized agents
resume_agent = create_react_agent(
    model=llm,
    tools=[resume_parser_tool],
    name="resume_parser",
    prompt="You are a resume parsing specialist. Extract key information from resumes."
)

search_agent = create_react_agent(
    model=llm,
    tools=[google_search_tool],
    name="google_search",
    prompt="You are a web search specialist. Find relevant information online."
)

qa_agent = create_react_agent(
    model=llm,
    tools=[],
    name="qa_agent",
    prompt="You are a general Q&A assistant. Answer questions directly."
)

# Create supervisor
checkpointer = InMemorySaver()

supervisor = create_supervisor(
    agents=[resume_agent, search_agent, qa_agent],
    model=llm,
    prompt="Route requests: resume-related to resume_parser, search queries to google_search, general questions to qa_agent."
)

# Compile with memory
app = supervisor.compile(checkpointer=checkpointer)

# Run with thread for conversation memory
config = {"configurable": {"thread_id": "session-1"}}
result = app.invoke(
    {"messages": [("user", "Parse this resume and find the candidate's LinkedIn")]},
    config=config
)
```

### Features

- Supervisor agent creation for orchestrating specialized agents
- Tool-based agent handoff mechanism
- Flexible message history management
- Integration with LangGraph's streaming and memory capabilities
- InMemorySaver checkpointer for conversation continuity

### Testing Results

The system successfully maintains conversation history, routes Google searches appropriately, and parses resume documents correctly across sessions.
