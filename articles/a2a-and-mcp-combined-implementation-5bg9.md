---
title: "A2A and MCP Combined Implementation"
url: "https://dev.to/heetvekariya/a2a-and-mcp-combined-implementation-5bg9"
author: "HeetVekariya"
category: "a2a-protocols"
---

# A2A and MCP Combined Implementation
**Author:** HeetVekariya
**Published:** May 25, 2025

## Overview
Demonstrates integrating A2A and MCP in a unified system with a Host Agent coordinating specialized agents that query MCP servers for real-world data.

## Key Concepts

### Architecture
- **MCP Servers**: Search (Serper.dev), Stock (FinnHub API)
- **Agents**: Host Agent (coordinator), Stock Report Agent, Google Search Agent

### Setup

```bash
# 1. Stock MCP Server
uv run mcp_server/sse/stocks_server.py

# 2. Stock Report Agent
uv run a2a_servers/agent_servers/stock_report_agent_server.py

# 3. Google Search Agent
uv run a2a_servers/agent_servers/google_search_agent_server.py

# 4. Host Agent
uv run a2a_servers/agent_servers/host_agent_server.py
```

### Workflow
1. Break down user questions into subtasks
2. Route tasks to specialized agents via A2A
3. Each agent queries MCP servers for real-world data
4. Aggregate results into comprehensive responses

Example: "What is the current stock value of AAPL?" returns real-time price data through the Stock Report Agent querying the FinnHub MCP server.
