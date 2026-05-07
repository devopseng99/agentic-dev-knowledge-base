---
title: "AI Agent Protocols Every Developer Should Know in 2025"
url: https://dev.to/copilotkit/ai-agent-protocols-every-developer-should-know-in-2025-39m3
author: Anmol Baranwal
category: ai-agents-protocols
---

# The Best Resources for Getting Started with Agents in 2025

**Author:** Anmol Baranwal
**Published:** July 22, 2025
**Source:** DEV Community / CopilotKit

---

## Overview

This comprehensive guide addresses a critical challenge in AI agent development: the lack of standardized protocols that allow agents to function reliably in production environments. The article explores four key protocols transforming the agent ecosystem and curates twelve essential learning resources.

## Key Protocols

### 1. AG-UI - Agent-User Interaction Protocol

**Problem:** Agent backends (LangGraph, CrewAI) each use proprietary stream formats and APIs, requiring complete rewrites when switching frameworks.

**Solution:** AG-UI uses Server-Sent Events to stream 16 standardized JSON event types:
- `TEXT_MESSAGE_CONTENT` for token streaming
- `TOOL_CALL_START` for tool execution visibility
- `STATE_DELTA` for shared state updates
- `AGENT_HANDOFF` for agent transitions

**Setup:**
```bash
npx create-ag-ui-app@latest <framework>
```

Supported frameworks include LangGraph, CrewAI, Mastra, LlamaIndex, and Agno. (5.1k GitHub stars)

### 2. A2A - Agent-to-Agent Interaction Protocol

**Purpose:** Enables agents built on different frameworks to discover capabilities and collaborate securely without exposing internal state.

Uses JSON-RPC over HTTP with SSE for progress streaming. Agents publish JSON Agent Cards containing capabilities and endpoints.

**Installation:**
```bash
pip install a2a-sdk
# or
npm install @a2a-js/sdk
```

Key features: parallel task execution, mid-task input requests, multimodal artifact exchange. (18k+ GitHub stars)

### 3. MCP - Model Context Protocol

Anthropic's standard for providing context and tools to LLMs—essentially "USB-C for AI" integration.

**Architecture:**
- MCP Hosts (Claude Desktop, Cursor, Windsurf)
- MCP Clients (communication bridges)
- MCP Servers (expose capabilities)
- Local/Remote data sources

Benefits standardized tool listing and invocation across platforms without custom wrappers.

### 4. ACP - Agent Communication Protocol

A Linux Foundation standard supporting agent-to-agent, agent-to-human, and agent-to-application communication via REST APIs.

**Setup:**
```bash
uv add acp-sdk
```

Supports multimodal interactions, streaming responses, and async-first task handling. Features Agent Manifests for discovery (similar to A2A's Agent Cards).

---

## Educational Resources

### Repository Highlights

| Resource | Purpose | Stars |
|----------|---------|-------|
| **12-Factor Agents** | Production engineering principles for LLM agents | 8.9k |
| **GenAI Agents** | Implementations from beginner to advanced | 14.5k |
| **Agents Towards Production** | Code-first deployment tutorials | 8.5k |
| **Awesome LLM Apps** | 50+ projects with RAG, multi-agents, MCP | 50k+ |
| **System Prompts** | 7,500+ lines from 15+ real AI products | 67k+ |

### Key Learning Areas Covered

**12-Factor Agents** emphasizes:
- Natural language to structured tool calls
- Prompt ownership (version-controlled, tested)
- Context window optimization
- Unified execution and business state
- Human-in-the-loop interaction patterns
- Stateless agent design for scalability

**Agents Towards Production** includes:
- GPU deployment via RunPod
- Observability with LangSmith
- Multi-agent coordination using A2A
- Security against prompt injection
- Hybrid memory systems with Redis

**GenAI Agents** provides 40+ runnable projects using LangGraph, CrewAI, OpenAI Swarm, and PydanticAI.

**OpenAgents** offers a web-based platform featuring:
- Data Agent (Python/SQL execution)
- Plugins Agent (200+ integrations)
- Web Agent (Chrome automation)

---

## Core Takeaways

1. **Protocols outlast frameworks**: While tools and frameworks change, standardized protocols enable long-term compatibility.

2. **Complementary ecosystem**: MCP handles agent-to-tool connections, A2A manages agent-to-agent communication, and AG-UI bridges human-agent interaction.

3. **Production readiness requires engineering discipline**: Token streaming, state management, human feedback loops, and error recovery demand deliberate architectural choices beyond raw LLM capability.

4. **Shared system prompts reveal patterns**: Studying prompts from production AI systems (v0, Cursor, Devin) illuminates effective instruction design for agentic behavior.

---

**Next Steps:** The article recommends exploring these protocols through hands-on tutorials in the linked repositories, emphasizing that understanding protocol fundamentals provides a stable foundation as the agent development landscape evolves.
