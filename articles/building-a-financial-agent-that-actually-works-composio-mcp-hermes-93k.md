---
title: "Building a Financial Agent That Actually Works: Composio MCP + Hermes"
url: "https://dev.to/composiodev/building-a-financial-agent-that-actually-works-composio-mcp-hermes-93k"
author: "Developer Harsh"
category: "a2a-protocols"
---

# Building a Financial Agent That Actually Works: Composio MCP + Hermes
**Author:** Developer Harsh
**Published:** April 16, 2026

## Overview
Building an autonomous financial analyst agent combining Hermes Agent with Composio MCP for 1000+ integrated tools.

## Key Concepts

### Composio MCP Configuration

```yaml
mcp_servers:
  composio:
    url: "https://connect.composio.dev/mcp"
    headers:
      x-consumer-api-key: "YOUR_API_KEY"
```

### Architecture
- **Hermes Agent**: Open source AI agent with persistent cross-session memory, 40+ built-in tools
- **Composio MCP**: Tooling layer handling OAuth, intelligent tool calling, sandboxed execution

### Use Case: Indian Stock Market Agent
- Conducts 5 screening questions for risk tolerance
- Pulls live market data via Exa Search, NSE/BSE APIs
- Generates hourly reports in Google Docs
- Maintains stock tracking in Google Sheets
- Sends market summaries via Gmail
- Issues urgent buy/sell signal alerts
