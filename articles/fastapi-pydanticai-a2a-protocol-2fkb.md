---
title: "FastAPI + PydanticAI + a2a-protocol"
url: "https://dev.to/izzyjosh/fastapi-pydanticai-a2a-protocol-2fkb"
author: "Joseph Joshua"
category: "ai-agents"
---

# FastAPI + PydanticAI + a2a-protocol

**Author:** Joseph Joshua
**Published:** November 3, 2025
**Tags:** #agents #gemini #ai #python

## Overview

This article provides a complete implementation of an AI agent combining language models with tools for real-world interaction. The example demonstrates "a specialized assistant that helps users correct grammar, spelling, and phrasing mistakes."

## Implementation Structure

### 1. Agent Implementation (`agent.py`)

The `GrammarAgent` class uses PydanticAI with Google's Gemini model:

```python
from pydantic_ai import Agent
from pydantic_ai.models.gemini import GeminiModel
from pydantic_ai.providers.google import GoogleProvider

class GrammarAgent:
    SYSTEM_INSTRUCTIONS = (
        "You are a specialized assistant that helps users correct grammar, "
        "spelling, and phrasing mistakes in text"
    )

    def __init__(self):
        provider = GoogleProvider(api_key=os.getenv("GOOGLE_API_KEY"))
        model = GoogleModel("gemini-2.0-flash", provider=provider)
        self.agent = Agent(
            model=model,
            output_type=GrammarResponse,
            system_prompt=self.SYSTEM_INSTRUCTIONS
        )

    async def run(self, message: A2AMessage, context_id=None, task_id=None):
        # Process message and return TaskResult
```

### 2. FastAPI Endpoint (`main.py`)

Exposes the agent via JSON-RPC 2.0 protocol:

```python
from fastapi import FastAPI
import uvicorn

app = FastAPI(title="Grammar Agent", version="1.0.0")

@app.post("/a2a/grammar-check")
async def grammar_check(request: Request):
    body = await request.json()
    # Validates JSON-RPC format
    # Routes to message/send or execute methods
    # Returns JSONRPCResponse with TaskResult
```

### 3. Pydantic Models (`models.py`)

Validates data structures:

```python
class GrammarResponse(BaseModel):
    response: str
    explanation: str

class A2AMessage(BaseModel):
    kind: Literal["message"] = "message"
    role: Literal["user", "agent", "system"]
    parts: List[MessagePart]

class TaskResult(BaseModel):
    id: str
    contextId: str
    status: TaskStatus
    history: List[A2AMessage] = []
```

## Setup

Create `.env` file:
```
GOOGLE_API_KEY=YOUR_API_KEY
```

Run the server:
```bash
python main.py
```

## Key Components

- **PydanticAI:** Framework for building AI agents with type safety
- **Gemini 2.0 Flash:** LLM providing grammar correction capabilities
- **JSON-RPC 2.0:** Communication protocol with `message/send` and `execute` methods
- **Task Management:** Tracks context and conversation history with unique IDs

## Summary

The implementation demonstrates agent architecture combining prompt engineering, structured validation, and async API design for grammar correction workflows.
