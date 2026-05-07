---
title: "Why Your APIs Feel Slow (Even When They Aren't)"
url: "https://dev.to/akshatjme/why-your-apis-feel-slow-even-when-they-arent-i8c"
author: "Akshat Jain"
category: "code-optimization"
---
# Why Your APIs Feel Slow (Even When They Aren't)
**Author:** Akshat Jain  **Published:** May 7, 2026

## Overview
APIs can feel slow due to perceptual and architectural factors even when server-side metrics look fine. Covers the gap between actual latency and perceived latency, and practical techniques to bridge it.

## Key Concepts

### Why APIs Feel Slow Despite Fast Metrics
1. **DNS lookup time** not counted in server-side timing (adds 20-120ms)
2. **TCP handshake** (1-2 RTTs before any data)
3. **TLS negotiation** (1-2 additional RTTs for HTTPS)
4. **Time to First Byte (TTFB)** vs time to last byte - metrics often measure server processing, not the full round trip
5. **Cold starts** in serverless (Lambda, Cloud Run) - 200ms-3s penalty

### Perceptual Speed Tricks
- Return partial data early (streaming responses)
- Send a 202 Accepted immediately for long operations
- Optimistic UI updates - update UI before server confirms
- Request coalescing - debounce rapid fire requests

### Real Optimization Techniques

**Connection reuse**: Keep-Alive headers avoid TCP/TLS setup per request.

**CDN for static and cacheable API responses**: Geographical proximity cuts RTT.

**HTTP/2 multiplexing**: Multiple requests over single connection, no head-of-line blocking.

**Compression**: gzip/brotli reduces payload size (60-80% for JSON).

## Key Code Examples

```python
# FastAPI streaming response - user sees data immediately
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import asyncio

app = FastAPI()

async def generate_data():
    for i in range(100):
        yield f"data: item_{i}\n\n"
        await asyncio.sleep(0.01)  # Simulate work

@app.get("/stream")
async def stream_endpoint():
    return StreamingResponse(generate_data(), media_type="text/event-stream")
```

```python
# Return 202 Accepted for long operations
from fastapi import BackgroundTasks
import uuid

tasks_db = {}  # In production, use Redis

@app.post("/process")
async def start_processing(data: dict, background_tasks: BackgroundTasks):
    task_id = str(uuid.uuid4())
    tasks_db[task_id] = {"status": "pending"}

    background_tasks.add_task(long_running_task, task_id, data)

    return {"task_id": task_id, "status": "accepted"}  # Immediate 202

@app.get("/tasks/{task_id}")
async def check_task(task_id: str):
    return tasks_db.get(task_id, {"status": "not_found"})
```

```python
# Response compression with FastAPI
from fastapi import FastAPI
from fastapi.middleware.gzip import GZipMiddleware

app = FastAPI()
app.add_middleware(GZipMiddleware, minimum_size=1000)  # Compress responses > 1KB
```

```nginx
# Nginx configuration for HTTP/2 and connection reuse
server {
    listen 443 ssl http2;

    # Enable keep-alive
    keepalive_timeout 65;
    keepalive_requests 100;

    # Enable gzip compression
    gzip on;
    gzip_types application/json text/plain;
    gzip_min_length 1000;

    # Cache static API responses at CDN edge
    location /api/v1/catalog {
        proxy_pass http://backend;
        add_header Cache-Control "public, max-age=300";
    }
}
```

```javascript
// Client-side: request coalescing to prevent API flooding
function debounce(fn, delay) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => fn.apply(this, args), delay);
    };
}

// Don't fire API for every keystroke
const searchAPI = debounce((query) => {
    fetch(`/api/search?q=${query}`)
        .then(r => r.json())
        .then(data => updateUI(data));
}, 300);  // Wait 300ms after user stops typing

input.addEventListener('input', (e) => searchAPI(e.target.value));
```

## Measurement First
Before optimizing, measure the full client-perceived latency:
1. Browser DevTools Network tab - see DNS, TCP, TLS, TTFB breakdown
2. WebPageTest for geographic distribution
3. Real User Monitoring (RUM) for actual user experience

Don't optimize server-side p99 if DNS resolution is your actual bottleneck.
