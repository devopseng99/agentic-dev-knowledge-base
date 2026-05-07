---
title: "LangGraph Tutorial: Build a Working ReAct Agent with the v1.0 API"
url: "https://dev.to/agentsindex/langgraph-tutorial-build-a-working-react-agent-with-the-v10-api-3bc1"
author: "Agents Index"
category: "langgraph-agents"
---

# LangGraph Tutorial: Build a Working ReAct Agent with the v1.0 API

**Author:** Agents Index
**Published:** April 20, 2026
**Originally:** agentsindex.ai

---

## Overview

This tutorial addresses a critical gap in LangGraph documentation: most online tutorials use deprecated v0.1 API patterns. "Nine of them use `set_entry_point()`, a function deprecated two years ago." This guide uses stable v1.0 patterns exclusively with tested, working code.

---

## Key Concepts

### What is LangGraph?

LangGraph is an open-source Python library for building stateful AI agent workflows as directed graphs. It models agent execution through **nodes** (computation steps), **edges** (control flow), and shared **State** objects. The framework reached stable v1.0 in October 2025.

### Core Building Blocks

- **Nodes:** Python functions performing computation, LLM calls, or tool invocation
- **Edges:** Connection paths between nodes (unconditional or conditional routing)
- **State:** Shared TypedDict or Pydantic model passed between all nodes
- **Reducers:** Functions defining how state updates merge (e.g., `add_messages`)

---

## Installation & Setup

```bash
pip install langgraph langgraph-prebuilt langchain-openai langchain-core python-dotenv
```

Create `.env` file:
```
OPENAI_API_KEY=your-key-here
```

Load in script:
```python
from dotenv import load_dotenv
load_dotenv()
```

---

## Essential v1.0 Imports

```python
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import MessageState
from langgraph.prebuilt import create_react_agent
```

---

## Deprecated v0.1 vs. Current v1.0 Patterns

| Feature | v0.1 (Deprecated) | v1.0 (Current) | Reason |
|---------|-------------------|----------------|--------|
| Entry point | `set_entry_point('node')` | `add_edge(START, 'node')` | START/END sentinels make topology explicit |
| Finish point | `set_finish_point('node')` | `add_edge('node', END)` | Unified edge API |
| Message state | Custom TypedDict with raw list | `MessageState` | Prebuilt state with `add_messages` reducer |
| ReAct pattern | Hand-rolled (20-40 lines) | `create_react_agent` | Prebuilt abstraction |
| Tool execution | Custom per-tool functions | `ToolNode` | Consolidated boilerplate |

---

## Building Your First Agent

### Step 1: Define Tools

```python
from langchain_core.tools import tool

@tool
def multiply(a: float, b: float) -> float:
    """Multiply two numbers together."""
    return a * b

@tool
def add(a: float, b: float) -> float:
    """Add two numbers together."""
    return a + b

tools = [multiply, add]
```

### Step 2: Create Agent with `create_react_agent`

```python
from langchain_openai import ChatOpenAI
from langgraph.prebuilt import create_react_agent

model = ChatOpenAI(model="gpt-4o-mini")
agent = create_react_agent(model, tools)
```

### Step 3: Execute Agent

```python
from langchain_core.messages import HumanMessage

result = agent.invoke({
    "messages": [HumanMessage(content="What is 47 multiplied by 83?")]
})

print(result["messages"][-1].content)
# Output: 47 multiplied by 83 is 3,901.
```

### Step 4: Equivalent Manual StateGraph (for learning)

```python
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import MessageState
from langgraph.prebuilt import ToolNode
from langchain_openai import ChatOpenAI

model_with_tools = ChatOpenAI(model="gpt-4o-mini").bind_tools(tools)
tool_node = ToolNode(tools)

def call_model(state: MessageState) -> dict:
    response = model_with_tools.invoke(state["messages"])
    return {"messages": [response]}

def should_continue(state: MessageState) -> str:
    last_msg = state["messages"][-1]
    if hasattr(last_msg, "tool_calls") and last_msg.tool_calls:
        return "tools"
    return "__end__"

builder = StateGraph(MessageState)
builder.add_node("agent", call_model)
builder.add_node("tools", tool_node)
builder.add_edge(START, "agent")
builder.add_conditional_edges("agent", should_continue, {
    "tools": "tools",
    "__end__": END
})
builder.add_edge("tools", "agent")
graph = builder.compile()
```

