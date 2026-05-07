---
title: "Understanding AI Agents: Thought, Action, and Observation in Practice"
url: "https://dev.to/stacklok/understanding-ai-agents-thought-action-and-observation-in-practice-509i"
author: "Pankaj Telang (Stacklok)"
category: "agent-fundamentals"
---

# Understanding AI Agents: Thought, Action, and Observation in Practice

**Author:** Pankaj Telang (Stacklok)
**Published:** March 4, 2025
**Last Updated:** March 6, 2025

---

## Overview

This article introduces AI agents as part of a series on demystifying autonomous systems. The piece focuses on foundational concepts, the think-act-observe loop, and how agents leverage tools to accomplish user-specified goals.

## Core Concepts

### What is an AI Agent?

An agent is an entity capable of observing and acting within an environment. Based on user instructions, the agent constructs a plan (sequence of steps) and executes it by calling pre-defined tools.

**Tools** are functions with well-defined interfaces that can perform calculations, query databases, or invoke APIs.

### The Think-Act-Observe Loop

The agent executes iterative cycles consisting of three phases:

- **Think:** The agent reasons about user instructions and determines which action to perform next
- **Act:** The agent executes the chosen action by calling available tools
- **Observe:** The agent examines tool outputs and uses results to inform subsequent reasoning

## Practical Example: Stock Trading Agent

The article demonstrates these concepts through a hypothetical stock trading scenario.

### Available Tools

```python
# Lookup the stock ticker of a company
lookup_ticker(company_name: str)

# Lookup my stock holdings
get_my_stock_holdings()

# Get the price of a given stock ticker
get_stock_price(stock_ticker: str)

# Sell the stock of given ticker and given quantity
sell_stock(stock_ticker: str, quantity: int)
```

### User Instruction

"Check the stock price of Nvidia. If it is above $150, sell 80% of the stock that I hold."

### Agent Planning Process

The LLM constructs this sequence:

1. Call `lookup_ticker` to obtain Nvidia's ticker symbol
2. Call `get_stock_price` with the ticker
3. If price exceeds $150, call `get_my_stock_holdings()` to determine share count
4. Calculate 80% of holdings
5. Call `sell_stock` to execute the sale

### Execution Walkthrough

**Step 1 - Think/Act/Observe:**
- Agent calls `lookup_ticker("Nvidia")`
- Returns: NVDA

**Step 2 - Think/Act/Observe:**
- Agent calls `get_stock_price("NVDA")`
- Returns: $160

**Step 3 - Think/Act/Observe:**
- Agent calls `get_my_stock_holdings()`
- Returns: {"nvidia": 100, "msft": 50, "tsla": 10}

**Step 4 - Think/Act/Observe:**
- Agent calculates 80% of 100 shares
- Returns: 80 shares

**Step 5 - Think/Act/Observe:**
- Agent calls `sell_stock("NVDA", 80)`
- Returns: Success

## Key Takeaways

1. AI agents employ LLMs as reasoning engines to plan and execute complex tasks
2. The think-act-observe cycle enables agents to adapt based on tool outputs
3. Tools provide the interface between agents and external systems
4. Planning precedes execution, allowing agents to construct efficient action sequences

## Future Topics in Series

- SmolAgents framework from Hugging Face
- Security considerations for AI agents using CodeGate
- Practical implementation guidance

## References

- Artificial Intelligence: A Modern Approach (Russell & Norvig)
- Hugging Face SmolAgents blog
- CodeGate security framework
