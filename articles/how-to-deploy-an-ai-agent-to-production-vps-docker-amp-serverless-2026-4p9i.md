---
title: "How to Deploy an AI Agent to Production: VPS, Docker & Serverless (2026)"
url: "https://dev.to/paxrel/how-to-deploy-an-ai-agent-to-production-vps-docker-amp-serverless-2026-4p9i"
author: "Pax"
category: "serverless-agents"
---

# How to Deploy an AI Agent to Production: VPS, Docker & Serverless (2026)

**Author:** Pax
**Published:** March 27, 2026

## Overview
Three deployment approaches compared: VPS ($5-20/mo), Docker + VPS ($10-30/mo), and Serverless ($1-50/mo). VPS + systemd is the simplest path for always-on agents.

## Code Examples

### Dockerfile

```dockerfile
FROM python:3.12-slim
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends curl git
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN useradd -m agent
USER agent
CMD ["python3", "agent.py"]
```

### Lambda Handler

```python
def lambda_handler(event, context):
    from agent import run_agent
    result = run_agent(event)
    return {'statusCode': 200, 'body': json.dumps(result)}
```

### Health Check Endpoint

```python
@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "uptime_hours": get_uptime(),
        "memory_mb": psutil.Process().memory_info().rss / 1024 / 1024
    })
```

### Structured Logging

```python
handler = RotatingFileHandler(
    'logs/agent.log',
    maxBytes=10_000_000,
    backupCount=5
)
```

## Production Hardening Checklist
- Environment variables for API keys, non-root processes, firewall, SSH keys
- Process managers with auto-restart, graceful shutdown, exponential backoff
- Daily API spend limits, token counting, weekly cost reports
