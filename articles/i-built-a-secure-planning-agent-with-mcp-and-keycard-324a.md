---
title: "I Built and Authorized a Planning Agent with MCP and Keycard"
url: "https://dev.to/kimmaida/i-built-a-secure-planning-agent-with-mcp-and-keycard-324a"
author: "Kim Maida"
category: "oauth-agents"
---

# I Built and Authorized a Planning Agent with MCP and Keycard
**Author:** Kim Maida
**Published:** March 11, 2026

## Overview
"Plan My Today" daily planning dashboard with AI chatbot aggregating data from Google Calendar, Linear, Gmail, Google Docs, GitHub, Slack via MCP tools. Single Keycard OAuth login handles 7 different OAuth implementations.

## Key Concepts

### Token-Mediating Backend (TMB)
React frontend stores Keycard JWT in sessionStorage. Express backend performs all token exchange work via RFC 8693. Third-party service tokens never reach the browser.

### Task-Scoped Credentials
Multiple Google APIs receive separately scoped ephemeral credentials. Read-only Calendar access differs from read-only Drive access. Token exchange latency (~150-250ms) absorbed by parallel processing.

### Agent Permission Model
- Read freely: All read tools for any data source
- Ask before acting: dismiss-task, restore-dismissed-task, set-task-priority
- Intentionally unavailable: Linear status changes, GitHub actions, email sending

### Security Principles
- Task-scoped credentials (one token per API call)
- Composite identity (user + agent + resource in every request)
- Zero standing access (no cached tokens, no long-lived secrets)
- Delegation chains (every action traces back to the user)
