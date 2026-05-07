---
title: "Building AI Agents with Google ADK, FastAPI, and MCP"
url: "https://dev.to/timtech4u/building-ai-agents-with-google-adk-fastapi-and-mcp-26h7"
author: "Timothy Olaleke"
category: "ai-agent-fastapi"
---

# Building AI Agents with Google ADK, FastAPI, and MCP

**Author:** Timothy Olaleke
**Published:** April 14, 2025

## Overview
Demonstrates integrating Google's Agent Development Kit (ADK) with FastAPI and the Model Context Protocol (MCP). Three operational modes from identical source code: standalone CLI agent, web-accessible REST service, or MCP-compatible tool provider.

## Code Examples

### Installation

```bash
pip install google-adk python-dotenv
pip install fastapi "uvicorn[standard]" sqlalchemy
pip install mcp
```

### Agent Definition (Python)

```python
root_agent = Agent(
    name="weather_time_agent",
    model="gemini-1.5-flash",
    description="Agent providing weather and time information",
    instruction="Help users with time and weather for various cities",
    tools=[get_weather, get_current_time]
)
```

### Multi-Mode Execution

```bash
python api.py --mode mcp  # Run as MCP server
python api.py --mode web  # Run as FastAPI (default)
```

The FastAPI server runs on port 9999 with the ADK Web UI accessible at http://localhost:9999/dev-ui.
