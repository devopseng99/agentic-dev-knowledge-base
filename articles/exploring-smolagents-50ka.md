---
title: "Exploring SmolAgents"
url: "https://dev.to/stacklok/exploring-smolagents-50ka"
author: "Pankaj Telang (Stacklok)"
category: "agent-framework"
---

# Exploring SmolAgents

**Author:** Pankaj Telang (for Stacklok)
**Published:** May 2, 2025
**Series:** Part 2 of "Demystifying AI Agents"

---

## Overview

This article demonstrates how to implement an AI agent using SmolAgents, a lightweight framework by Hugging Face. The example builds on conceptual foundations from Part 1, implementing a practical stock trading agent.

## Key Concepts

### SmolAgents Framework

"SmolAgents is a lightweight AI agent framework developed by Hugging Face" designed for minimal-code agent development. The framework supports two approaches for tool invocation:

1. JSON generation with parsing
2. **Executable Python code** (demonstrated here as more flexible and modular)

### Stock Trading Agent Architecture

The agent uses:
- An LLM for planning and reasoning
- Four tools: ticker lookup, holdings retrieval, price fetching, and stock selling

**Example user instruction:** "Check the stock price of Nvidia. If it is above $150, sell 80% of the stock that I hold."

---

## Implementation Code

### Required Imports
```python
from smolagents import CodeAgent, OpenAIServerModel, tool
```

### Tool Definitions
```python
@tool
def lookup_ticker(name: str) -> str:
    """Looks up the stock ticker symbol for a given company name."""
    if name.lower() == "nvidia":
        return "NVDA"
    else:
        return "Unknown"

@tool
def get_my_stock_holdings() -> dict:
    """Returns the user's current stock holdings."""
    return {
        "NVDA": 100,
        "MSFT": 50,
        "TSLA": 20,
    }

@tool
def get_stock_price(ticker: str) -> float:
    """Returns the current price of the specified stock ticker."""
    if ticker == "NVDA":
        return 293.46
    elif ticker == "MSFT":
        return 225.23
    else:
        raise ValueError(f"Unknown stock symbol: {ticker}")

@tool
def sell_stock(ticker: str, quantity: int) -> str:
    """Sells a specified quantity of a given stock."""
    print(f"Sold {quantity} shares of {ticker}")
    return "Success"
```

### Agent Creation
```python
model = OpenAIServerModel(
    model_id="gpt-4o",
    api_key="<OPENAI_API_KEY>"
)

stock_agent = CodeAgent(
    tools=[lookup_ticker, get_my_stock_holdings, get_stock_price, sell_stock],
    model=model,
    planning_interval=3,
)
```

### Agent Execution
```python
agent.run(
    "Check the stock price of Nvidia. If it is above $150, sell 80 percent of the stock that I hold."
)
```

---

## Execution Flow

The agent follows a think-act-observe loop:

1. **Analyzes** the instruction and creates a plan
2. **Calls** `lookup_ticker` to find Nvidia's symbol (NVDA)
3. **Retrieves** Nvidia's price ($293.46)
4. **Fetches** user's stock holdings (100 shares of NVDA)
5. **Executes** sale of 80 shares (since price exceeds $150)
6. **Confirms** the transaction to the user

---

## Key Advantages

- All tool calls use **Python**, ensuring flexibility
- Calculations handled in code guarantee **mathematical accuracy** (unlike LLM calculations which may contain errors)
- Lightweight framework enables rapid experimentation

---

## References

1. SmolAgents: https://huggingface.co/blog/smolagents
2. CodeGate: https://codegate.ai/
3. Artificial Intelligence: A Modern Approach (Russell & Norvig)

---

## Next Steps

The series continues with exploring CodeGate for security and privacy integration with SmolAgents.
