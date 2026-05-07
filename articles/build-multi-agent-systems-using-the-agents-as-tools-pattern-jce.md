---
title: "Build Multi-Agent Systems Using the Agents as Tools Pattern"
url: "https://dev.to/aws/build-multi-agent-systems-using-the-agents-as-tools-pattern-jce"
author: "Laura Salinas"
category: "multi-agent system Python"
---

# Build Multi-Agent Systems Using the Agents as Tools Pattern

**Author:** Laura Salinas (AWS)
**Published:** November 18, 2025

## Overview
Agents as Tools is an architectural pattern where specialized AI agents are wrapped as callable functions that can be used by other agents. The pattern features an Orchestrator Agent that handles user interaction and determines which specialist to call, and Specialized Tool Agents that are domain experts performing specific tasks when called. The article uses the Strands framework.

## Key Concepts

### How Agents as Tools Work
1. User sends request to orchestrator
2. Orchestrator analyzes request against tool docstrings
3. Orchestrator selects and calls appropriate specialist
4. Specialist processes request with domain expertise
5. Result returns to user through orchestrator

### Creating Specialized Tool Agents

```python
from strands import Agent, tool
from strands_tools import retrieve, http_request

RESEARCH_ASSISTANT_PROMPT = """
You are a specialized research assistant. Focus only on providing
factual, well-sourced information in response to research questions.
Always cite your sources when possible.
"""

@tool
def research_assistant(query: str) -> str:
    """
    Process and respond to research-related queries.

    Args:
        query: A research question requiring factual information

    Returns:
        A detailed research answer with citations
    """
    try:
        research_agent = Agent(
            system_prompt=RESEARCH_ASSISTANT_PROMPT,
            tools=[retrieve, http_request]
        )

        response = research_agent(query)
        return str(response)
    except Exception as e:
        return f"Error in research assistant: {str(e)}"
```

### Creating the Orchestrator

```python
from strands import Agent
from .specialized_agents import research_assistant, product_recommendation_assistant, trip_planning_assistant

MAIN_SYSTEM_PROMPT = """
You are an assistant that routes queries to specialized agents:
- For research questions and factual information -> Use the research_assistant tool
- For product recommendations and shopping advice -> Use the product_recommendation_assistant tool
- For travel planning and itineraries -> Use the trip_planning_assistant tool
- For simple questions not requiring specialized knowledge -> Answer directly

Always select the most appropriate tool based on the user's query.
"""

orchestrator = Agent(
    system_prompt=MAIN_SYSTEM_PROMPT,
    callback_handler=None,
    tools=[research_assistant, product_recommendation_assistant, trip_planning_assistant]
)
```

### When to Use Agents as Tools
- Distinct domain expertise can be cleanly separated
- Hierarchical structure suits the use case
- Straightforward routing logic is desired
- Each task type handled by single specialist
- Building customer service, virtual assistant, or help desk systems

### Comparing Multi-Agent Patterns
- **Swarms:** Use for exploration, dynamic agent decisions, collaboration-centered solutions
- **Graphs:** Use for clear workflows with known dependencies, deterministic execution, conditional branching
- **Agents as Tools:** Use for specialist domains, hierarchical coordination, simple routing, single-specialist tasks

### Best Practices
- Write crystal-clear docstrings for LLM decision-making
- Keep system prompts tightly focused on responsibility
- Include comprehensive error handling
- Give explicit routing guidance in orchestrator prompt
- Use consistent response patterns across agents
