---
title: "Fix MCP Timeouts: Async HandleId Pattern"
url: "https://dev.to/aws/fix-mcp-timeouts-async-handleid-pattern-8ek"
author: "Elizabeth Fuentes L (AWS)"
category: "agent-retry-backoff-pattern"
---

# Fix MCP Timeouts: Async HandleId Pattern

**Author:** Elizabeth Fuentes L (AWS)
**Published:** April 30, 2026

## Overview
MCP tools freeze AI agents when dependent on slow external APIs, producing 424 errors. The async handleId pattern returns immediately with a job ID for polling, reducing response time from 17.8s to 3.7s. Part 3 of "Why AI Agents Fail" series.

## Key Concepts

### Three Failure Modes
1. Slow APIs causing extended waits (poor UX)
2. Failing APIs returning errors after timeout
3. Unresponsive states requiring session restart

### Pattern Selection
- **Direct calls:** Fast tools under 5 seconds
- **Async handleId:** Slow tools over 5 seconds, unpredictable external APIs
- **Retry with backoff:** Intermittent failures, network-dependent operations

## Code Examples

### Problem: Synchronous MCP Tools

```python
from mcp.server import FastMCP
import asyncio

mcp = FastMCP("Timeout Demo Server")

@mcp.tool(description="Fast API - responds in 1 second")
async def fast_api(query: str) -> str:
    await asyncio.sleep(1)
    return f"Fast result for: {query}"

@mcp.tool(description="Slow API - responds in 15 seconds")
async def slow_api(query: str) -> str:
    await asyncio.sleep(15)
    return f"Slow result for: {query}"

@mcp.tool(description="Failing API - returns 424 after delay")
async def failing_api(query: str) -> str:
    await asyncio.sleep(7)
    raise Exception("Failed Dependency: External service unavailable")
```

### Solution: Async HandleId Pattern

```python
import uuid

JOBS = {}

@mcp.tool(description="Start a long-running job, returns immediately with job ID")
async def start_async_job(query: str) -> str:
    job_id = str(uuid.uuid4())[:8]
    JOBS[job_id] = {"status": "processing", "query": query}

    asyncio.create_task(do_work(job_id, query))

    return f"Job started: {job_id}. Use check_job_status to poll for results."

@mcp.tool(description="Check status of a running job")
async def check_job_status(job_id: str) -> str:
    job = JOBS.get(job_id)
    if not job:
        return f"Job {job_id} not found"
    if job["status"] == "completed":
        return f"COMPLETED: {job['result']}"
    return f"PROCESSING: Job {job_id} still running"
```

### Results

| Scenario | Response Time | Experience |
|----------|--------------|------------|
| Fast API (1s) | 3.2s | Good |
| Slow API (15s) | 17.8s | Poor |
| Failing API | 7.7s | Error |
| Async Pattern | 3.7s | Immediate |

### Setup

```shell
git clone https://github.com/aws-samples/sample-why-agents-fail
cd sample-why-agents-fail/stop-ai-agents-wasting-tokens/02-mcp-timeout-demo
uv venv && uv pip install -r requirements.txt
export OPENAI_API_KEY="your-key-here"
uv run python test_mcp_timeout.py
```
