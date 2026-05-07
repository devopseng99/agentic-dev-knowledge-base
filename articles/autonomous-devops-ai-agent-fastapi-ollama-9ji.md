---
title: "Autonomous DevOps AI Agent (FastAPI + Ollama)"
url: "https://dev.to/shailendra_khade_df763b45/autonomous-devops-ai-agent-fastapi-ollama-9ji"
author: "shailendra khade"
category: "ai-agent-fastapi"
---

# Autonomous DevOps AI Agent (FastAPI + Ollama)

**Author:** shailendra khade
**Published:** January 22, 2026

## Overview
AI-powered DevOps system combining local LLM inference (Ollama/Mistral) with infrastructure automation via FastAPI. DevOps is evolving into AI-powered automation (AIOps).

## Code Examples

### System Metrics Collection (Python)

```python
import psutil

def get_system_info():
    return {
        "cpu": psutil.cpu_percent(),
        "memory": psutil.virtual_memory().percent,
        "disk": psutil.disk_usage("/").percent
    }
```

### AI Integration (Python)

```python
import requests

OLLAMA_URL = "http://localhost:11434/api/generate"

def ai_think(prompt):
    payload = {
        "model": "mistral",
        "prompt": prompt,
        "stream": False
    }
    response = requests.post(OLLAMA_URL, json=payload)
    return response.json()["response"]
```

### Main FastAPI Application (Python)

```python
from fastapi import FastAPI
from system import get_system_info
from git_ops import clone_repo
from deploy import deploy_app
from agent import ai_think

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Autonomous DevOps AI Agent Running"}

@app.get("/system")
def system():
    return get_system_info()

@app.post("/chat")
def chat(prompt: str):
    return {"ai_response": ai_think(prompt)}

@app.post("/git/clone")
def git_clone(repo_url: str):
    return clone_repo(repo_url)

@app.post("/deploy")
def deploy():
    return deploy_app()

@app.post("/agent")
def autonomous_agent(task: str):
    reasoning = ai_think(f"You are DevOps AI. Task: {task}")
    return {"task": task, "ai_decision": reasoning}
```

### Setup

```bash
ollama pull mistral
uvicorn main:app --host 0.0.0.0 --port 7000
```
