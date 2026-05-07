---
title: "Beyond the Hype Part 2: Enter Google's A2A Protocol"
url: "https://dev.to/ramkey982/beyond-the-hype-part-2-enter-googles-a2a-protocol-complementing-mcp-for-agent-collaboration-4fg3"
author: "ram"
category: "agent-collaboration-protocol"
---

# Beyond the Hype Part 2: Enter Google's A2A Protocol

**Author:** ram
**Published:** April 12, 2025

## Overview
Examines A2A as complementary to MCP. MCP standardizes agent-tool interfaces; A2A standardizes agent-agent interfaces. Together they create a two-layer model.

## Key Concepts

### A2A Core Components
1. **Agent Card** - Metadata at `/.well-known/agent.json`
2. **A2A Servers/Clients** - HTTP endpoints understanding the protocol
3. **Tasks** - Work units via `tasks/send` or `tasks/sendSubscribe`
4. **Messages and Parts** - Multi-modal communication (TextPart, FilePart, DataPart)
5. **Artifacts** - Agent output results
6. **Streaming** - SSE via `tasks/sendSubscribe` plus push notifications

### A2A vs MCP
- MCP: agent-to-tool, stateful SSE sessions, direct tool specs
- A2A: agent-to-agent, stateless HTTP with task-centric state, distributed architecture

### Synergy Example
Shop Employee Agent uses MCP for diagnostics/inventory databases, then communicates via A2A with Parts Supplier Agent to coordinate orders.
