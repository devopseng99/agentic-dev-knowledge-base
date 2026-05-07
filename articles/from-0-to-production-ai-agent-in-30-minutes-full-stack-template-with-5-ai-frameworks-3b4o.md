---
title: "From 0 to Production AI Agent in 30 Minutes -- Full-Stack Template with 5 AI Frameworks"
url: "https://dev.to/deenuu1/from-0-to-production-ai-agent-in-30-minutes-full-stack-template-with-5-ai-frameworks-3b4o"
author: "Kacper Wlodarczyk"
category: "full-code-examples"
---

# From 0 to Production AI Agent in 30 Minutes
**Author:** Kacper Wlodarczyk
**Published:** March 17, 2026

## Overview
Full-stack AI agent template generator with 5 AI frameworks, 75+ configuration options, and a web configurator. Automates boilerplate setup for production AI applications.

## Key Concepts

### GitHub Repository
https://github.com/vstorm-co/full-stack-ai-agent-template

### Installation

```bash
pip install fastapi-fullstack
fastapi-fullstack create my_ai_app \
  --preset ai-agent \
  --ai-framework pydantic_ai \
  --frontend nextjs
```

### Pydantic AI Agent Example

```python
from pydantic_ai import Agent, RunContext
from dataclasses import dataclass

@dataclass
class Deps:
    user_id: str | None = None
    db: AsyncSession | None = None

agent = Agent[Deps, str](
    model="openai:gpt-4o-mini",
    system_prompt="You are a helpful assistant.",
)

@agent.tool
async def search_database(ctx: RunContext[Deps], query: str) -> list[dict]:
    """Search the database for relevant information."""
```

### WebSocket Endpoint

```python
@router.websocket("/ws")
async def agent_ws(websocket: WebSocket):
    await websocket.accept()

    async for event in agent.stream(user_input):
        await websocket.send_json({
            "type": "text_delta",
            "content": event.content
        })
```

### Tool Addition Pattern

```python
@agent.tool
async def get_weather(ctx: RunContext[Deps], city: str) -> str:
    """Get current weather for a city."""
    async with httpx.AsyncClient() as client:
        resp = await client.get(f"https://api.weather.com/{city}")
        return resp.json()["summary"]
```

### Supported AI Frameworks
1. Pydantic AI (with Logfire)
2. LangChain (with LangSmith)
3. LangGraph (with LangSmith)
4. CrewAI (with LangSmith)
5. DeepAgents (with LangSmith)

### Generated Project Includes
- FastAPI backend with async PostgreSQL
- JWT authentication with user management
- Conversation persistence to database
- Redis caching and sessions
- Next.js 15 frontend with React 19 and Tailwind CSS v4
- Docker Compose configuration
- GitHub Actions CI/CD pipeline
- Logfire observability integration

### Web Configurator
https://oss.vstorm.co/full-stack-ai-agent-template/configurator/
