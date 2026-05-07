---
title: "How to Build a LangGraph Research Agent that Embeds Dynamic Charts via MCP Apps (CopilotKit & Tako)"
url: "https://dev.to/copilotkit/how-to-build-a-langgraph-research-agent-that-embeds-dynamic-charts-via-mcp-apps-copilotkit-tako-3ihi"
author: "Anmol Baranwal"
category: "agent-ui-frameworks"
---

# How to Build a LangGraph Research Agent that Embeds Dynamic Charts via MCP Apps
**Author:** Anmol Baranwal
**Published:** February 3, 2026

## Overview
Building an AI research assistant combining chat and canvas interfaces that searches the web, queries structured data via MCP, and embeds interactive Tako charts directly into reports while streaming progress in real-time.

## Key Concepts

### Architecture
```
User question -> CopilotKit UI -> LangGraph agent
  -> chat: interpret intent + plan
  -> search: parallel retrieval (Tavily + Tako via MCP Apps)
  -> report: narrative + [CHART:*] markers
-> Streaming state updates (AG-UI events)
-> Canvas renders report + embedded charts
```

### Stack
- CopilotKit for frontend chat + canvas UI
- LangGraph for stateful agent orchestration
- MCP Apps for external tool integration
- Tako for interactive charts
- AG-UI Protocol for agent-frontend communication

### Key Pattern
Uses useCoAgentStateRender to translate [CHART:title] markers into real embedded charts via iframe registry for stable rendering during streaming.

GitHub: https://github.com/TakoData/tako-copilotkit
