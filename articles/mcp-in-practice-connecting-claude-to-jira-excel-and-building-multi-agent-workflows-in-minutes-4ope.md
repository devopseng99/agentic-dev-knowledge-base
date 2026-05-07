---
title: "MCP in Practice: Connecting Claude to Jira, Excel, and Building Multi-Agent Workflows"
url: "https://dev.to/software_mvp-factory/mcp-in-practice-connecting-claude-to-jira-excel-and-building-multi-agent-workflows-in-minutes-4ope"
author: "SoftwareDevs mvpfactory.io"
category: "a2a-protocols"
---

# MCP in Practice: Claude to Jira
**Author:** SoftwareDevs mvpfactory.io
**Published:** March 16, 2026

## Overview
Connecting Claude to Jira via MCP for sprint analytics without custom integration code.

## Key Concepts

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-atlassian"],
      "env": {
        "JIRA_BASE_URL": "https://yourteam.atlassian.net",
        "JIRA_API_TOKEN": "",
        "JIRA_USER_EMAIL": "you@company.com"
      }
    }
  }
}
```

"Collect -> analyze -> export" pattern. Gotchas: rate limiting, context window saturation, token storage security.
