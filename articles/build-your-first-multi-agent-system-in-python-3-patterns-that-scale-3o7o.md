---
title: "Build Your First Multi-Agent System in Python -- 3 Patterns That Scale"
url: "https://dev.to/klement_gunndu/build-your-first-multi-agent-system-in-python-3-patterns-that-scale-3o7o"
author: "klement Gunndu"
category: "multi-agent system Python"
---

# Build Your First Multi-Agent System in Python -- 3 Patterns That Scale

**Author:** klement Gunndu
**Published:** March 16, 2026

## Overview
This article presents three coordination patterns using LangGraph for building multi-agent systems in Python. It addresses the "single-agent ceiling" where performance degrades beyond approximately 15 tools, and shows how distributing work across specialized agents solves both tool selection accuracy and context consumption problems.

## Key Concepts

### Why One Agent Is Not Enough
Two primary limitations emerge with single-agent systems handling many tools:
1. Tool selection accuracy decreases as the number of options increases
2. Context consumption grows rapidly through tool descriptions, consuming 2,000-4,000 tokens before addressing user queries

Multi-agent systems solve both problems by limiting each agent to 2-5 tools while maintaining specialized focus.

### Prerequisites

```bash
pip install langgraph langchain-openai langgraph-supervisor
export OPENAI_API_KEY="your-key-here"
```

### Pattern 1: Subagents as Tools

Wrap specialist agents as callable tools for a coordinator agent, creating a hierarchical system where each specialist maintains independent tools and prompts.

```python
from langgraph.prebuilt import create_react_agent
from langchain_openai import ChatOpenAI
from langchain_core.tools import tool

model = ChatOpenAI(model="gpt-4o-mini")

# --- Define specialist tools ---

@tool
def add(a: float, b: float) -> float:
    """Add two numbers."""
    return a + b

@tool
def multiply(a: float, b: float) -> float:
    """Multiply two numbers."""
    return a * b

@tool
def web_search(query: str) -> str:
    """Search the web for information."""
    return f"Search results for: {query}"

# --- Create specialist agents ---

math_agent = create_react_agent(
    model=model,
    tools=[add, multiply],
    name="math_expert",
    prompt="You are a math expert. Use your tools to solve math problems. Always show your work.",
)

research_agent = create_react_agent(
    model=model,
    tools=[web_search],
    name="research_expert",
    prompt="You are a research expert. Use web search to find accurate information.",
)

# --- Wrap specialists as tools for the main agent ---

@tool
def ask_math_expert(question: str) -> str:
    """Ask the math expert. Use for ALL math questions."""
    response = math_agent.invoke(
        {"messages": [{"role": "user", "content": question}]}
    )
    return response["messages"][-1].content

@tool
def ask_research_expert(question: str) -> str:
    """Ask the research expert. Use for ALL factual questions."""
    response = research_agent.invoke(
        {"messages": [{"role": "user", "content": question}]}
    )
    return response["messages"][-1].content

# --- Create the main coordinating agent ---

coordinator = create_react_agent(
    model=model,
    tools=[ask_math_expert, ask_research_expert],
    prompt=(
        "You coordinate two experts. "
        "For math questions, use ask_math_expert. "
        "For factual questions, use ask_research_expert. "
        "Combine their answers when needed."
    ),
)

# --- Run it ---

result = coordinator.invoke({
    "messages": [{"role": "user", "content": "What is 42 * 17?"}]
})

print(result["messages"][-1].content)
```

### Pattern 2: Supervisor With Automatic Routing

The `langgraph-supervisor` package automatically generates handoff tools, eliminating manual wrapper function creation.

