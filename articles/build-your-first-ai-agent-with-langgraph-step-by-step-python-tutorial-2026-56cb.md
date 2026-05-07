---
title: "Build Your First AI Agent with LangGraph — Step-by-Step Python Tutorial (2026)"
url: https://dev.to/jangwook_kim_e31e7291ad98/build-your-first-ai-agent-with-langgraph-step-by-step-python-tutorial-2026-56cb
author: Jangwook Kim
category: ai-agents-python
---

# Build Your First AI Agent with LangGraph — Step-by-Step Python Tutorial (2026)

**Author:** Jangwook Kim
**Published:** April 4, 2026
**Original Source:** effloow.com

---

## Overview

This tutorial demonstrates how to construct a functional research agent using LangGraph, a Python framework for building production-grade AI agents. Rather than simple chatbots, agents autonomously decide actions, utilize tools, evaluate outcomes, and iterate until objectives are met.

## Key Concepts

### State Management
State represents the agent's working memory—a Python dictionary flowing through the entire graph:

```python
from typing import TypedDict, Annotated
from langgraph.graph.message import add_messages

class ResearchState(TypedDict):
    """The agent's working memory."""
    messages: Annotated[list, add_messages]
    research_topic: str
    search_queries: list[str]
    sources: list[dict]
    analysis: str
    final_report: str
    iteration: int
    max_iterations: int
```

### Nodes and Edges
- **Nodes:** Functions performing specific tasks (search, analyze, write)
- **Edges:** Connections defining workflow transitions
- **Conditional edges:** Agent decision points determining next steps

## Implementation Steps

### Installation

```bash
pip install langgraph==0.3.34 \
    langchain-openai==0.3.12 \
    langchain-community==0.3.19 \
    tavily-python==0.5.0 \
    python-dotenv==1.1.0
```

### Core Node Functions

**Generate Search Queries:**
```python
def generate_queries(state: ResearchState) -> dict:
    """Turn the research topic into specific search queries."""
    topic = state["research_topic"]
    response = llm.invoke([
        SystemMessage(content=(
            "Generate 3 specific, diverse search queries to research "
            "the given topic. Return only queries, one per line."
        )),
        HumanMessage(content=f"Research topic: {topic}"),
    ])
    new_queries = [q.strip() for q in response.content.strip().split("\n") if q.strip()]
    return {"search_queries": state.get("search_queries", []) + new_queries}
```

**Search Web:**
```python
def search_web(state: ResearchState) -> dict:
    """Execute search queries and collect results."""
    queries = state.get("search_queries", [])[-3:]
    all_results = state.get("sources", [])

    for query in queries:
        try:
            response = tavily.search(query=query, max_results=3)
            for result in response.get("results", []):
                if not any(s["url"] == result["url"] for s in all_results):
                    all_results.append({
                        "title": result.get("title", ""),
                        "url": result.get("url", ""),
                        "content": result.get("content", ""),
                    })
        except Exception as e:
            print(f"Search failed: {e}")

    return {"sources": all_results}
```

**Analyze Results:**
```python
def analyze_results(state: ResearchState) -> dict:
    """Analyze search results and assess information sufficiency."""
    sources = state.get("sources", [])

    if not sources:
        return {
            "analysis": "No results found. Try different queries.",
            "iteration": state.get("iteration", 0) + 1,
        }

    source_text = "\n".join([
        f"[{i}] {s['title']}\nURL: {s['url']}\n{s['content']}"
        for i, s in enumerate(sources, 1)
    ])

    response = llm.invoke([
        SystemMessage(content=(
            "Analyze results. Provide: 1) Key findings, 2) Remaining gaps, "
            "3) Confidence level (low/medium/high)"
        )),
        HumanMessage(content=f"Topic: {state['research_topic']}\n{source_text}"),
    ])

    return {
        "analysis": response.content,
        "iteration": state.get("iteration", 0) + 1,
    }
```

### Graph Construction with Conditional Routing

```python
from langgraph.graph import StateGraph, START, END
from langgraph.checkpoint.memory import MemorySaver

def should_continue_research(state: ResearchState) -> str:
    """Determine whether to continue researching or write report."""
    if state.get("iteration", 0) >= state.get("max_iterations", 3):
        return "write_report"

    analysis_lower = state.get("analysis", "").lower()
    if any(phrase in analysis_lower for phrase in ["low confidence", "significant gaps"]):
        return "generate_queries"

    return "write_report"

workflow = StateGraph(ResearchState)

# Add nodes
workflow.add_node("generate_queries", generate_queries)
workflow.add_node("search_web", search_web)
workflow.add_node("analyze_results", analyze_results)
workflow.add_node("write_report", write_report)

# Define flow
workflow.add_edge(START, "generate_queries")
workflow.add_edge("generate_queries", "search_web")
workflow.add_edge("search_web", "analyze_results")

# Conditional routing: agent decides next step
workflow.add_conditional_edges(
    "analyze_results",
    should_continue_research,
    {
        "generate_queries": "generate_queries",
        "write_report": "write_report",
    },
)

workflow.add_edge("write_report", END)

# Add memory for state persistence
memory = MemorySaver()
agent = workflow.compile(checkpointer=memory)
```

### Execution with Memory

```python
config = {"configurable": {"thread_id": "research-session-1"}}

initial_state = {
    "research_topic": "Your research question here",
    "messages": [],
    "search_queries": [],
    "sources": [],
    "analysis": "",
    "final_report": "",
    "iteration": 0,
    "max_iterations": 3,
}

for event in agent.stream(initial_state, config=config):
    for node_name, output in event.items():
        print(f"Node: {node_name}")
```

## Framework Comparison

| Feature | LangGraph | CrewAI | AutoGen |
|---------|-----------|--------|---------|
| Architecture | Graph-based | Role-based teams | Conversational |
| Control | Full (conditional edges, cycles) | Limited | Moderate |
| Durable execution | Built-in checkpointing | No | No |
| Production readiness | High (v1.0) | Medium | Low (maintenance) |

## Key Takeaways

1. "LangGraph models agents as graphs"—nodes represent functions, edges represent transitions, and conditional edges enable agent decision-making
2. State schema design determines agent capabilities; invest time in this foundation
3. All looping agents require safety limits (`max_iterations`) to prevent infinite execution
4. Start with simple node structures; add complexity incrementally
5. LangGraph reached v1.0 in late 2025 and is production-ready with major enterprise adoption

## Additional Resources

- Deployment via LangServe: FastAPI wrapper for REST APIs with streaming
- Multi-agent systems: Supervisor patterns and specialist delegation
- Human-in-the-loop: Approval gates using `interrupt()` function
- Local model support: Compatible with Ollama and other local LLMs
