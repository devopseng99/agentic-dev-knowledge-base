---
title: "Building the Ideal AI Agent: From Async Event Streams to Context-Aware State Management"
url: "https://dev.to/louis-sanna/building-the-ideal-ai-agent-from-async-event-streams-to-context-aware-state-management-33"
author: "Louis Sanna"
category: "event-driven-agents"
---

# Building the Ideal AI Agent: From Async Event Streams to Context-Aware State Management

**Author:** Louis Sanna
**Published:** December 12, 2024

## Overview
This article explores creating autonomous AI agents that are fast, interactive, and context-aware. It outlines three core approaches: implementing asynchronous server-sent events for live responses, using context variables for state management, and decoupling logic from network operations.

## Key Concepts

### Architecture Overview
The ideal agent architecture separates three concerns:
- Event-driven communication via SSE
- Context-aware state management using Python's `contextvar`
- Decoupled business logic from network operations

### Asynchronous Event Streaming (SSE)
SSE allows streaming each chunk of the response to the user rather than waiting for completion, creating a more interactive experience with partial responses visible during generation.

### Context-Aware State Management
The solution addresses concurrent request isolation through Python's `contextvars`, described as thread-local storage for async code. This maintains separate state queues for simultaneous requests.

## Implementation

### Environment Setup

```bash
pip install fastapi uvicorn pydantic
```

### Context System (context.py)

```python
import asyncio
import contextvars

chat_context_var = contextvars.ContextVar("chat_context")

def build_chat_context():
    queue = asyncio.Queue()

    async def emit_event(event):
        await queue.put(event)

    async def close():
        await queue.put(None)

    return emit_event, close, queue
```

### Chat Service (chat.py)

```python
from fastapi import FastAPI, APIRouter, Request
from fastapi.responses import StreamingResponse
from context import build_chat_context, chat_context_var
import asyncio

router = APIRouter()

async def process_messages(messages):
    emit_event, _, queue = chat_context_var.get()
    for message in messages:
        await asyncio.sleep(1)
        await emit_event({"content": message})
    await queue.put(None)

@router.post("/api/stream")
async def stream(request: Request):
    emit_event, close, queue = build_chat_context()
    chat_context_var.set((emit_event, close, queue))

    task = asyncio.create_task(process_messages(["Hello", "How are you?", "Goodbye"]))

    async def event_generator():
        while True:
            event = await queue.get()
            if event is None:
                break
            yield f"data: {event}\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")
```

### Running the Service

```bash
uvicorn chat:app --reload
```

### File Structure

```
├── context.py
├── chat.py
└── main.py
```

## Advanced Techniques

1. Use `async def emit_event()` instead of `yield` to avoid issues with multi-function event generation
2. Employ `asyncio.create_task()` for long-running operations without blocking streams
3. Consider WebSockets for bi-directional communication over SSE

## Key Takeaways

- Context-aware agents separate network from agent logic
- SSE enables real-time feedback
- `contextvar` isolates per-request state
- `emit_event()` simplifies updates from any code location