---

## Understanding State & Reducers

### MessageState with add_messages

The `add_messages` reducer appends new messages rather than replacing the list:

```python
from typing import Annotated
from langgraph.graph.message import add_messages
from typing_extensions import TypedDict

class MyState(TypedDict):
    messages: Annotated[list, add_messages]
```

`MessageState` is the prebuilt equivalent -- no manual definition needed.

### Custom State Example

```python
class ResearchState(TypedDict):
    messages: Annotated[list, add_messages]
    visited_urls: list[str]
    total_tokens_used: int
```

---

## Nodes & Edges

### Simple Node Definition

```python
def call_llm(state: MessageState) -> dict:
    response = model.invoke(state["messages"])
    return {"messages": [response]}
```

Nodes return only changed fields; LangGraph merges updates into state.

### Unconditional & Conditional Routing

```python
builder = StateGraph(MessageState)
builder.add_node("llm", call_llm)
builder.add_edge(START, "llm")
builder.add_edge("llm", END)

# Conditional routing
def should_continue(state: MessageState) -> str:
    last_message = state["messages"][-1]
    if hasattr(last_message, "tool_calls") and last_message.tool_calls:
        return "tools"
    return "__end__"

builder.add_conditional_edges("llm", should_continue, {
    "tools": "tool_node",
    "__end__": END
})

graph = builder.compile()
```

### Visualize Your Graph

```python
print(graph.get_graph().draw_mermaid())
```

Output:
```
graph TD;
    __start__ --> llm;
    llm --> __end__;
```

---

## Memory & Checkpointing

### MemorySaver (Development Only)

```python
from langgraph.checkpoint.memory import MemorySaver
from langchain_core.messages import HumanMessage

checkpointer = MemorySaver()
agent = create_react_agent(model, tools, checkpointer=checkpointer)

config = {"configurable": {"thread_id": "user-session-001"}}

result1 = agent.invoke(
    {"messages": [HumanMessage(content="My name is Alex.")]},
    config=config
)

result2 = agent.invoke(
    {"messages": [HumanMessage(content="What is my name?")]},
    config=config
)

print(result2["messages"][-1].content)
# Output: Your name is Alex.
```

**Production Warning:** MemorySaver stores state in-process only and loses data on restart.

### SqliteSaver (Local Persistence)

```python
from langgraph.checkpoint.sqlite import SqliteSaver

checkpointer = SqliteSaver.from_conn_string("agent_memory.db")
agent = create_react_agent(model, tools, checkpointer=checkpointer)
```

For cloud deployments, use `AsyncPostgresSaver` with managed Postgres.

---

## Graph Visualization

```python
# ASCII output
mermaid_str = graph.get_graph().draw_mermaid()
print(mermaid_str)

# Jupyter PNG output
from IPython.display import Image, display
display(Image(graph.get_graph().draw_mermaid_png()))
```

---

## StateGraph vs. create_react_agent

| Aspect | StateGraph | create_react_agent |
|--------|------------|-------------------|
| **Best for** | Custom flows, multi-agent systems | Standard tool-calling agents |
| **Lines of code** | 30-60+ | 5-10 |
| **Custom routing** | Full control | ReAct loop only |
| **Learning curve** | Steeper | Gentler |

**Rule of thumb:** Start with `create_react_agent` for standard agents; migrate to manual `StateGraph` when needing parallel execution, supervisors, or custom retry logic.

---

## Key Takeaways

1. "Use `from langgraph.graph import StateGraph, START, END`, not the deprecated v0.1 patterns"
2. Understand `add_messages` reducer behavior for conversation history
3. Never deploy `MemorySaver` to production; use `SqliteSaver` locally or `AsyncPostgresSaver` for cloud
4. Visualize graphs before debugging with `draw_mermaid()`
5. LangGraph works with any model having LangChain compatibility (Claude, Gemini, Groq, etc.)

---

## Additional Resources

- AgentsIndex.ai comparison guides on multi-agent systems and agent framework selection
- LangSmith for production trace visualization
- LangGraph Platform for hosted deployments with automatic scaling
- LangChain State of Agent Engineering Survey (2025): 57.3% of AI engineers have agents in production
