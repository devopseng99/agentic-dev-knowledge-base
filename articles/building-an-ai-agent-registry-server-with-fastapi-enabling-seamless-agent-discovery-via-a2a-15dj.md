---
title: "Building an AI Agent Registry Server with FastAPI: Enabling Seamless Agent Discovery via A2A Protocol"
url: "https://dev.to/sreeni5018/building-an-ai-agent-registry-server-with-fastapi-enabling-seamless-agent-discovery-via-a2a-15dj"
author: "Seenivasa Ramadurai"
category: "ai-agent-fastapi"
---

# Building an AI Agent Registry Server with FastAPI: Enabling Seamless Agent Discovery via A2A Protocol

**Author:** Seenivasa Ramadurai
**Published:** May 22, 2025

## Overview
Explores how autonomous AI agents can discover and collaborate using the Agent2Agent (A2A) Protocol, an open standard for inter-agent communication. Implements a FastAPI-based Agent Registry Server.

## Code Examples

### FastAPI Registry Server (Python)

```python
import logging
import uvicorn
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import time
import asyncio
from contextlib import asynccontextmanager
from python_a2a import AgentCard
from python_a2a.discovery import AgentRegistry

class AgentRegistration(BaseModel):
    name: str
    description: str
    url: str
    version: str
    capabilities: dict = {}
    skills: List[dict] = []

class HeartbeatRequest(BaseModel):
    url: str

registry_server = AgentRegistry(
    name="A2A Registry Server",
    description="Registry server for agent discovery"
)

HEARTBEAT_TIMEOUT = 30
CLEANUP_INTERVAL = 10

@asynccontextmanager
async def lifespan(app: FastAPI):
    cleanup_task = asyncio.create_task(cleanup_stale_agents())
    yield
    cleanup_task.cancel()

app = FastAPI(title="A2A Agent Registry Server", lifespan=lifespan)

async def cleanup_stale_agents():
    while True:
        try:
            current_time = time.time()
            agents_to_remove = []
            for url, last_seen in registry_server.last_seen.items():
                if current_time - last_seen > HEARTBEAT_TIMEOUT:
                    agents_to_remove.append(url)
            for url in agents_to_remove:
                registry_server.unregister_agent(url)
        except Exception as e:
            logging.error(f"Error during cleanup: {e}")
        await asyncio.sleep(CLEANUP_INTERVAL)

@app.post("/registry/register", response_model=AgentCard, status_code=201)
async def register_agent(registration: AgentRegistration):
    agent_card = AgentCard(**registration.dict())
    registry_server.register_agent(agent_card)
    return agent_card

@app.get("/registry/agents", response_model=List[AgentCard])
async def list_registered_agents():
    return list(registry_server.get_all_agents())

@app.post("/registry/heartbeat")
async def heartbeat(request: HeartbeatRequest):
    if request.url in registry_server.agents:
        registry_server.last_seen[request.url] = time.time()
        return {"success": True}
    return {"success": False, "error": "Agent not registered"}, 404
```

### Sample A2A Agent (Python)

```python
from python_a2a import AgentCard, A2AServer, run_server, Message, TextContent, MessageRole
from python_a2a.discovery import enable_discovery

class SampleAgent(A2AServer):
    def __init__(self, name, description, url, registry_url):
        agent_card = AgentCard(
            name=name, description=description, url=url,
            version="1.0.0",
            capabilities={"streaming": False, "google_a2a_compatible": True}
        )
        super().__init__(agent_card=agent_card)
        self.registry_url = registry_url

    def handle_message(self, message: Message) -> Message:
        return Message(
            content=TextContent(
                text=f"Hello from {self.agent_card.name}! I received: {message.content.text}"
            ),
            role=MessageRole.AGENT,
            parent_message_id=message.message_id,
        )
```
