---
title: "Building 5 AI Agents with phidata and Ollama"
url: "https://dev.to/0xkoji/building-5-ai-agents-with-phidata-and-ollama-156b"
author: "0xkoji"
category: "phidata-agent"
---

# Building 5 AI Agents with phidata and Ollama

**Author:** 0xkoji
**Published:** December 14, 2024

## Overview

This tutorial demonstrates creating five different AI agents using phidata (an open-source platform for building agentic systems) and Ollama (a local LLM deployment tool). The article uses the llama3.2 model throughout and covers practical implementations of web search, finance, team coordination, reasoning, and RAG agents.

## Key Concepts

### Setup and Dependencies

```bash
pip install phidata ollama duckduckgo-search yfinance pypdf lancedb tantivy sqlalchemy
ollama serve
ollama pull llama3.2
```

### 1. Web Search Agent

Uses DuckDuckGo to search the internet. The agent can retrieve current information and include sources in responses.

```python
from phi.agent import Agent
from phi.model.ollama import Ollama
from phi.tools.duckduckgo import DuckDuckGo

web_agent = Agent(
    name="Web Agent",
    model=Ollama(id="llama3.2"),
    tools=[DuckDuckGo()],
    instructions=["Always include sources"],
    show_tool_calls=True,
    markdown=True,
)

web_agent.print_response("What's happening in AI today?", stream=True)
```

### 2. Finance Agent

Leverages yfinance tools to access stock prices, analyst recommendations, company information, and news.

```python
from phi.agent import Agent
from phi.model.ollama import Ollama
from phi.tools.yfinance import YFinanceTools

finance_agent = Agent(
    name="Finance Agent",
    model=Ollama(id="llama3.2"),
    tools=[YFinanceTools(stock_price=True, analyst_recommendations=True, company_info=True, company_news=True)],
    instructions=["Use tables to display data"],
    show_tool_calls=True,
    markdown=True,
)

finance_agent.print_response("Summarize analyst recommendations for NVDA", stream=True)
```

### 3. Agent Team

Combines multiple specialized agents (web and finance) that work together to handle complex queries.

```python
agent_team = Agent(
    team=[web_agent, finance_agent],
    model=Ollama(id="llama3.2"),
    instructions=["Always include sources", "Use tables to display data"],
    show_tool_calls=True,
    markdown=True,
)

agent_team.print_response("Summarize analyst recommendations and share the latest news for NVDA", stream=True)
```

### 4. Inference/Reasoning Agent

Solves complex logical problems through step-by-step reasoning.

```python
from phi.agent import Agent
from phi.model.ollama import Ollama

task = """
Three missionaries and three cannibals need to cross a river...
"""

reasoning_agent = Agent(
    model=Ollama(id="llama3.2"),
    reasoning=True,
    markdown=True,
)

reasoning_agent.print_response(task, stream=True)
```

### 5. RAG Agent

Implements a knowledge base system using PDF documents, LanceDB vector database, and OllamaEmbedder.

```python
from phi.agent import Agent
from phi.model.ollama import Ollama
from phi.embedder.ollama import OllamaEmbedder
from phi.knowledge.pdf import PDFUrlKnowledgeBase
from phi.vectordb.lancedb import LanceDb, SearchType

knowledge_base = PDFUrlKnowledgeBase(
    urls=["https://phi-public.s3.amazonaws.com/recipes/ThaiRecipes.pdf"],
    vector_db=LanceDb(
        table_name="recipes",
        uri="tmp/lancedb",
        search_type=SearchType.vector,
        embedder=OllamaEmbedder(model="llama3.2"),
    ),
)
knowledge_base.load()

agent = Agent(
    model=Ollama(id="llama3.2"),
    knowledge=knowledge_base,
    show_tool_calls=True,
    markdown=True,
)

agent.print_response("How do I make chicken and galangal in coconut milk soup", stream=True)
```
