---
title: "Step-by-Step Guide to Building Domain-Specific AI Agents with Phidata SDK"
url: "https://dev.to/coding_farhan/step-by-step-guide-to-building-domain-specific-ai-agents-with-phidata-sdk-4l6f"
author: "Farhan Ahmad"
category: "agent-sdk"
---

# Step-by-Step Guide to Building Domain-Specific AI Agents with Phidata SDK

**Author:** Farhan Ahmad
**Published:** January 22, 2025

---

## Overview

This tutorial demonstrates how to build AI agents using the Phidata SDK, a framework that simplifies agent development through pre-built tools and minimal code requirements.

## What is Phidata?

"Phidata SDK makes it super easy to build AI Agents in just a few lines of Python code." The platform provides ready-made tools including web search, email capabilities, web crawling, data analysis, and GitHub integration.

## Key Concepts

**Team Agents:** Multiple specialized agents work together on complex tasks. For example, a financial analyst agent combines web search and Yahoo Finance tools to deliver comprehensive market analysis.

## Building a Financial Analyst Agent

### Step 1: Setup Google Colab
Create a new notebook at colab.research.google.com for an interactive development environment.

### Step 2: Install Dependencies
```python
pip install openai yfinance duckduckgo-search phidata
```

Required libraries:
- **yfinance** -- Financial data retrieval
- **openai** -- LLM integration
- **duckduckgo-search** -- Web search functionality
- **phidata** -- Agent framework and tools

### Step 3: Configure API Key
```python
import os
os.environ['OPENAI_API_KEY'] = "your_api_key"
```

Obtain your API key from platform.openai.com/api-keys.

### Step 4: Create the Agent Team
```python
from phi.agent import Agent
from phi.model.openai import OpenAIChat
from phi.tools.duckduckgo import DuckDuckGo
from phi.tools.yfinance import YFinanceTools

web_agent = Agent(
    name="Web Agent",
    role="Search the web for information",
    model=OpenAIChat(id="gpt-4o"),
    tools=[DuckDuckGo()],
    instructions=["Always include sources"],
    show_tool_calls=True,
    markdown=True,
)

finance_agent = Agent(
    name="Finance Agent",
    role="Get financial data",
    model=OpenAIChat(id="gpt-4o"),
    tools=[YFinanceTools(stock_price=True, analyst_recommendations=True, company_info=True)],
    instructions=["Use tables to display data"],
    show_tool_calls=True,
    markdown=True,
)

agent_team = Agent(
    team=[web_agent, finance_agent],
    instructions=["Always include sources", "Use tables to display data"],
    show_tool_calls=True,
    markdown=True,
)

agent_team.print_response("Summarize analyst recommendations and share the latest news for NVDA", stream=True)
```

## Key Takeaways

- Phidata dramatically reduces development time for AI agents through pre-built tools
- Team agents leverage multiple specialized agents for comprehensive analysis
- Google Colab provides an accessible environment for experimentation
- The framework supports function calling and integration with major LLMs
