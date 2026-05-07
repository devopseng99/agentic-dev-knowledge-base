---
title: "Practical Guide to MCP (Model Context Protocol) in Python"
url: https://dev.to/m_sea_bass/practical-guide-to-mcp-model-context-protocol-in-python-ijd
author: M Sea Bass
category: mcp
---

# Practical Guide to MCP (Model Context Protocol) in Python

**Author:** M Sea Bass
**Published:** November 3, 2025
**Tags:** #llm #mcp

---

## Introduction

The article introduces MCP as "a protocol that connects LLMs with external tools" and provides practical implementation examples. Full source code is available at: https://github.com/M6saw0/mcp-client-sample

---

## Core Concepts

MCP offers three primary capabilities:
- **Tool**: Execute external functionality via function calls
- **Resource**: Provide data or information (static or dynamic)
- **Prompt**: Provide prompt templates for LLMs

Two transport modes are supported:
- **stdio**: Same-process communication
- **streamable-http**: Network-based communication

---

## Building a stdio Server

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP(name="FastMCP Demo Server")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two integers."""
    return a + b

@mcp.resource("time://{zone}")
def get_time(zone: str) -> str:
    """Return ISO 8601 timestamp."""
    from datetime import datetime, timezone
    now = datetime.now(timezone.utc)
    return now.isoformat() if zone.lower() == "utc" else now.astimezone().isoformat()

@mcp.resource("info://server")
def get_server_info() -> str:
    """Return server metadata."""
    return "FastMCP demo server"

@mcp.prompt()
def greet_user(name: str, tone: str = "friendly") -> str:
    """Generate a greeting instruction."""
    return f"Craft a {tone} greeting addressed to {name}."

if __name__ == "__main__":
    mcp.run(transport="stdio")
```

---

## Async Tools with Progress Reporting

```python
from typing import Annotated
from mcp.server.fastmcp import Context, FastMCP
from mcp.server.session import ServerSession
import asyncio

@mcp.tool()
async def countdown(
    start: int,
    ctx: Annotated[Context[ServerSession, None], "Injected by FastMCP"],
) -> list[int]:
    """Count down from start to zero."""
    sequence = []
    for step, value in enumerate(range(start, -1, -1), start=1):
        await ctx.report_progress(
            progress=step,
            total=start + 1,
            message=f"Counting value {value}",
        )
        sequence.append(value)
        await asyncio.sleep(0.2)
    return sequence
```

---

## Building a stdio Client

```python
import asyncio
from pathlib import Path
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def main():
    server_path = Path(__file__).with_name("server.py")
    server_params = StdioServerParameters(command="python", args=[str(server_path)])

    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()

            tools = await session.list_tools()
            print("Available tools:", [tool.name for tool in tools.tools])

            result = await session.call_tool("add", arguments={"a": 2, "b": 5})
            print("add result:", result.content)

            resource = await session.read_resource("time://local")
            print("time://local:", resource.contents)

            prompt = await session.get_prompt("greet_user", arguments={"name": "Alice"})
            print("prompt:", prompt.messages)

asyncio.run(main())
```

**Progress callback example:**

```python
async def on_progress(progress: float, total: float | None, message: str | None) -> None:
    print(f"{progress}/{total or 0} - {message or ''}")

result = await session.call_tool(
    "countdown",
    arguments={"start": 3},
    progress_callback=on_progress,
)
```

---

## Building a streamable-http Server

Conversion requires minimal changes:

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP(
    name="FastMCP StreamableHTTP Demo",
    host="127.0.0.1",
    port=8765,
)

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two integers."""
    return a + b

if __name__ == "__main__":
    mcp.run(transport="streamable-http")
```

---

## Building a streamable-http Client

```python
import asyncio
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client

STREAMABLE_HTTP_URL = "http://127.0.0.1:8765/mcp"

async def main():
    async with streamablehttp_client(STREAMABLE_HTTP_URL) as (read, write, get_session_id):
        async with ClientSession(read, write) as session:
            await session.initialize()

            if (session_id := get_session_id()) is not None:
                print("Session ID:", session_id)

            tools = await session.list_tools()
            print("Available tools:", [tool.name for tool in tools.tools])

            result = await session.call_tool("add", arguments={"a": 2, "b": 5})
            print("add result:", result.content)

asyncio.run(main())
```

---

## Managing Multiple Servers

Key implementation points for `MultiServerClient`:
- `__init__`: Register servers (stdio/http)
- `connect()`: Establish connections to registered servers
- `_ensure_session(name)`: Check for a session and connect if missing
- `_connect(name)`: Entry point to create a session
- `session(name)`: Context manager to retrieve a retained session
- `list_tools()`: Enumerate tools from all servers
- `call_tool(server, tool, arguments)`: Delegate execution
- `close()`: Safely terminate all sessions

---

## Using MCP with Generative AI

### Schema Conversion

**Responses API format:**
```json
{
  "type": "function",
  "name": "server__tool",
  "description": "...",
  "parameters": { "type": "object", "properties": {"a": {"type": "integer"}}, "required": ["a"], "additionalProperties": false },
  "strict": true
}
```

**Chat Completions API format:**
```json
{
  "type": "function",
  "function": {
    "name": "server__tool",
    "description": "...",
    "parameters": { "type": "object", "properties": {"a": {"type": "integer"}}, "required": ["a"] }
  },
  "strict": true
}
```

### Key Utilities

- `mcp_tool_to_responses_schema()`: Convert MCP to Responses format
- `mcp_tool_to_chat_schema()`: Convert MCP to Chat Completions format
- `function_to_responses_tool()` / `build_responses_toolkit()`: Python functions to schema
- `function_to_chat_tool()` / `build_chat_toolkit()`: Python functions to Chat format
- `MultiServerClient.get_tool_details()`: Aggregate metadata across servers

---

## Key Takeaways

1. MCP enables three capabilities: tools, resources, and prompts
2. stdio handles same-process communication; streamable-http enables network distribution
3. Both server and client implementations are straightforward
4. Multiple servers can be centrally managed
5. Dynamic schema conversion allows integration with generative AI systems

For complete implementation details, see the [project repository](https://github.com/M6saw0/mcp-client-sample).
