---
title: "Mastering Real-Time AI: A Developer's Guide to Building Streaming LLMs with FastAPI and Transformers"
url: "https://dev.to/louis-sanna/mastering-real-time-ai-a-developers-guide-to-building-streaming-llms-with-fastapi-and-transformers-2be8"
author: "Louis Sanna"
category: "llm-streaming"
---

# Mastering Real-Time AI: Building Streaming LLMs with FastAPI and Transformers

**Author:** Louis Sanna
**Published:** December 12, 2024

## Overview
A complete guide to building streaming LLM backends with FastAPI and Hugging Face Transformers, from basic SSE endpoints to Docker deployment.

## Code Examples

### Environment Setup

```bash
python -m venv venv
source venv/bin/activate
pip install fastapi uvicorn transformers asyncio
```

### Basic Streaming Endpoint

```python
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import asyncio

app = FastAPI()

async def event_stream():
    for i in range(10):
        await asyncio.sleep(1)
        yield f"data: Message {i}\n\n"

@app.get("/stream")
async def stream_response():
    return StreamingResponse(event_stream(), media_type="text/event-stream")
```

### LLM Integration with Transformers

```python
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse
from transformers import pipeline
import asyncio

app = FastAPI()
llm_pipeline = pipeline("text-generation", model="gpt2")

async def generate_response(prompt):
    for chunk in llm_pipeline(prompt, max_length=50, return_full_text=False):
        yield f"data: {chunk['generated_text']}\n\n"
        await asyncio.sleep(0.1)

@app.get("/stream")
async def stream_response(prompt: str):
    return StreamingResponse(generate_response(prompt), media_type="text/event-stream")
```

### Client-Side Integration

```html
<!DOCTYPE html>
<html lang="en">
<body>
  <h1>LLM Streaming Demo</h1>
  <pre id="stream-output"></pre>
  <script>
    const output = document.getElementById('stream-output');
    const eventSource = new EventSource('http://127.0.0.1:8000/stream?prompt=Tell me a story');
    eventSource.onmessage = (event) => {
      output.innerText += event.data + '\n';
    };
  </script>
</body>
</html>
```

### Docker Deployment

```dockerfile
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8
WORKDIR /app
COPY . /app
RUN pip install -r /app/requirements.txt
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
```

## Key Distinction
SSE allows server-to-client pushing; WebSockets support bidirectional communication. For LLM streaming, SSE offers simplicity and efficiency.
