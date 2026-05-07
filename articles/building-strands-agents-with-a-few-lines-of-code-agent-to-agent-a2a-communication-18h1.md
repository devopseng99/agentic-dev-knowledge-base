---
title: "Building Strands Agents with a few lines of code: Agent-to-Agent (A2A) Communication"
url: "https://dev.to/aws/building-strands-agents-with-a-few-lines-of-code-agent-to-agent-a2a-communication-18h1"
author: "Elizabeth Fuentes L"
category: "aws-agents"
---

# Building Strands Agents with a few lines of code: Agent-to-Agent (A2A) Communication
**Author:** Elizabeth Fuentes L
**Published:** August 7, 2025

## Overview
Introduces Agent-to-Agent (A2A) communication within Strands Agent framework. Demonstrates a three-tier architecture: HR Agent -> Employee Agent -> MCP Server, where agents discover, communicate, and delegate tasks through a standardized protocol. Covers A2AServer, A2AClientToolProvider, and the distinction between A2A (agent-to-agent collaboration) and MCP (agent-to-tool access).

## Key Concepts

### A2A vs MCP
- **MCP:** Connects agents to tools, APIs, resources (structured I/O) -- how agents access capabilities
- **A2A:** Dynamic peer-to-peer communication between agents -- how agents collaborate and delegate

### A2A Architecture Components
- **Primary Agent:** Initiates communication and delegates (manager)
- **Secondary Agent(s):** Receive tasks and respond (specialists)
- **A2A Tool:** Handles protocol details
- **Message Protocol:** Defines format and structure

### A2AServer Configuration
- `agent`: Strands Agent to wrap
- `host`: Hostname (default "0.0.0.0")
- `port`: Port (default 9000)
- `version`: Agent version (default "0.0.1")
- `skills`: Custom skill list (auto-generated from tools by default)

### A2AClientToolProvider
- Discovers and interacts with A2A agents
- `known_agent_urls` parameter specifies discoverable agents

## Code Examples

### Employee Data Module
```python
import random

FIRST_NAMES = ["James", "Mary", "John", "Patricia", "Robert", "Jennifer", "Michael", "Linda", "William", "Elizabeth"]
LAST_NAMES = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"]

SKILLS = {
    "Kotlin", "Java", "Python", "JavaScript", "TypeScript",
    "React", "Angular", "Spring Boot", "AWS", "Docker",
    "Kubernetes", "SQL", "MongoDB", "Git", "CI/CD",
    "Machine Learning", "DevOps", "Node.js", "REST API", "GraphQL"
}

EMPLOYEES = list({
    emp["name"]: emp for emp in [
        {
            "name": f"{random.choice(FIRST_NAMES)} {random.choice(LAST_NAMES)}",
            "skills": random.sample(list(SKILLS), random.randint(2, 5))
        }
        for i in range(100)
    ]}.values())
```

### MCP Server
```python
from mcp.server.fastmcp import FastMCP
from employee_data import SKILLS, EMPLOYEES

mcp = FastMCP("employee-server", stateless_http=True, host="0.0.0.0", port=8002)

@mcp.tool()
def get_skills() -> set[str]:
    """all of the skills that employees may have"""
    return SKILLS

@mcp.tool()
def get_employees_with_skill(skill: str) -> list[dict]:
    """employees that have a specified skill"""
    skill_lower = skill.lower()
    employees_with_skill = [employee for employee in EMPLOYEES if any(s.lower() == skill_lower for s in employee["skills"])]
    if not employees_with_skill:
        raise ValueError(f"No employees have the {skill} skill")
    return employees_with_skill

if __name__ == "__main__":
    mcp.run(transport="streamable-http")
```

### Employee Agent (A2A Server)
```python
import os
from mcp.client.streamable_http import streamablehttp_client
from strands import Agent
from strands.tools.mcp.mcp_client import MCPClient
from strands.multiagent.a2a import A2AServer
from urllib.parse import urlparse
from strands.models.anthropic import AnthropicModel

EMPLOYEE_INFO_URL = "http://localhost:8002/mcp/"
EMPLOYEE_AGENT_URL = "http://localhost:8001/"

employee_mcp_client = MCPClient(lambda: streamablehttp_client(EMPLOYEE_INFO_URL))

model = AnthropicModel(
    client_args={"api_key": "YOUR_API_KEY_HERE"},
    max_tokens=1028,
    model_id="claude-sonnet-4-20250514",
    params={"temperature": 0.7},
)

with employee_mcp_client:
    tools = employee_mcp_client.list_tools_sync()

    employee_agent = Agent(
        model=model,
        name="Employee Agent",
        description="Answers questions about employees",
        tools=tools,
        system_prompt="you must abbreviate employee first names and list all their skills"
    )

    a2a_server = A2AServer(
        agent=employee_agent,
        host=urlparse(EMPLOYEE_AGENT_URL).hostname,
        port=int(urlparse(EMPLOYEE_AGENT_URL).port)
    )

    if __name__ == "__main__":
        a2a_server.serve(host="0.0.0.0", port=8001)
```

### HR Agent (A2A Client via FastAPI)
```python
import os
import uvicorn
from strands import Agent
from strands.models import BedrockModel
from strands_tools.a2a_client import A2AClientToolProvider
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from pydantic import BaseModel

EMPLOYEE_AGENT_URL = "http://localhost:8001/"

app = FastAPI(title="HR Agent API")

class QuestionRequest(BaseModel):
    question: str

@app.get("/health")
def health_check():
    return {"status": "healthy"}

model = AnthropicModel(
    client_args={"api_key": os.getenv("api_key")},
    max_tokens=1028,
    model_id="claude-3-7-sonnet-20250219",
    params={"temperature": 0.3},
)

@app.post("/inquire")
async def ask_agent(request: QuestionRequest):
    async def generate():
        provider = A2AClientToolProvider(known_agent_urls=[EMPLOYEE_AGENT_URL])
        agent = Agent(model=bedrock_model, tools=provider.tools)
        stream_response = agent.stream_async(request.question)
        async for event in stream_response:
            if "data" in event:
                yield event["data"]
    return StreamingResponse(generate(), media_type="text/plain")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

### Setup and Running
```shell
git clone https://github.com/elizabethfuentes12/strands-agent-samples
cd notebook
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

```shell
export api_key='your-anthropic-api-key-here'
python3 strands-a2a-inter-agent/server.py
python employee-agent.py
python hr-agent.py
```

### Test Request
```shell
curl -X POST --location "http://0.0.0.0:8000/inquire" \
-H "Content-Type: application/json" \
-d '{"question": "list employees that have skills related to AI programming"}'
```
