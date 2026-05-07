---
title: "In-depth Research Report on Google Agent2Agent (A2A) Protocol"
url: "https://dev.to/justin3go/in-depth-research-report-on-google-agent2agent-a2a-protocol-2m2a"
author: "Justin3go"
category: "cloud-agents"
---

# In-depth Research Report on Google Agent2Agent (A2A) Protocol
**Author:** Justin3go
**Published:** April 10, 2025

## Overview
Comprehensive research report on Google's A2A protocol covering technical architecture (HTTP+JSON, Agent Cards, Task Flow), design goals, relationship to MCP, application scenarios (enterprise automation, multi-agent collaboration, intelligent assistants), and industry impact on the AI ecosystem.

## Key Concepts

### Core Architecture
1. **Agent Card** (`/.well-known/agent.json`): JSON capability manifest listing endpoints, skills, authentication
2. **Role Model**: Server provides API interfaces (`tasks/send`); Client makes HTTP calls
3. **Task Flow**: Lifecycle: submitted -> working -> (input-required) -> completed/failed
4. **Communication**: HTTP + JSON-RPC with SSE for real-time push (`tasks/sendSubscribe`), webhook callbacks
5. **UX Negotiation**: Pre-negotiates interaction forms (text/voice/forms)

### A2A vs MCP
- MCP: Single agent using tools and accessing external context ("a wrench enabling agents to use tools")
- A2A: Dialogue between agents ("the dialogue between mechanics")
- Together they strengthen the autonomous agent ecosystem

### Framework Independence
- Works with any LLM framework (LangChain, LangGraph, ADK, CrewAI, Genkit)
- Compatible with "opaque" agents that don't expose internal reasoning
- Open-sourced under Apache 2.0, governed by 50+ participating companies

### Application Scenarios
- Enterprise process automation (asset management requesting procurement)
- Multi-agent recruitment (screening, scheduling, candidate inquiry agents)
- Intelligent personal assistants (coordinating flight, trip, translation agents)
- Cross-departmental agent collaboration

### Industry Impact
- First open multi-agent communication protocol standard
- Competitors (Microsoft, OpenAI, IBM) may need to support A2A
- Aligns with shift from "single agent + tool" to "multi-agent collaboration"
