---
title: "A Beginner's Guide to Getting Started in Agent State in LangGraph"
url: "https://dev.to/aiengineering/a-beginners-guide-to-getting-started-in-agent-state-in-langgraph-3bkj"
author: "Damilola Oyedunmade"
category: "agent-state-machine"
---

# A Beginner's Guide to Getting Started in Agent State in LangGraph

**Author:** Damilola Oyedunmade
**Published:** October 20, 2025

## Overview
Explains agent state in LangGraph as the agent's short-term memory that tracks conversation history, completed actions, and next steps, with a step-by-step implementation example.

## Key Concepts

### What is State in LangGraph?
The data an agent keeps track of as it runs: current input, tools used, what it has said, and pending tasks. LangGraph treats state as a structured object defined as a Python class or dictionary.

### Core Components
1. **State Schema:** Blueprint defining data types (TypedDict, dataclass, or Pydantic)
2. **State Reducer:** How new data combines with existing state (append vs replace)
3. **Nodes:** Individual workflow steps that accept and return state
4. **Edges:** Connections between nodes (linear or conditional)
5. **Graph Execution:** Compiled workflow passing state through nodes
6. **Persistence:** Save/reload state for long-running agents
7. **Tools:** Integration allowing tools to read/update state

### Step-by-Step Implementation

**Installation:**
```python
pip install langgraph langchain openai
```

**Define State:**
```python
from typing import TypedDict, List

class ChatState(TypedDict):
    messages: List[str]
```

**Create Nodes:**
```python
def user_input_node(state: ChatState) -> ChatState:
    user_message = input("You: ")
    state["messages"].append(f"User: {user_message}")
    return state

def agent_response_node(state: ChatState) -> ChatState:
    last_message = state["messages"][-1]
    reply = f"I see, you said: '{last_message.split(': ')[1]}'"
    state["messages"].append(f"Agent: {reply}")
    return state
```

**Build the Graph:**
```python
from langgraph.graph import StateGraph

graph = StateGraph(ChatState)
graph.add_node("input", user_input_node)
graph.add_node("respond", agent_response_node)

graph.add_edge("input", "respond")
graph.set_entry_point("input")
```

**Execute:**
```python
app = graph.compile()
state = {"messages": []}

for _ in range(2):
    state = app(state)
```

**Inspect State:**
```python
print(state)
# Output: {'messages': ['User: Hello', "Agent: I see, you said: 'Hello'", ...]}
```

### Real-World Applications
- Chatbots with conversation memory
- Research assistants aggregating search results
- Task planners tracking progress
- Multi-agent collaboration via shared state
- Support systems maintaining context for escalation
