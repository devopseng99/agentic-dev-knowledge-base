---
title: "I'm Building My Own Coding Agent Harness (And It's Pretty Cool)"
url: "https://dev.to/composiodev/im-building-my-own-coding-agent-harness-and-its-pretty-cool-1lpf"
author: "VK"
category: "a2a-protocols"
---

# Building a Coding Agent Harness
**Author:** VK
**Published:** January 19, 2026

## Overview
A coding agent execution framework running AI-generated code in Docker sandboxes, with Composio ToolRouter for 1000+ tool integrations.

## Key Concepts

### Core Architecture
1. **Workspace** - Fresh directory per run
2. **Docker Sandbox** - Isolated execution with resource limits
3. **Tool Contract** - `list_files()`, `read_file()`, `write_file()`, `run_command()`, `task_complete()`

### Composio ToolRouter Meta-Tools
- `COMPOSIO_SEARCH_TOOLS` - discovers relevant tools
- `COMPOSIO_MULTI_EXECUTE_TOOL` - executes discovered tools
- `COMPOSIO_MANAGE_CONNECTIONS` - handles authentication

### Key Insight
The real bottleneck is not code generation but everything after: running in real environments, capturing errors, installing dependencies. Observable execution loops make agents trustworthy.
