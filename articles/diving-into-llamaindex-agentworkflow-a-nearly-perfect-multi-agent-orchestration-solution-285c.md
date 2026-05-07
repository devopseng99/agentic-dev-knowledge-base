---
title: "Diving into LlamaIndex AgentWorkflow: A Nearly Perfect Multi-Agent Orchestration Solution"
url: "https://dev.to/qtalen/diving-into-llamaindex-agentworkflow-a-nearly-perfect-multi-agent-orchestration-solution-285c"
author: "Peng Qian"
category: "llamaindex-agent"
---

# Diving into LlamaIndex AgentWorkflow: A Nearly Perfect Multi-Agent Orchestration Solution

**Author:** Peng Qian
**Published:** March 10, 2025

## Overview

Introduces LlamaIndex's AgentWorkflow framework for multi-agent orchestration. LlamaIndex has rebranded from a RAG framework to a multi-agent framework integrating data and workflow.

## Key Concepts

### Core Components

**FunctionAgent** includes three primary methods:
- `take_step`: Receives chat history and tools, executes function calls
- `handle_tool_call_results`: Saves tool execution results
- `finalize`: Extracts tool call stacks and updates chat memory

**AgentWorkflow** orchestrates agents through:
- `init_run`: Initialize the workflow
- `setup_agent`: Configure the active agent
- `run_agent_step`: Execute agent actions
- `handoff`: Transfer control between agents

### Customer Service Example

```python
from llama_index.core.agent import FunctionAgent
from llama_index.core.agent.workflow import AgentWorkflow

def login(username: str, password: str) -> str:
    """Register a user with username and password."""
    return f"User {username} registered successfully"

concierge_agent = FunctionAgent(
    name="ConciergeAgent",
    description="An agent to register user information",
    system_prompt="You are an assistant responsible for user registration.",
    tools=[login],
    can_handoff_to=["PreSalesAgent", "PostSalesAgent"]
)

presales_agent = FunctionAgent(
    name="PreSalesAgent",
    description="An agent to answer product questions",
    system_prompt="You are a presales assistant.",
    tools=[product_search],
    can_handoff_to=["ConciergeAgent", "PostSalesAgent"]
)

postsales_agent = FunctionAgent(
    name="PostSalesAgent",
    description="An agent to manage after-sales inquiries",
    system_prompt="You handle returns, complaints, and support.",
    tools=[order_lookup],
    can_handoff_to=["ConciergeAgent", "PreSalesAgent"]
)

workflow = AgentWorkflow(
    agents=[concierge_agent, presales_agent, postsales_agent],
    root_agent="ConciergeAgent"
)

result = await workflow.run(user_msg="I want to register")
```

### Handoff Problem Fix

The author identified that after agent transitions, the receiving agent cannot trace back to the user's original request. The fix involves extending FunctionAgent to relocate the user's original message to the conversation history's end after handoffs.

```python
class EnhancedFunctionAgent(FunctionAgent):
    async def handle_handoff(self, ctx, ev):
        # Move original user message to end of history
        # so the new agent can see the user's request
        chat_history = ctx.data.get("chat_history", [])
        user_messages = [m for m in chat_history if m.role == "user"]
        if user_messages:
            last_user_msg = user_messages[-1]
            chat_history.append(last_user_msg)
        return await super().handle_handoff(ctx, ev)
```
