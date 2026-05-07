---
title: "Semantic Caching in Agentic AI: Determining Cache Eligibility and Invalidation"
url: "https://dev.to/redis/semantic-caching-in-agentic-ai-determining-cache-eligibility-and-invalidation-5d7g"
author: "Ashwin Hariharan"
category: "ai-agent-caching-strategy"
---

# Semantic Caching in Agentic AI: Determining Cache Eligibility and Invalidation

**Author:** Ashwin Hariharan (Redis)
**Published:** April 14, 2026

## Overview

Addresses what to cache and for how long in AI agent systems where responses depend on user state and previous actions. Presents four caching decision approaches with full LangGraph integration.

## Key Concepts

### Four Caching Decision Approaches

#### 1. String-Based Pattern Matching

```python
def determine_cache_ttl_by_string(query: str) -> int:
    product_info_keywords = ['what is', 'tell me about', 'specs', 'features']
    if any(keyword in query for keyword in product_info_keywords):
        return 24 * 60 * 60  # 24 hours

    personal_keywords = ['my cart', 'add to cart', 'my order', 'checkout']
    if any(keyword in query for keyword in personal_keywords):
        return 0  # Don't cache

    return 6 * 60 * 60  # Default: 6 hours
```

#### 2. LLM-Based Decision Making

```python
async def determine_cache_ttl_by_llm(query: str) -> int:
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    prompt = f"""Analyze this user query and determine the appropriate cache TTL.
Query: "{query}"
Categories:
- PERSONAL: User-specific operations. Return: 0
- PRODUCT_INFO: Product details. Return: 86400
- SEARCH: Product searches. Return: 7200
Return ONLY the TTL number (in seconds)."""
    response = await llm.ainvoke(prompt)
    return ttl
```

#### 3. Tool-Based Decision Making

```python
def determine_tool_based_cache_ttl(tools_used: List[str]) -> int:
    personal_tools = ['add_to_cart', 'view_cart', 'checkout']
    product_info_tools = ['get_product_details', 'get_product_specs']

    if any(tool in tools_used for tool in personal_tools):
        return 0  # Don't cache
    if any(tool in tools_used for tool in product_info_tools):
        return 24 * 60 * 60  # 24 hours
    return 6 * 60 * 60  # Default
```

#### 4. Semantic Routing with RedisVL

```python
from redisvl.extensions.router import SemanticRouter, Route
from redisvl.utils.vectorize import HFTextVectorizer

personal_operations = Route(
    name="personal",
    references=["show my cart", "add to cart", "view my orders"],
    metadata={"ttl": 0}
)

product_info = Route(
    name="product_info",
    references=["what are the specs", "product features"],
    metadata={"ttl": 86400}
)

router = SemanticRouter(
    name="cache_router",
    routes=[personal_operations, product_info],
    vectorizer=HFTextVectorizer(),
    redis_url="redis://localhost:6379"
)
```

### LangGraph Integration

```python
from langgraph.graph import StateGraph, START, END

class AgentState(TypedDict):
    messages: List[dict]
    session_id: str
    cache_status: str
    result: str
    tools_used: List[str]

async def query_cache_check(state: AgentState) -> AgentState:
    query = state["messages"][-1]["content"]
    cached_result = await check_semantic_cache(query)
    if cached_result:
        return {**state, "cache_status": "hit", "result": cached_result}
    return {**state, "cache_status": "miss"}

graph = StateGraph(AgentState)
graph.add_node("cache_check", query_cache_check)
graph.add_node("agent", agent_node)
graph.add_node("cache_result", cache_result_node)
graph.add_edge(START, "cache_check")

def should_invoke_agent(state: AgentState) -> str:
    return END if state["cache_status"] == "hit" else "agent"

graph.add_conditional_edges("cache_check", should_invoke_agent)
graph.add_edge("agent", "cache_result")
graph.add_edge("cache_result", END)
workflow = graph.compile()
```

### Production Recommendations
- Human-curated caches with periodic review
- PII scrubbing before cache storage
- Multi-turn conversations: rewrite queries into self-contained questions before caching
