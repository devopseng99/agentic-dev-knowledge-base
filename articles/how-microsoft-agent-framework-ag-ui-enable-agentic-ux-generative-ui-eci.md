---
title: "How Microsoft Agent Framework + AG-UI Enable Agentic UX & Generative UI"
url: "https://dev.to/copilotkit/how-microsoft-agent-framework-ag-ui-enable-agentic-ux-generative-ui-eci"
author: "Nathan Tarbert"
category: "agent-ui-frameworks"
---

# How Microsoft Agent Framework + AG-UI Enable Agentic UX & Generative UI
**Author:** Nathan Tarbert
**Published:** November 20, 2025

## Overview
Microsoft Agent Framework (MAF) handles reasoning, tools, workflows, and state, while AG-UI standardizes agent-to-UI communication. Together they enable complete agent loops with interpretability and frontend portability.

## Key Concepts

### Architecture
- MAF: agents, workflows, model/memory providers
- AG-UI: streaming messages, state updates, tool invocations, UI events, multi-agent routing

### Five Advantages
1. Out-of-box UI readiness (no custom WebSocket implementations)
2. Natural workflow surfacing (intermediate states, tool progress, agent handoffs)
3. Typed state visibility (structured state transported to frontends)
4. Transparent tool usage (parameters and results visible)
5. Frontend portability (CopilotKit, Blazor, Terminal Client, Kotlin SDK)

### Developer Impact
- Complete agent loop: Agent -> protocol -> frontend -> user -> agent
- Streaming and intermediate states enable debugging and trust
- Clean stack: MAF handles reasoning + tools, AG-UI handles communication + events
