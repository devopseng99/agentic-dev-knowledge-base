---
title: "The Easiest Way to Set Up MCP with Claude Desktop and Docker Desktop"
url: "https://dev.to/suzuki0430/the-easiest-way-to-set-up-mcp-with-claude-desktop-and-docker-desktop-5o"
author: "Atsushi Suzuki"
category: "claude-mcp-server"
---

# The Easiest Way to Set Up MCP with Claude Desktop and Docker Desktop

**Author:** Atsushi Suzuki
**Published:** March 24, 2025

## Overview

Streamlined guide for integrating Model Context Protocol (MCP) between Claude Desktop and Docker Desktop using the Docker MCP Toolkit extension.

## Key Concepts

### Prerequisites

- Docker Desktop 4.39.0+
- Claude Desktop from https://claude.ai/download

### Setup Process

1. Install "Labs: AI Tools for Devs" (Docker MCP Toolkit) from Docker Desktop Extensions
2. Configure MCP Clients via gear icon, connect Claude Desktop
3. This auto-populates `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "MCP_DOCKER": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "alpine/socat", "STDIO", "TCP:host.docker.internal:8811"]
    }
  }
}
```

4. Restart Claude Desktop, verify "running" status in Settings > Developer tab
5. Add tools (Chrome web scraper, GitHub, Slack, Notion) via Docker extension

### Practical Example

The author demonstrates extracting Toyota stock data from Yahoo! Finance using the Chrome web scraper tool, successfully retrieving current pricing information.

### Key Advantage

Docker isolation eliminates host environment dependencies while simplifying MCP client configuration.
