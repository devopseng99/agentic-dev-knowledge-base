---
title: "Building Your First Agentic AI: Complete Guide to MCP + Ollama Tool Calling"
url: "https://dev.to/ajitkumar/building-your-first-agentic-ai-complete-guide-to-mcp-ollama-tool-calling-2o8g"
author: "Ajit Kumar"
category: "ai-agents-local-llm"
---

# Building Your First Agentic AI: Complete Guide to MCP + Ollama Tool Calling

**Author:** Ajit Kumar
**Published:** December 12, 2025

## Overview

This comprehensive tutorial teaches developers how to create AI agents that understand natural language, decide which tools to use, execute functions automatically, and return intelligent responses—all running locally without API keys or cloud costs.

## Key Concepts Explained

### Ollama
"Ollama is like Docker, but for AI models." It enables downloading and running AI models locally on your machine without internet connectivity or API dependencies.

### Tool Calling (Function Calling)
Tool calling allows AI models to recognize when they need tools, select appropriate ones, provide correct parameters, and interpret results. For example, using a calculator tool guarantees mathematical accuracy rather than approximation.

### MCP (Model Context Protocol)
MCP functions as a standardized interface for AI models to connect with tools and data sources, similar to USB-C standardization. FastMCP simplifies MCP server implementation in Python.

## Architecture

The system comprises three components:
1. **Ollama** — The AI brain running locally
2. **Python Client** — The orchestrator managing requests
3. **FastMCP Server** — Hosts available tools

The request flow: user question -> Python client -> Ollama (with available tools) -> tool selection -> MCP execution -> result interpretation -> response generation.

## Installation Steps

### Ollama Setup

**Linux:**
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

**macOS:**
```bash
brew install ollama
```

**Verification:**
```bash
ollama --version
```

**Start Server:**
```bash
ollama serve
```

**Pull Model (new terminal):**
```bash
ollama pull llama3.2
```

### Project Configuration

```bash
mkdir mcp-ollama-tutorial
cd mcp-ollama-tutorial
python -m venv myenv
source myenv/bin/activate  # Linux/Mac
pip install fastmcp ollama requests
```

## Supported Models

**Tools Supported:** llama3.2, llama3.1, mistral, qwen2.5

**Tools Not Supported:** codellama, llama2, phi (returns error: "does not support tools")

## MCP Server Implementation

Create `mcp_server.py`:

```python
from fastmcp import FastMCP

mcp = FastMCP("My First MCP Server")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two numbers together"""
    return a + b

@mcp.tool()
def greet(name: str) -> str:
    """Greet someone by name"""
    return f"Hello, {name}! Welcome!"

@mcp.tool()
def multiply(a: float, b: float) -> float:
    """Multiply two numbers"""
    return a * b

@mcp.tool()
def get_time() -> str:
    """Get the current time"""
    from datetime import datetime
    return datetime.now().strftime("%I:%M %p")

if __name__ == "__main__":
    mcp.run(transport="sse", port=8080)
```

**Key Elements:**
- `@mcp.tool()` decorator registers functions as callable tools
- Type hints inform the AI about expected parameters
- Docstrings provide descriptions the AI reads
- FastMCP automatically exposes functions via HTTP

**Start Server:**
```bash
python mcp_server.py
```

Expected output: "INFO: Uvicorn running on http://127.0.0.1:8080"

## Ollama Client Implementation

Create `client_ollama.py`:

```python
import json
import ollama
from fastmcp import Client as MCPClient
import asyncio
import sys

OLLAMA_MODEL = "llama3.2"
MCP_SERVER_URL = "http://127.0.0.1:8080/mcp"

async def load_mcp_tools():
    """Connect to MCP server and discover available tools"""
    try:
        async with MCPClient(MCP_SERVER_URL) as mcp:
            tools_list = await mcp.list_tools()

            ollama_tools = []
            for tool in tools_list:
                ollama_tools.append({
                    "type": "function",
                    "function": {
                        "name": tool.name,
                        "description": tool.description,
                        "parameters": tool.inputSchema,
                    },
                })
            return ollama_tools
    except Exception as e:
        print(f"ERROR connecting to MCP server: {e}\n")
        print("Make sure the server is running: python mcp_server.py")
        sys.exit(1)

async def execute_tool(tool_name: str, arguments: dict):
    """Call a tool on the MCP server"""
    try:
        async with MCPClient(MCP_SERVER_URL) as mcp:
            result = await mcp.call_tool(tool_name, arguments)
            return result
    except Exception as e:
        print(f"ERROR executing tool {tool_name}: {e}")
        return {"error": str(e)}

async def main():
    print("Loading MCP tools...")
    tools = await load_mcp_tools()
    print(f"Loaded {len(tools)} tools:")
    for tool in tools:
        print(f" - {tool['function']['name']}: {tool['function']['description']}")
    print()

    user_msg = "Please greet John and then add 150 + 75."
    print(f"User: {user_msg}\n")

    try:
        response = ollama.chat(
            model=OLLAMA_MODEL,
            messages=[{"role": "user", "content": user_msg}],
            tools=tools,
            stream=False,
        )
    except Exception as e:
        print(f"ERROR calling Ollama: {e}\n")
        print("Make sure:\n 1. Ollama is running (ollama serve)")
        print(f" 2. Model is installed (ollama pull {OLLAMA_MODEL})")
        sys.exit(1)

    if not response.get("message", {}).get("tool_calls"):
        print("AI answered directly (no tools needed):")
        print(response["message"]["content"])
        return

    messages = [
        {"role": "user", "content": user_msg},
        response["message"]
    ]

    for tool_call in response["message"]["tool_calls"]:
        tool_name = tool_call["function"]["name"]
        args = tool_call["function"]["arguments"]

        if isinstance(args, str):
            args = json.loads(args)

        print(f"Tool Call: {tool_name}({args})")
        result = await execute_tool(tool_name, args)
        print(f"Result: {result}\n")

        messages.append({
            "role": "tool",
            "content": json.dumps(result),
            "name": tool_name,
        })

    final_response = ollama.chat(
        model=OLLAMA_MODEL,
        messages=messages,
        stream=False,
    )

    print(f"AI: {final_response['message']['content']}")

if __name__ == "__main__":
    asyncio.run(main())
```

## Execution Flow

1. Load available tools from MCP server
2. Send user question to Ollama with tool list
3. Ollama decides if tools are needed
4. If yes, client executes tools via MCP
5. Client sends results back to Ollama
6. Ollama generates final response

## Project Ideas Included

1. **Email Assistant** — Manage emails with AI
2. **Personal Knowledge Base** — Smart note-taking
3. **Finance Manager** — Track expenses and budgets
4. **Smart Home Controller** — Control IoT devices
5. **Data Analysis Assistant** — Analyze datasets
6. **Study Assistant** — Flashcards and quizzes

Each includes code snippets, examples, and recommended tech stacks.

## Troubleshooting Common Issues

- **Server connection errors:** "Ensure the MCP server runs on port 8080"
- **Model doesn't support tools:** "Use llama3.2, llama3.1, mistral, or qwen2.5"
- **Ollama not found:** "Verify installation with `ollama --version`"
- **Tool execution fails:** "Check parameter types match function signatures"
- **Slow responses:** "llama3.2 is fastest; llama3.1 more accurate"

## Key Takeaways

This guide demonstrates building functional AI agents locally without cloud dependencies. The combination of Ollama, FastMCP, and Python creates extensible systems capable of reasoning about tool selection and autonomous action execution—all on personal hardware.
