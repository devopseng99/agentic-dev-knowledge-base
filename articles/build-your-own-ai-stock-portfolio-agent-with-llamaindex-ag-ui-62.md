---
title: "Build Your Own AI Stock Portfolio Agent with LlamaIndex + AG-UI"
url: "https://dev.to/copilotkit/build-your-own-ai-stock-portfolio-agent-with-llamaindex-ag-ui-62"
author: "Bonnie"
category: "llamaindex-agent"
---

# Build Your Own AI Stock Portfolio Agent with LlamaIndex + AG-UI

**Author:** Bonnie
**Published:** August 13, 2025

## Overview

Tutorial integrating LlamaIndex agents with the AG-UI protocol to create an AI-powered stock portfolio analysis tool. Covers building a Python backend using FastAPI and LlamaIndex workflows with frontend integration via CopilotKit.

## Key Concepts

### AG-UI Protocol Events

AG-UI is an open-source, lightweight, event-based protocol for real-time frontend-agent interaction:
- Lifecycle events (RUN_STARTED, RUN_FINISHED)
- Text message events (streaming responses)
- Tool call events (managing agent executions)
- State management events (keeping frontend/agent synchronized)

### Backend Implementation

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from ag_ui.core import RunStartedEvent, RunFinishedEvent, StateDeltaEvent
from ag_ui.encoder import EventEncoder

app = FastAPI()

@app.post("/agent/run")
async def run_agent(request: AgentRequest):
    async def event_generator():
        encoder = EventEncoder()

        # Emit run started
        yield encoder.encode(RunStartedEvent(run_id=request.run_id))

        # Run LlamaIndex workflow
        workflow = StockAnalysisWorkflow()
        result = await workflow.run(query=request.query)

        # Emit state delta for UI sync
        yield encoder.encode(StateDeltaEvent(
            delta=[{"op": "replace", "path": "/portfolio", "value": result}]
        ))

        # Emit run finished
        yield encoder.encode(RunFinishedEvent(run_id=request.run_id))

    return StreamingResponse(event_generator(), media_type="text/event-stream")
```

### LlamaIndex Workflow

```python
from llama_index.core.workflow import Workflow, step, StartEvent, StopEvent

class StockAnalysisWorkflow(Workflow):
    @step
    async def analyze_query(self, ev: StartEvent) -> AnalysisEvent:
        """Analyze user query and extract stock tickers."""
        # GPT function calling for data extraction
        pass

    @step
    async def fetch_stock_data(self, ev: AnalysisEvent) -> DataEvent:
        """Fetch real-time stock data."""
        pass

    @step
    async def simulate_portfolio(self, ev: DataEvent) -> SimulationEvent:
        """Run portfolio simulation."""
        pass

    @step
    async def generate_insights(self, ev: SimulationEvent) -> StopEvent:
        """Generate investment insights."""
        pass
```

### Prerequisites
- Python, LlamaIndex, OpenAI API Key (GPT-4)
- CopilotKit, React/Next.js for frontend
