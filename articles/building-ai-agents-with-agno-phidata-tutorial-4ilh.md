---
title: "Building AI Agents with Agno-Phidata (Github +18.5k Stars)"
url: "https://dev.to/mehmetakar/building-ai-agents-with-agno-phidata-tutorial-4ilh"
author: "Mehmet Akar"
category: "phidata-agent"
---

# Building AI Agents with Agno-Phidata

**Author:** Mehmet Akar
**Published:** February 5, 2025

## Overview

Agno (formerly Phidata) is a framework for creating multi-modal AI agents with over 18,500 GitHub stars. It operates around three pillars: simplicity, performance (5000x faster agent instantiation and 50x more memory efficient than LangGraph), and model-agnostic compatibility.

## Key Concepts

- Agent instantiation measured at <5 microseconds
- Native support for text, image, audio, and video
- Individual or team-based agent configurations
- Vector database integration for RAG and long-term memory via LanceDB
- Real-time monitoring and session logging

## Code Examples

### Basic Agent

```python
from agno.agent import Agent
from agno.models.openai import OpenAIChat

agent = Agent(
    model=OpenAIChat(id="gpt-4o"),
    description="You are a helpful assistant.",
    markdown=True,
)

agent.print_response("What is the capital of France?", stream=True)
```

### Agent with Tools (Web Search)

```python
from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.tools.duckduckgo import DuckDuckGoTools

agent = Agent(
    model=OpenAIChat(id="gpt-4o"),
    tools=[DuckDuckGoTools()],
    show_tool_calls=True,
    markdown=True,
)

agent.print_response("What's happening in AI today?", stream=True)
```

### Knowledge Base Agent (Thai Cuisine Expert)

```python
from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.embedder.openai import OpenAIEmbedder
from agno.knowledge.pdf_url import PDFUrlKnowledgeBase
from agno.vectordb.lancedb import LanceDb, SearchType

knowledge_base = PDFUrlKnowledgeBase(
    urls=["https://agno-public.s3.amazonaws.com/recipes/ThaiRecipes.pdf"],
    vector_db=LanceDb(
        table_name="recipes",
        uri="tmp/lancedb",
        search_type=SearchType.vector,
        embedder=OpenAIEmbedder(model="text-embedding-3-small"),
    ),
)
knowledge_base.load()

agent = Agent(
    model=OpenAIChat(id="gpt-4o"),
    knowledge=knowledge_base,
    search_knowledge=True,
    show_tool_calls=True,
    markdown=True,
)
```

### Multi-Agent System

```python
from agno.agent import Agent
from agno.models.openai import OpenAIChat
from agno.tools.duckduckgo import DuckDuckGoTools
from agno.tools.yfinance import YFinanceTools

web_agent = Agent(
    name="Web Agent",
    role="Search the web for information",
    model=OpenAIChat(id="gpt-4o"),
    tools=[DuckDuckGoTools()],
    instructions=["Always include sources"],
    show_tool_calls=True,
    markdown=True,
)

finance_agent = Agent(
    name="Finance Agent",
    role="Get financial data",
    model=OpenAIChat(id="gpt-4o"),
    tools=[YFinanceTools(stock_price=True, analyst_recommendations=True)],
    instructions=["Use tables to display data"],
    show_tool_calls=True,
    markdown=True,
)

agent_team = Agent(
    team=[web_agent, finance_agent],
    model=OpenAIChat(id="gpt-4o"),
    instructions=["Always include sources", "Use tables to display data"],
    show_tool_calls=True,
    markdown=True,
)

agent_team.print_response("Summarize analyst recommendations and share the latest news for NVDA", stream=True)
```

## Real-World Applications

- Customer support automation
- Travel planning
- Coding assistance
- Financial analysis
- Research data processing
