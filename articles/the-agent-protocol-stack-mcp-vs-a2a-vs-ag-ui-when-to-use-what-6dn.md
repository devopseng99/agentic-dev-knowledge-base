---
title: "The Agent Protocol Stack: MCP vs A2A vs AG-UI - When to Use What"
url: "https://dev.to/jubinsoni/the-agent-protocol-stack-mcp-vs-a2a-vs-ag-ui-when-to-use-what-6dn"
author: "Jubin Soni"
category: "agent-ui-frameworks"
---

# The Agent Protocol Stack: MCP vs A2A vs AG-UI - When to Use What
**Author:** Jubin Soni
**Published:** April 12, 2026

## Overview
A comprehensive guide comparing MCP, A2A, and AG-UI as complementary layered protocols in the AI agent architecture, analogous to TCP/HTTP/HTML.

## Key Concepts

### Protocol Overview
| Protocol | Creator | Connects | Purpose |
|----------|---------|----------|---------|
| MCP | Anthropic | Agent to Tools & Data | How does my agent use tools? |
| A2A | Google/Linux Foundation | Agent to Agent | How do agents talk to each other? |
| AG-UI | CopilotKit | Agent to User Interface | How does my agent talk to the user? |

### MCP: The Tool Layer
- Uses client-server architecture over JSON-RPC 2.0
- Exposes tools (functions), resources (read-only data), and prompts (templates)
- Transports: stdio (local) and Streamable HTTP (production)

### A2A: The Agent Collaboration Layer
- Client-server model over HTTP using JSON-RPC 2.0 (optionally gRPC as of v0.3)
- Agent Cards at `/.well-known/agent.json` for discovery
- Tasks with lifecycles: submitted, working, completed/failed/canceled

### AG-UI: The User Interface Layer
- Event-based protocol with ~16 specific event types
- Lifecycle Events: RUN_STARTED, RUN_FINISHED, RUN_ERROR
- Text Message Events for token-by-token streaming
- Tool Events for visibility into tool usage
- State Deltas for incremental UI changes
- Interrupts for pausing execution for user approval

### Decision Framework
1. Agent needs external tools/data? Use MCP
2. Agent needs to collaborate with other agents? Use A2A
3. Agent needs real-time user communication? Use AG-UI

### How They Fit Together
1. User asks question in frontend
2. AG-UI streams request to supervisor agent
3. Supervisor uses MCP for direct tool calls
4. For complex tasks, supervisor uses A2A to delegate to specialists
5. Results flow back: A2A -> supervisor -> AG-UI -> user

### AWS Support
All three protocols supported natively on AWS Bedrock AgentCore Runtime with IAM SigV4 or OAuth 2.0 auth.
