---
title: "Designing Smart Multi-Agent Workflows with Agno and LangDB"
url: "https://dev.to/langdb/designing-smart-multi-agent-workflows-with-agno-langdb-nic"
author: "Mrunmay (LangDB)"
category: "phidata-agent"
---

# Designing Smart Multi-Agent Workflows with Agno and LangDB

**Author:** Mrunmay (LangDB)
**Published:** July 24, 2025

## Overview

Demonstrates building a multi-agent financial analysis team using LangDB (an AI Gateway) and Agno (orchestration framework, formerly Phidata). Three specialized agents analyze publicly traded companies by combining web research with quantitative financial data.

## Key Concepts

### Setup

```bash
export LANGDB_API_KEY="<your_langdb_api_key>"
export LANGDB_PROJECT_ID="<your_langdb_project_id>"
pip install agno pylangdb yfinance
```

### Enhanced Tracing Initialization

```python
from pylangdb.agno import init

init()

from agno.agent import Agent
from agno.team import Team
from agno.models.langdb import LangDB
from agno.tools.yfinance import YFinanceTools
from agno.tools.reasoning import ReasoningTools
```

### Web Search Agent

```python
web_agent = Agent(
    name="Web Search Agent",
    role="Search the web for the information",
    model=LangDB(id="langdb/search_agent_xmf4v5jk"),
    instructions="Always include sources"
)
```

### Finance Agent with Tools

```python
finance_agent = Agent(
    name="Finance AI Agent",
    role="Analyse the given stock",
    model=LangDB(id="xai/grok-4"),
    tools=[YFinanceTools(
        stock_price=True,
        stock_fundamentals=True,
        analyst_recommendations=True,
        company_info=True,
        company_news=True
    )],
    instructions=[
        "Use tables to display stock prices, fundamentals (P/E, Market Cap), and recommendations.",
        "Clearly state the company name and ticker symbol.",
        "Focus on delivering actionable financial insights."
    ]
)
```

### Coordinating Team

```python
reasoning_finance_team = Team(
    name="Reasoning Finance Team",
    mode="coordinate",
    model=LangDB(id="xai/grok-4"),
    members=[web_agent, finance_agent],
    tools=[ReasoningTools(add_instructions=True)],
    instructions=[
        "Collaborate to provide comprehensive financial and investment insights",
        "Consider both fundamental analysis and market sentiment",
        "Present findings in a structured, easy-to-follow format",
    ],
    success_criteria="The team has provided a complete financial analysis with data, visualizations, risk assessment, and actionable investment recommendations."
)
```

### Running the Team

```python
reasoning_finance_team.print_response(
    """Compare the tech sector giants (AAPL, GOOGL, MSFT) performance:\n
    1. Get financial data for all three companies\n
    2. Analyze recent news affecting the tech sector\n
    3. Calculate comparative metrics and correlations\n
    4. Recommend portfolio allocation weights"""
)
```

### Key Features

- **Dynamic Tooling**: Virtual Models and Virtual MCPs allow changing tools without code deployment
- **Observable Architecture**: Every execution captured with full trace
- **Hierarchical tracing**: Input/output inspection per step, latency tracking, cost analysis
