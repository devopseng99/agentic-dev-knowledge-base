---
title: "OpenAI Agents SDK: Building Real-World MCP Agents with Composio"
url: "https://dev.to/composiodev/openai-agents-sdk-a-step-by-step-guide-to-building-real-world-mcp-agents-with-composio-4f92"
author: "Aakash R"
category: "a2a-protocols"
---

# OpenAI Agents SDK: Building MCP Agents with Composio
**Author:** Aakash R
**Published:** May 5, 2025

## Overview
Building AI agents using OpenAI's Agents SDK integrated with Composio's MCP platform for automating tasks across GitHub, Notion, and other services.

## Key Concepts

### OpenAI Agents SDK Components
- **Agent class**: name, instructions, tools, handoffs
- **Tools**: External functions with schemas
- **Runner**: Async/streaming execution
- **Tracing**: Monitoring and feedback

### Composio MCP
100+ pre-integrated tools exposed as MCP servers with built-in schemas, execution endpoints, and secure OAuth authentication. No manual API wrapping required.

### Setup

```bash
pip install openai-agents python-dotenv
```

Configure `.env` with OpenAI API key, retrieve MCP server URLs from mcp.composio.dev, create agent with MCPServerSse and Runner.
