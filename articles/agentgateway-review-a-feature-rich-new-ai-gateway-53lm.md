---
title: "Agentgateway Review: A Feature-Rich New AI Gateway"
url: "https://dev.to/spacewander/agentgateway-review-a-feature-rich-new-ai-gateway-53lm"
author: "spacewander"
category: "ai-agent-api-gateway"
---

# Agentgateway Review: A Feature-Rich New AI Gateway

**Author:** spacewander
**Published:** December 2, 2025

## Overview
Review of Solo's Rust-based agentgateway covering MCP support, A2A protocol, LLM proxying, and inference extension support.

## Key Concepts

### MCP Authorization with CEL Expressions

```yaml
mcpAuthorization:
  rules:
  - 'mcp.tool.name == "echo"'
  - 'jwt.sub == "test-user" && mcp.tool.name == "add"'
  - 'mcp.tool.name == "printEnv" && jwt.nested.key == "value"'
```

### Four AI Scenarios
1. **MCP** - Stateful request handling with session management and tool multiplexing
2. **A2A** - Agent card URL rewriting and JSON request parsing for observability
3. **LLM Proxying** - Token-based observability and rate-limiting with SSE support
4. **Inference Extension** - Kubernetes Gateway API integration via gRPC ext_proc

### MCP Multiplexing
When multiple backends exist, sends requests to every backend and rewrites tool names as `${backend_name}_${tool_name}`.

### OpenAPI to MCP
Converts RESTful APIs to MCP tools using OpenAPI specifications automatically.