```python
from langgraph.prebuilt import create_react_agent
from langgraph_supervisor import create_supervisor
from langchain_openai import ChatOpenAI
from langchain_core.tools import tool

model = ChatOpenAI(model="gpt-4o-mini")

# --- Specialist tools ---

@tool
def add(a: float, b: float) -> float:
    """Add two numbers."""
    return a + b

@tool
def multiply(a: float, b: float) -> float:
    """Multiply two numbers."""
    return a * b

@tool
def web_search(query: str) -> str:
    """Search the web for information."""
    return f"Search results for: {query}"

# --- Create specialist agents ---

math_agent = create_react_agent(
    model=model,
    tools=[add, multiply],
    name="math_expert",
    prompt="You are a math expert. Always use one tool at a time.",
)

research_agent = create_react_agent(
    model=model,
    tools=[web_search],
    name="research_expert",
    prompt="You are a researcher with web search access. Do not do any math.",
)

# --- Create supervisor ---

workflow = create_supervisor(
    agents=[research_agent, math_agent],
    model=model,
    prompt=(
        "You are a team supervisor managing a research expert and a math expert. "
        "For current events, use research_expert. "
        "For math problems, use math_expert."
    ),
)

app = workflow.compile()

# --- Run it ---

result = app.invoke({
    "messages": [{"role": "user", "content": "What is 42 * 17?"}]
})

for message in result["messages"]:
    if hasattr(message, "content") and message.content:
        print(f"{message.type}: {message.content}")
```

### Pattern 3: Handoffs (State-Driven Agent Switching)

Enable agents to transfer control dynamically based on task analysis, preserving conversation history during transitions.

```python
from langgraph.prebuilt import create_react_agent
from langgraph_supervisor import create_supervisor, create_handoff_tool
from langchain_openai import ChatOpenAI
from langchain_core.tools import tool

model = ChatOpenAI(model="gpt-4o-mini")

# --- Domain tools ---

@tool
def lookup_invoice(customer_id: str) -> str:
    """Look up a customer's invoice."""
    return f"Invoice for {customer_id}: $99.00 due 2026-04-01"

@tool
def check_system_status(service: str) -> str:
    """Check the status of a service."""
    return f"{service} status: operational, 99.9% uptime last 30 days"

# --- Create specialist agents with handoff tools ---

billing_agent = create_react_agent(
    model=model,
    tools=[
        lookup_invoice,
        create_handoff_tool(
            agent_name="support_agent",
            description="Transfer to technical support for non-billing issues",
        ),
    ],
    name="billing_agent",
    prompt=(
        "You handle billing questions only. "
        "If the question is about technical issues, transfer to support_agent."
    ),
)

support_agent = create_react_agent(
    model=model,
    tools=[
        check_system_status,
        create_handoff_tool(
            agent_name="billing_agent",
            description="Transfer to billing for payment-related issues",
        ),
    ],
    name="support_agent",
    prompt=(
        "You handle technical support only. "
        "If the question is about billing, transfer to billing_agent."
    ),
)

# --- Wire them with a supervisor for routing ---

workflow = create_supervisor(
    agents=[billing_agent, support_agent],
    model=model,
    prompt=(
        "You are a customer service supervisor. "
        "Route billing questions to billing_agent. "
        "Route technical questions to support_agent."
    ),
)

app = workflow.compile()

# --- Run with recursion limit to prevent infinite handoff loops ---

result = app.invoke(
    {
        "messages": [{"role": "user", "content": "My payment failed and now I can't log in"}]
    },
    config={"recursion_limit": 15},
)

for message in result["messages"]:
    if hasattr(message, "content") and message.content:
        print(f"{message.type}: {message.content}")
```

## Decision Matrix

| Situation | Pattern | Rationale |
|-----------|---------|-----------|
| 2-5 specialists with clear routing | Subagents as Tools | Maximum control; LangGraph team recommendation |
| Quick prototyping; non-overlapping agents | Supervisor | Minimal boilerplate overhead |
| Sequential workflows (A to B to C) | Handoffs | Natural flow without central bottleneck |
| Complex routing with parallel execution | Custom LangGraph workflow | Full architectural control |

## Three Critical Mistakes to Avoid

1. **Premature proliferation:** Start with 2 agents. Validate coordination patterns before adding more.
2. **Overlapping tool ownership:** Duplicate tools across agents lead to unpredictable routing. Each agent should have exclusive ownership of its tool set.
3. **Missing recursion limits:** Uncontrolled handoff loops create expensive infinite loops. Always configure: `config={"recursion_limit": 15}`
