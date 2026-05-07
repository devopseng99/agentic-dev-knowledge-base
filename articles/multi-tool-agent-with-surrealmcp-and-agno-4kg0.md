---
title: "Multi-tool agent with SurrealMCP and Agno"
url: "https://dev.to/surrealdb/multi-tool-agent-with-surrealmcp-and-agno-4kg0"
author: "Mark Gyles (SurrealDB)"
category: "phidata-agent"
---

# Multi-tool agent with SurrealMCP and Agno

**Author:** Mark Gyles (SurrealDB)
**Published:** August 28, 2025

## Overview

Demonstrates building a multi-agent system using Agno framework with SurrealMCP (Model Context Protocol for SurrealDB) to research information, structure data, and store it in a database using Claude as the LLM.

## Key Concepts

### Basic Agent with MCP

```python
import asyncio
from textwrap import dedent

from agno.agent import Agent
from agno.models.anthropic import Claude
from agno.tools.mcp import MCPTools
from agno.tools.reasoning import ReasoningTools
from agno.utils.log import log_info
from dotenv import load_dotenv

load_dotenv()

async def run_mcp_agent(message: str):
    mcp_tools = MCPTools(
        command=None, url="http://localhost:8080/mcp", transport="streamable-http"
    )
    await mcp_tools.connect()

    agent = Agent(
        model=Claude(id="claude-sonnet-4-20250514"),
        tools=[mcp_tools],
        description="You are a SurrealDB expert",
        instructions="You are already connected to the DB",
        show_tool_calls=True,
        markdown=True,
    )

    log_info(f"Running agent with message: {message}")
    await agent.aprint_response(
        message,
        stream=True,
        stream_intermediate_steps=True,
        show_full_reasoning=True,
    )
    await mcp_tools.close()

if __name__ == "__main__":
    query = dedent("""\
    Insert Brandon Sanderson's top 10 books in the `books` table, including
    title, year, and page count.
    """)
    asyncio.run(run_mcp_agent(query))
```

### Multi-Tool Agent (Research + Store)

```python
from agno.tools.website import WebsiteTools

async def run_mcp_agent(message: str):
    surrealmcp = MCPTools(
        command=None, url="http://localhost:8080/mcp", transport="streamable-http"
    )
    await surrealmcp.connect()

    instructions = dedent(f"""\
        Based on the user's question: {message}

        Follow these steps:
        1. Search the web for the information required to answer
        2. Extract the main content from the first URL using the read_url tool
        3. Analyze the content and structure it as a JSON list
        4. Think about the name of the table where this data will be stored
        5. Store the JSON in that table using the create tool from MCPTools
        6. Answer with the table name and a summarized answer

        Notes:
        - you are already connected to the DB
    """)

    agent = Agent(
        model=Claude(id="claude-sonnet-4-20250514"),
        tools=[
            surrealmcp,
            search_text,
            WebsiteTools(),
            ReasoningTools(add_instructions=True),
        ],
        description="You are a SurrealDB expert",
        instructions=instructions,
        show_tool_calls=True,
        markdown=True,
    )

    await agent.aprint_response(message, stream=True,
        stream_intermediate_steps=True, show_full_reasoning=True)
    await surrealmcp.close()

if __name__ == "__main__":
    query = "Who are the F1 drivers since the year 2000, including race starts and wins"
    asyncio.run(run_mcp_agent(query))
```

### Running

```bash
uv run main.py
```
