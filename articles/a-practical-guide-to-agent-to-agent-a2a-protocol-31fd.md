---
title: "A Practical Guide to Agent-to-Agent (A2A) Protocol"
url: https://dev.to/composiodev/a-practical-guide-to-agent-to-agent-a2a-protocol-31fd
author: Developer Harsh
category: a2a-protocol
---

# A Practical Guide to Agent-to-Agent (A2A) Protocol

**Author:** Developer Harsh
**Publication Date:** April 29, 2025
**Originally Published:** composio.dev

## Overview

Google's Agent-to-Agent (A2A) Protocol enables specialized AI agents to communicate directly, delegate tasks, and collaborate as teams. The article notes that "over 50 tech partners—including MongoDB, Atlassian, SAP, PayPal, and Cohere—have already adopted it."

## Key Concepts

### What is A2A?

A2A allows a main agent to function as a project manager coordinating specialist agents. It solves the problem of isolated AI agents by enabling complex multi-agent systems. The protocol is built on five principles:

1. **Simple** – Reuses existing standards (HTTP, JSON-RPC, SSE)
2. **Enterprise Ready** – Built-in auth, security, and monitoring
3. **Async First** – Handles long-running tasks with meaningful updates
4. **Modality Agnostic** – Supports text, audio, video, forms
5. **Opaque Execution** – Agents need not share internal details

### Core Components

- **Agent Cards** – JSON profiles listing agent capabilities and metadata
- **Tasks** – Units of work progressing through stages (submitted, working, completed, failed)
- **Message Structure** – Multimodal content exchange between agents
- **Artifacts** – Structured task outputs ensuring consistency

### A2A + MCP Integration

Model Context Protocol (MCP) complements A2A by connecting agents to tools, APIs, and data sources. The article explains: "A2A coordinates who does what, while MCP ensures each agent can actually do it using the right tools."

## Practical Implementation

The tutorial demonstrates building a browser automation agent using:
- **Google ADK** (Agent Developer Kit)
- **Puppeteer MCP Server** for web automation
- **Gemini 2.0 Flash** LLM model

### Setup Steps

1. Create Python virtual environment with Google ADK
2. Configure `.env` file with API credentials
3. Install Puppeteer MCP server
4. Develop agent code using `LlmAgent` class
5. Connect tools via `MCPToolset`

### Code Architecture

The implementation includes:

```python
async def get_tools_async():
    """Fetch tools from MCP server"""
    tools, exit_stack = await MCPToolset.from_server(
        connection_params=StdioServerParameters(
            command='npx',
            args=["-y", "@modelcontextprotocol/server-puppeteer"]
        )
    )
    return tools, exit_stack
```

Agent creation involves specifying the model, name, detailed instructions, and available tools. The `Runner` class executes async operations and processes events.

## Key Takeaways

- A2A and MCP are complementary but distinct: A2A enables agent coordination while MCP provides tool integration
- Agent Cards function as discoverable profiles allowing dynamic agent selection
- The protocol supports enterprise requirements including authentication, tracing, and monitoring
- Both standards advance toward standardized, automated agent development practices
