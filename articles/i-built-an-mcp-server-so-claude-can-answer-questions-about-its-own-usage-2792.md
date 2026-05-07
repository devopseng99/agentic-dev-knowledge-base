---
title: "I Built an MCP Server So Claude Can Answer Questions About Its Own Usage"
url: "https://dev.to/yurukusa/i-built-an-mcp-server-so-claude-can-answer-questions-about-its-own-usage-2792"
author: "Yurukusa"
category: "claude-mcp-server"
---

# I Built an MCP Server So Claude Can Answer Questions About Its Own Usage

**Author:** Yurukusa
**Published:** April 3, 2026

## Overview

Introduces cc-mcp, an MCP server enabling Claude to access real-time Claude Code usage statistics. Part of a 27-tool cc-toolkit collection following the loop: Track, Understand, Predict, Act, Ask.

## Key Concepts

### Configuration

```json
{
  "mcpServers": {
    "cc-toolkit": {
      "command": "npx",
      "args": ["@yurukusa/cc-mcp"]
    }
  }
}
```

### Four Available Tools

1. **cc_usage_summary** -- Today/7-day/month-to-date totals, current streak, autonomy ratio
2. **cc_daily_breakdown** -- Day-by-day activity for last N days with user vs. AI split
3. **cc_project_stats** -- Per-project time breakdown (top 15 by hours)
4. **cc_forecast** -- Month-end projection at current usage pace

### Ghost Days

Days where AI sub-agents ran Claude Code autonomously while the user had zero interactive sessions. Helps track unsupervised AI pipeline activity.

### Technical Implementation

The server is a Node.js ES module using `@modelcontextprotocol/sdk`. Each tool calls `cc-agent-load --json` as a subprocess, parsing output and returning both plain text and structured JSON. All computation occurs locally with no telemetry.

### Setup

```bash
npm install -g cc-agent-load
npx @yurukusa/cc-mcp
```

### Key Differentiation

Running `cc-agent-load` produces terminal output consumed once. Via MCP, Claude maintains context within sessions, enabling proactive observations and follow-up questions without re-running tools.
