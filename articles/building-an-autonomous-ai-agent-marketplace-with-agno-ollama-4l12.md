---
title: "Building an Autonomous AI Agent Marketplace with Agno and Ollama"
url: "https://dev.to/harishkotra/building-an-autonomous-ai-agent-marketplace-with-agno-ollama-4l12"
author: "Harish Kotra"
category: "phidata-agent"
---

# Building an Autonomous AI Agent Marketplace with Agno and Ollama

**Author:** Harish Kotra
**Published:** February 2, 2026

## Overview

AgentBazaar is a multi-agent simulation where AI agents compete, negotiate, and execute contracts in a marketplace environment running locally using Agno framework and Ollama (llama3.2).

## Key Concepts

### Architecture

- **Broker Agent**: Prioritizes quality, generates task specifications
- **Worker Agent**: Seeks high compensation, submits proposals
- **Negotiator Agent**: Optimizes value through multi-round haggling
- **Validator Agent**: Evaluates work against contract criteria
- **Escrow Agent**: Holds simulated funds, releases on validation

### Structured Output with Pydantic

```python
from pydantic import BaseModel
from agno.agent import Agent
from agno.models.ollama import Ollama

class TaskSpec(BaseModel):
    title: str
    description: str
    budget: float
    requirements: list[str]
    deadline: str

broker = Agent(
    name="Broker",
    model=Ollama(id="llama3.2"),
    instructions=["You are a project broker. Generate detailed task specifications."],
    output_schema=TaskSpec,  # Enforces structured JSON output
    markdown=True,
)
```

### Multi-Turn Negotiation

```python
class NegotiationOffer(BaseModel):
    price: float
    terms: str
    accepted: bool

negotiator = Agent(
    name="Negotiator",
    model=Ollama(id="llama3.2"),
    instructions=[
        "You negotiate contracts. Start at 90% of the asking price.",
        "Reduce by 10% each round until agreement.",
    ],
    output_schema=NegotiationOffer,
)

# Multi-round negotiation loop
for round in range(5):
    offer = negotiator.run(f"Round {round+1}: Counter-offer for task at ${current_price}")
    if offer.accepted:
        break
    current_price = offer.price
```

### Streamlit Visualization

```python
import streamlit as st

def run_marketplace():
    st.title("AgentBazaar - AI Marketplace")

    with st.status("Running marketplace simulation..."):
        for update in marketplace_generator():
            st.write(update)  # Real-time updates via yield
```

### Key Patterns

- `output_schema` with Pydantic for reliable structured JSON from LLMs
- Python generators (`yield`) for streaming UI updates
- Multi-turn loops for iterative agent negotiation
