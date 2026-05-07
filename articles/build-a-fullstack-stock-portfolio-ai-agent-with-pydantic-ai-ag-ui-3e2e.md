---
title: "Build a Fullstack Stock Portfolio AI Agent with Pydantic AI + AG-UI"
url: https://dev.to/copilotkit/build-a-fullstack-stock-portfolio-ai-agent-with-pydantic-ai-ag-ui-3e2e
author: Bonnie
category: pydantic-ai
---

# Build a Stock Portfolio AI Agent (Fullstack, Pydantic AI + AG-UI)

**Author:** Bonnie
**Published:** October 2, 2025
**Last Modified:** October 8, 2025

---

## Overview

This comprehensive guide demonstrates constructing full-stack AI agents using Pydantic AI integrated with the AG-UI protocol. The tutorial covers bridging backend agent logic with frontend interfaces through CopilotKit for real-time conversational experiences.

## Key Concepts

### What is AG-UI Protocol?

The Agent User Interaction Protocol (AG-UI), developed by CopilotKit, provides "a lightweight, event-driven tool that facilitates real-time interactions between application frontends and AI agents." The protocol enables:

- **Lifecycle events** (RUN_STARTED, RUN_FINISHED)
- **Text message streaming** (TEXT_MESSAGE_START, TEXT_MESSAGE_CONTENT, TEXT_MESSAGE_END)
- **State synchronization** (STATE_SNAPSHOT, STATE_DELTA)
- **Tool invocation** (TOOL_CALL_START, TOOL_CALL_ARGS, TOOL_CALL_END)

---

## Backend Implementation (Python)

### Step 1: Define Agent State

Create a Pydantic BaseModel containing all state data the agent manages:

```python
from pydantic import BaseModel, Field

class AgentState(BaseModel):
    """Main application state for stock portfolio agent."""
    tools: list = []
    be_stock_data: Any = None
    be_arguments: dict = {}
    available_cash: float = 0.0
    investment_summary: dict = {}
    investment_portfolio: list = []
    tool_logs: list = []
    render_standard_charts_and_table_args: dict = {}
```

### Step 2: Initialize Pydantic AI Agent

```python
from pydantic_ai import Agent, RunContext
from pydantic_ai.ag_ui import StateDeps

agent = Agent(
    "openai:gpt-4o-mini",
    deps_type=StateDeps[AgentState],
)
```

### Step 3: Define Agent Tools

Tools handle specific operations. Example structure:

```python
@agent.tool
async def gather_stock_data(
    ctx: RunContext[StateDeps[AgentState]],
    stock_tickers_list: list[str],
    investment_date: str,
    interval_of_investment: str,
    amount_of_dollars_to_be_invested: list[float],
    operation: Literal["add", "replace", "delete"],
    to_be_replaced: list[str]
) -> list[StateSnapshotEvent, StateDeltaEvent]:
    """Gathers stock data and manages portfolio based on specified operation."""
    # Implementation handles data gathering and portfolio updates
    pass
```

### Step 4: Configure State Management with JSON Patch

```python
class JSONPatchOp(BaseModel):
    """RFC 6902 JSON Patch operation for incremental state updates."""
    op: Literal["add", "remove", "replace", "move", "copy", "test"]
    path: str = Field(description="JSON Pointer (RFC 6901) to target")
    value: Any = Field(default=None)
    from_: str | None = Field(default=None, alias="from")
```

### Step 5: Configure Human-in-the-Loop

```python
@agent.instructions
async def instructions(ctx: RunContext[StateDeps[AgentState]]) -> str:
    """Dynamic instructions guiding agent behavior and tool usage patterns."""
    return dedent("""
        You are a stock portfolio analysis agent.
        Use tools to answer user queries effectively.
        Call render_standard_charts_and_table after generate_insights.
    """)
```

### Step 6: Set Up FastAPI Server

```python
from pydantic_ai.ag_ui import handle_ag_ui_request
from fastapi import FastAPI
import uvicorn

app = FastAPI()

@app.post('/pydantic-agent')
async def run_agent(request: Request) -> Response:
    """Handle AG-UI requests by delegating to agent with state deps."""
    return await handle_ag_ui_request(
        agent=agent,
        deps=StateDeps(AgentState()),
        request=request
    )

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
```

---

## Frontend Implementation (Next.js)

### Create HttpAgent Instance

In `src/app/api/copilotkit/route.ts`:

```typescript
import {
  CopilotRuntime,
  copilotRuntimeNextJSAppRouterEndpoint,
  OpenAIAdapter,
} from "@copilotkit/runtime";
import { NextRequest } from "next/server";

// HttpAgent bridges frontend with AG-UI-compatible backend servers
const runtime = new CopilotRuntime({
  agents: [
    new HttpAgent({
      name: "stock-portfolio-agent",
      url: "http://localhost:8000/pydantic-agent",
    }),
  ],
});

export const POST = copilotRuntimeNextJSAppRouterEndpoint({
  runtime,
});
```

---

## Prerequisites

- **Python** with Pydantic AI framework
- **OpenAI API Key** (GPT-4 access recommended)
- **CopilotKit** framework
- **React/Next.js** knowledge
- **Node.js** and package manager (pnpm)

---

## Setup Instructions

**Backend:**
```bash
cd agent
poetry install
# Add OPENAI_API_KEY to .env
poetry run python main.py
```

**Frontend:**
```bash
cd frontend
pnpm install
pnpm run dev
# Navigate to http://localhost:3000
```

---

## Architecture Summary

The integration creates a cohesive system where:

1. **Backend agent** manages stock portfolio logic and state
2. **AG-UI protocol** streams events from agent to frontend
3. **CopilotKit runtime** handles request routing and conversation management
4. **Frontend UI** displays real-time agent responses with state synchronization

The JSON Patch operations enable efficient incremental updates rather than full state replacement on each agent action.
