---
title: "Two New Ways to Build with AG-UI: LlamaIndex and Agno"
url: "https://dev.to/copilotkit/two-new-ways-to-build-with-ag-ui-llamaindex-and-agno-226d"
author: "Nathan Tarbert"
category: "llamaindex-agent"
---

# Two New Ways to Build with AG-UI: LlamaIndex and Agno

**Author:** Nathan Tarbert (CopilotKit)
**Published:** June 19, 2025

## Overview

Announces two new framework integrations for AG-UI (Agent-User Interaction Protocol), an open protocol for interactive AI agents. LlamaIndex enables retrieval-augmented agents and Agno brings multi-agent workflows to the AG-UI ecosystem.

## Key Concepts

### What is AG-UI?

AG-UI is a lightweight spec that connects backend AI agents with frontend applications, turning agents into interactive participants rather than silent backend executors. It defines 16+ event types supporting:
- Tool calls
- Token streaming
- UI state updates

### How It Works

Agents can either emit AG-UI events directly or use adapters to convert outputs into AG-UI format. Clients subscribe via SSE or WebSockets for live interaction.

### Getting Started

```bash
npx create-ag-ui-app
```

### Growth Metrics (within 30 days)

- Integrations with: LangChain, CrewAI, Mastra, AG2, Agno, LlamaIndex
- 3,700+ GitHub stars
- Thousands of developers building interactive agents

### Supported Event Types

```typescript
// AG-UI Event Types
type AGUIEvent =
  | RunStartedEvent
  | RunFinishedEvent
  | TextMessageStartEvent
  | TextMessageContentEvent
  | TextMessageEndEvent
  | ToolCallStartEvent
  | ToolCallArgsEvent
  | ToolCallEndEvent
  | StateDeltaEvent
  | StateSnapshotEvent
  | CustomEvent;
```
