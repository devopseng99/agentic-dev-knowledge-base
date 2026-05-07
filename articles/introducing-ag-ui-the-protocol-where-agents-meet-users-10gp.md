---
title: "Introducing AG-UI: The Protocol Where Agents Meet Users"
url: "https://dev.to/copilotkit/introducing-ag-ui-the-protocol-where-agents-meet-users-10gp"
author: "Nathan Tarbert"
category: "agent-ui-frameworks"
---

# Introducing AG-UI: The Protocol Where Agents Meet Users
**Author:** Nathan Tarbert
**Published:** May 13, 2025

## Overview
AG-UI is the Agent-User Interaction Protocol, a streamlined bridge connecting AI agents to real-world applications. Created by CopilotKit, this open lightweight protocol streams a single sequence of JSON events over standard HTTP or an optional binary channel, enabling seamless real-time communication between AI agents and user interfaces.

## Key Concepts

### What is AG-UI?
AG-UI streams events including messages, tool calls, state patches, and lifecycle signals between agent backends and front-end interfaces, maintaining synchronization. Developers can start within minutes using TypeScript or Python SDKs, compatible with OpenAI, Ollama, LangGraph, or custom code.

### Technical Challenges Addressed
1. **Real-time streaming:** LLMs generate tokens incrementally; UIs require immediate access without waiting for complete responses.
2. **Tool orchestration:** Agents invoke functions, execute code, and call APIs. UIs must display progress, request human approval when needed, and resume operations.
3. **Shared mutable state:** Agents generate evolving plans, tables, and code structures. Differential updates require clear schemas.
4. **Concurrency and cancellation:** Systems need thread IDs, run IDs, and orderly shutdown mechanisms.
5. **Security boundaries:** Streaming demands CORS compliance, authentication tokens, and audit logs.
6. **Framework sprawl:** LangChain, CrewAI, Mastra, AG2, and custom implementations use different dialects.

### The AG-UI Solution
Clients make a single POST request to agent endpoints, then listen to a unified event stream. Each event contains a type (TEXT_MESSAGE_CONTENT, TOOL_CALL_START, STATE_DELTA) with minimal payload. Agents emit events as they occur; UIs respond appropriately.

### Capabilities Enabled
- Interchangeable components: Use CopilotKit's React components with any AG-UI source
- Backend flexibility: Switch between cloud and local models without UI modifications
- Multi-agent coordination: Orchestrate specialized agents through single interfaces
- Enhanced development: Faster building with richer experiences and zero vendor lock-in

AG-UI has gained rapid traction with integrations for LangChain, CrewAI, Mastra, AG2, Agno, and LlamaIndex.
