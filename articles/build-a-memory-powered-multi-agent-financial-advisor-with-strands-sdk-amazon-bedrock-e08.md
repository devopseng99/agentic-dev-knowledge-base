---
title: "Build a Memory-Powered Multi-Agent Financial Advisor with Strands SDK & Amazon Bedrock"
url: "https://dev.to/aws-builders/build-a-memory-powered-multi-agent-financial-advisor-with-strands-sdk-amazon-bedrock-e08"
author: "Adeline Makokha"
category: "aws-agents"
---

# Build a Memory-Powered Multi-Agent Financial Advisor with Strands SDK & Amazon Bedrock
**Author:** Adeline Makokha
**Published:** April 23, 2026

## Overview
Multi-agent financial advisor system using Strands Agents SDK with specialist sub-agents for portfolio, market data, and news analysis. Includes Bedrock Guardrails for compliance, AgentCore Memory for persistent context, and AgentCore Runtime deployment.

## Key Concepts

### Define Tools with @tool Decorator

```python
from strands import tool
from typing import Optional

@tool
def get_portfolio_value(client_id: str, include_unrealized_gains: bool = True) -> dict:
    """Retrieve the current portfolio value and positions for a client."""
    return fetch_portfolio_data(client_id, include_unrealized_gains)

@tool
def get_market_data(tickers: list[str], period: str = "1d") -> dict:
    """Retrieve current market prices and key metrics for a list of tickers."""
    return fetch_market_prices(tickers, period)

@tool
def get_risk_analysis(client_id: str, risk_tolerance: Optional[str] = None) -> dict:
    """Perform a risk analysis on a client's portfolio."""
    return compute_risk_metrics(client_id, risk_tolerance)
```

### Specialist Sub-Agents

```python
from strands import Agent
from strands.models import BedrockModel

MODEL_ID = "us.anthropic.claude-3-5-sonnet-20241022-v2:0"

def create_portfolio_agent(guardrail_id=None):
    return Agent(
        model=_make_model(guardrail_id),
        system_prompt="You are a Portfolio Specialist. Analyse holdings, risk metrics, and P&L.",
        tools=[get_portfolio_value, get_risk_analysis],
    )
```

### Agent-as-Tool Orchestrator Pattern

```python
from strands import Agent, tool

def _build_specialist_tools(guardrail_id):
    portfolio_agent = create_portfolio_agent(guardrail_id)

    @tool
    def ask_portfolio_agent(query: str) -> str:
        """Delegate a portfolio question to the Portfolio Specialist Agent."""
        return str(portfolio_agent(query))

    return [ask_portfolio_agent, ask_market_data_agent, ask_news_agent]

def create_financial_advisor(guardrail_id=None, memory_context=""):
    specialist_tools = _build_specialist_tools(guardrail_id)
    return Agent(
        model=BedrockModel(model_id=MODEL_ID, region_name="us-east-1"),
        system_prompt=ORCHESTRATOR_PROMPT,
        tools=specialist_tools + [get_investment_recommendations],
    )
```

### Memory Manager with AgentCore

```python
class MemoryManager:
    def save_turn(self, user_input: str, agent_response: str):
        if self.use_local:
            self._local_memory.append({"user": user_input, "assistant": agent_response})
            return
        self._client.save_memory(
            memoryId=self.memory_id, sessionId=self.session_id,
            messages=[
                {"role": "user", "content": user_input},
                {"role": "assistant", "content": agent_response},
            ],
        )
```

### Deployment

```bash
agentcore dev           # Local with hot-reload
agentcore deploy        # Production on AgentCore Runtime
agentcore invoke "What is the portfolio value for client ABC123?" --stream
```
