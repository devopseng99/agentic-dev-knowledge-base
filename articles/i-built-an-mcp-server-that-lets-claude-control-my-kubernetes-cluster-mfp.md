---
title: "I Built an MCP Server That Lets Claude Control My Kubernetes Cluster"
url: "https://dev.to/vijaya_bollu/i-built-an-mcp-server-that-lets-claude-control-my-kubernetes-cluster-mfp"
author: "Vijaya Rajeev Bollu"
category: "claude-mcp-server"
---

# I Built an MCP Server That Lets Claude Control My Kubernetes Cluster

**Author:** Vijaya Rajeev Bollu
**Published:** April 9, 2026

## Overview

An MCP server enabling Claude Desktop to interact with Kubernetes, AWS, Docker, and Terraform through a unified interface. Claude sends JSON requests to a Python server running locally, which executes commands using local credentials.

## Key Concepts

### Available Tools (14 total)

**Kubernetes:** pod status, failing pods, logs, restart deployment, describe pod
**AWS:** cost report, EC2 instances, CloudWatch alarms, S3 buckets
**Docker:** list containers, container logs, restart container
**Terraform:** run plan, check state

### Setup

```bash
git clone https://github.com/ThinkWithOps/ai-devops-systems-lab.git
cd 03-ai-devops-mcp-server
pip install -r requirements.txt

# Test with mock data
KUBE_MOCK_MODE=true python -m pytest tests/ -v
```

### Key Learnings

1. **Tool descriptions drive behavior** -- Changing "Get pods" to "List only pods in Failed, CrashLoopBackOff, OOMKilled, or Error state" ensured reliable invocation

2. **Parallel execution emerges naturally** -- Claude independently parallelized tool calls based on question breadth without explicit server configuration

3. **Async handling is critical** -- Blocking SDK calls required wrapping in `asyncio.to_thread()` to prevent event loop stalling

4. **Error isolation matters** -- Module-level error handling could crash the entire server; tool-level catching preserved functionality

5. **MCP protocol simplicity** -- Implementation requires only `list_tools()` and `call_tool()` functions -- approximately 20 lines of Python per tool

### Architecture

The server operates locally, communicating with Claude Desktop over standard input/output. Claude never connects directly to infrastructure -- it sends JSON requests to the Python server, which executes commands using `~/.aws/credentials` and `~/.kube/config`.

### Limitations

- Single-instance scope (t3.small EC2)
- Read-focused; only restart_deployment enables writes
- Diagnostic, not remedial
- Local credential dependency
- No network security (localhost only)
