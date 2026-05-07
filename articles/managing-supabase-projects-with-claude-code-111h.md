---
title: "Managing Supabase Projects with Claude Code"
url: "https://dev.to/composiodev/managing-supabase-projects-with-claude-code-111h"
author: "Rohith Singh"
category: "ai-agent-supabase"
---

# Managing Supabase Projects with Claude Code

**Author:** Rohith Singh (Composio)
**Published:** August 8, 2025

## Overview

Explains how to manage Supabase database projects using Claude Code integrated with Composio's Model Context Protocol (MCP), enabling natural language database operations instead of navigating dashboards.

## Key Concepts

### What Supabase MCP Enables

Claude can create or update tables, create or update functions, update SSO providers, and access additional capabilities through Composio's documentation.

### Configuration

**Method 1 - Direct Setup:**
```shell
npx @composio/mcp@latest setup "https://mcp.composio.dev/partner/composio/supabase/mcp?customerId=[your-customer-id]" "supabase-b3c6o7-81" --client claude
```

**Method 2 - Composio Dashboard:**
Navigate to MCP Configs, create MCP Config, select Supabase, choose authentication, and authorize permissions.

### Usage Examples

- "Create a new Supabase project called `blog-backend`"
- "Add a new table called `comments` with columns `id`, `text`, and `user_id`"
- "Fetch all rows from the `comments` table"

### Key Insight

Always pass the tool you want to use for a task to optimize token usage and prevent Claude from guessing the appropriate tool.
