---
title: "Amazon Q Chat with MCP Agents"
url: "https://dev.to/hashan_perera/amazon-q-chat-with-mcp-agents-2bf6"
author: "Hashan Perera"
category: "aws-agents"
---

# Amazon Q Chat with MCP Agents
**Author:** Hashan Perera
**Published:** May 19, 2025

## Overview
Using Amazon Q Chat with MCP (Model Context Protocol) agents for AWS cloud management tasks. Demonstrates the Cost Analysis MCP Server for analyzing Reserved Instance coverage.

## Key Concepts

### MCP Configuration

Create `~/.aws/amazonq/mcp.json`:

```json
{
  "mcpServers": {
    "awslabs.core-mcp-server": {
      "command": "uvx",
      "args": [
        "awslabs.core-mcp-server@latest"
      ],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "autoApprove": [],
      "disabled": false
    }
  }
}
```

### Popular MCP Agents
- AWS MCP agents: https://awslabs.github.io/mcp/
- Slack MCP Server
- Kubernetes MCP Server

### Example Usage - RI Coverage Analysis

```
Analyze my Amazon RDS Reserved Instance (RI) coverage in us-east-1.
List active RDS instances grouped by instance class.
Show Reserved Instances per class with durations.
Calculate coverage percentage per instance class.
Export results to CSV.
```

Amazon Q executes AWS CLI commands, generates analysis, and produces CSV exports with recommendations.
