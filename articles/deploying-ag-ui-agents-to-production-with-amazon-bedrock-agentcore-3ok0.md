---
title: "Deploying AG-UI Agents to Production with Amazon Bedrock AgentCore"
url: "https://dev.to/copilotkit/deploying-ag-ui-agents-to-production-with-amazon-bedrock-agentcore-3ok0"
author: "Anmol Baranwal"
category: "aws-agents"
---

# Deploying AG-UI Agents to Production with Amazon Bedrock AgentCore
**Author:** Anmol Baranwal
**Published:** March 24, 2026

## Overview
Deploying AG-UI (Agent-User Interaction Protocol) agents to production using AgentCore Runtime. Covers server setup with FastAPI, local testing, production deployment, and frontend integration with CopilotKit.

## Key Concepts

### FastAPI Server with AG-UI + Strands

```python
import uvicorn
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse, JSONResponse
from ag_ui_strands import StrandsAgent
from ag_ui.core import RunAgentInput
from ag_ui.encoder import EventEncoder
from strands import Agent
from strands.models.bedrock import BedrockModel

model = BedrockModel(
    model_id="us.anthropic.claude-3-5-sonnet-20241022-v2:0",
    region_name="us-west-2",
)
strands_agent = Agent(model=model, system_prompt="You are a helpful assistant.")
agui_agent = StrandsAgent(agent=strands_agent, name="my_agent", description="A helpful assistant")

app = FastAPI()

@app.post("/invocations")
async def invocations(input_data: dict, request: Request):
    accept_header = request.headers.get("accept")
    encoder = EventEncoder(accept=accept_header)
    async def event_generator():
        run_input = RunAgentInput(**input_data)
        async for event in agui_agent.run(run_input):
            yield encoder.encode(event)
    return StreamingResponse(event_generator(), media_type=encoder.get_content_type())

@app.get("/ping")
async def ping():
    return JSONResponse({"status": "Healthy"})
```

### Deploy with AG-UI Protocol

```bash
pip install bedrock-agentcore-starter-toolkit
agentcore configure -e my_agui_server.py --protocol AGUI
agentcore deploy
```

### Frontend Integration (TypeScript)

```typescript
import { HttpAgent } from "@ag-ui/client";

const agent = new HttpAgent({
    url: `https://bedrock-agentcore.us-west-2.amazonaws.com/runtimes/${encodedArn}/invocations?qualifier=DEFAULT`,
    headers: {
        "Authorization": `Bearer ${token}`,
        "X-Amzn-Bedrock-AgentCore-Runtime-Session-Id": sessionId,
    }
});
```
