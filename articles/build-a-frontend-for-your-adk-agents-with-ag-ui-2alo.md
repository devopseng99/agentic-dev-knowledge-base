---
title: "Build a Frontend for your ADK Agents with AG-UI"
url: "https://dev.to/copilotkit/build-a-frontend-for-your-adk-agents-with-ag-ui-2alo"
author: "Bonnie"
category: "agent-ui-frameworks"
---

# Build a Frontend for your ADK Agents with AG-UI
**Author:** Bonnie
**Published:** September 25, 2025

## Overview
Tutorial on creating frontends for Google Agent Development Kit (ADK) agents using AG-UI Protocol and CopilotKit, where ADK powers the backend, CopilotKit powers the frontend, and AG-UI bridges communication.

## Key Concepts

### CLI Setup
```bash
npx copilotkit@latest create -f adk
pnpm install
pnpm dev
```

### Backend (ADK + AG-UI)
```python
from ag_ui_adk import ADKAgent, add_adk_fastapi_endpoint
from google.adk.agents import LlmAgent

proverbs_agent = LlmAgent(
  name="ProverbsAgent",
  model="gemini-2.5-flash",
  instruction="...",
  tools=[set_proverbs, get_weather],
)

adk_proverbs_agent = ADKAgent(
  adk_agent=proverbs_agent,
  app_name="proverbs_app",
  user_id="demo_user",
)

app = FastAPI()
add_adk_fastapi_endpoint(app, adk_proverbs_agent, path="/")
```

### Frontend (CopilotKit)
```typescript
const runtime = new CopilotRuntime({
  agents: {
    my_agent: new HttpAgent({ url: "http://localhost:8000/" }),
  },
});

<CopilotKit runtimeUrl="/api/copilotkit" agent="my_agent">
  <CopilotSidebar />
</CopilotKit>
```

### Shared State
```typescript
const { state, setState } = useCoAgent<AgentState>({
  name: "my_agent",
  initialState: { proverbs: ["..."] },
});
```
