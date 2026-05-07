---
title: "Talking to Machines: Building Low-Latency Voice Agents with OpenAI Realtime API"
url: https://dev.to/deepak_mishra_35863517037/talking-to-machines-building-low-latency-voice-agents-with-openai-realtime-api-3c7p
author: Lalit Mishra
category: ai-agents-voice
---

# Talking to Machines: Building Low-Latency Voice Agents with OpenAI Realtime API

**Author:** Lalit Mishra
**Date Published:** February 18, 2026
**Tags:** #python #webrtc #openai #ai

---

## Overview

This article examines how OpenAI's Realtime API represents a fundamental architectural shift from traditional cascading speech-to-text -> LLM -> text-to-speech pipelines toward native speech-to-speech modality, enabling natural conversational interactions with sub-500ms latency.

---

## The Latency Problem

Traditional voice agent pipelines suffer from additive latency across multiple stages:

- **Speech-to-Text:** 200-500ms
- **LLM Processing:** 200ms to 1+ second (Time-to-First-Token variability)
- **Text-to-Speech:** 200-400ms
- **Total Real-Time Latency:** 1.5-3+ seconds

The article notes: "This latency forces users to 'wait their turn,' effectively killing the capability for interruptions or back-and-forth banter."

## Architecture: WebRTC vs WebSocket

Two transport protocols exist:

**WebSocket (Server-Relay):** Client -> Backend -> OpenAI. Provides full control but adds latency through an extra network hop.

**WebRTC (Direct):** Client connects directly to OpenAI's media edge. The Python backend handles only authentication and signaling, removing double-hop latency and leveraging UDP congestion control.

The WebRTC approach is recommended as the superior option for production deployments.

---

## Code Examples

### Ephemeral Token Generation (FastAPI)

```python
import os
import requests
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse

app = FastAPI()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

@app.post("/session")
async def get_realtime_session(request: Request):
    """
    Generates an ephemeral token for the client to connect directly
    to OpenAI's Realtime WebRTC API.
    """
    url = "https://api.openai.com/v1/realtime/sessions"
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "Content-Type": "application/json",
    }

    payload = {
        "model": "gpt-4o-realtime-preview-2024-12-17",
        "voice": "verse",
        "instructions": "You are a helpful assistant. Act as a technical support engineer.",
    }

    try:
        response = requests.post(url, headers=headers, json=payload)
        response.raise_for_status()
        data = response.json()

        return JSONResponse({
            "client_secret": data["client_secret"]["value"],
            "session_id": data["id"]
        })
    except requests.exceptions.RequestException as e:
        print(f"Error fetching session: {e}")
        raise HTTPException(status_code=500, detail="Failed to generate session")
```

### Tool Definition Structure

```python
tools = [
    {
        "type": "function",
        "name": "check_inventory",
        "description": "Checks the stock level of a specific item SKU.",
        "parameters": {
            "type": "object",
            "properties": {
                "sku": {"type": "string", "description": "The product SKU code"},
                "warehouse": {"type": "string", "description": "Warehouse location ID"}
            },
            "required": ["sku"]
        }
    }
]
```

### Backend Tool Execution

```python
@app.post("/tools/check_inventory")
async def check_inventory(sku: str, warehouse: str = "default"):
    # Execute actual DB logic
    stock = db.get_stock(sku, warehouse)
    return {"sku": sku, "quantity": stock, "status": "available"}
```

---

## Production Architecture

The article outlines a three-layer architecture:

1. **Edge (Client):** Handles microphone input, audio playback, WebRTC negotiation with minimal logic
2. **Control Plane (Python Backend):** Manages authentication, session creation, context rehydration, and tool execution
3. **Media Plane (OpenAI):** Managed infrastructure requiring usage monitoring

---

## Session Management

The Realtime API is ephemeral per connection but stateless between connections. Production resilience requires:

- **Transcript Persistence:** Client listens to conversation events and asynchronously pushes to backend database
- **Context Rehydration:** On reconnection, backend injects previous conversation summaries (not full transcripts) to maintain continuity

---

## Performance Metrics

Expected latencies in production:

- **Audio input to output (end-to-end):** ~300-500ms
- **Tool execution round-trip:** Variable (backend dependent)
- **Network jitter:** Primary adversary for quality

The article recommends aggressive caching (Redis) for read-heavy operations and instructing the model to emit filler phrases during long-running tool calls.

---

## Security Considerations

Three primary attack vectors:

1. **Prompt Injection via Audio:** Users speaking instructions to override system prompts
2. **Tool Abuse:** Malicious parameter manipulation for database operations
3. **Cost Denial of Service:** Leaving sessions open to drain budgets

Mitigation strategies include robust instruction engineering, Pydantic validation for tool parameters, and strict session duration limits.

---

## Key Takeaway

"We spend less time managing VAD thresholds and buffer sizes, and more time managing state synchronization, tool execution security, and session lifecycle."

The Realtime API marks a transition from pipeline optimization to persistent, stateful session management -- fundamentally changing how backend engineers architect voice applications.
