---
title: "Easily Build a Frontend for your AWS Strands Agents using AG-UI in 30 minutes"
url: "https://dev.to/copilotkit/easily-build-a-frontend-for-your-aws-strands-agents-using-ag-ui-in-30-minutes-42ji"
author: "Bonnie"
category: "agent-ui-frameworks"
---

# Easily Build a Frontend for your AWS Strands Agents using AG-UI in 30 minutes
**Author:** Bonnie
**Published:** December 8, 2025

## Overview
Guide for building a frontend for AWS Strands Agents using AG-UI Protocol and CopilotKit, where AWS Strands powers the backend, CopilotKit powers the frontend, and AG-UI bridges communication.

## Key Concepts

### AWS Strands
Open-source agent framework by AWS supporting Amazon Bedrock, Anthropic, OpenAI, Meta Llama, Ollama, and LiteLLM with native MCP support.

### Setup
```bash
npx copilotkit@latest create -f aws-strands-py
pnpm install
pnpm dev
```

### Backend
```python
from ag_ui_strands import StrandsAgent, create_strands_app
from strands import Agent, tool

@tool
def update_proverbs(proverbs_list: ProverbsList):
    return "Proverbs updated successfully."

strands_agent = Agent(model=model, system_prompt=system_prompt, tools=[update_proverbs, get_weather])
agui_agent = StrandsAgent(agent=strands_agent, name="proverbs_agent", config=shared_state_config)
app = create_strands_app(agui_agent, "/")
```

### Frontend
```typescript
const runtime = new CopilotRuntime({
  agents: {
    strands_agent: new HttpAgent({ url: "http://localhost:8000" }),
  },
});

<CopilotKit runtimeUrl="/api/copilotkit" agent="strands_agent">
  {children}
</CopilotKit>
```
