---
title: "Building Your First Agentic AI Workflow with OpenRouter API"
url: "https://dev.to/allanninal/building-your-first-agentic-ai-workflow-with-openrouter-api-1fo6"
author: "Allan Ninal"
category: "ai-agent-api-gateway"
---

# Building Your First Agentic AI Workflow with OpenRouter API

**Author:** Allan Ninal
**Published:** May 15, 2025

## Overview
Tutorial building agentic AI workflows using OpenRouter as a unified API gateway for hundreds of AI models through a single endpoint.

## Key Concepts

### Basic Client Setup

```python
import os
from dotenv import load_dotenv
from openai import OpenAI

load_dotenv()

def setup_openrouter_client():
    client = OpenAI(
        base_url="https://openrouter.ai/api/v1",
        api_key=os.getenv("OPENROUTER_API_KEY"),
        default_headers={
            "HTTP-Referer": os.getenv("YOUR_SITE_URL", "http://localhost:5000"),
            "X-Title": os.getenv("YOUR_SITE_NAME", "Agentic AI Demo")
        }
    )
    return client
```

### Agentic Workflow Agent

```python
class Agent:
    def __init__(self, model="openai/gpt-4"):
        self.model = model
        self.client = self._setup_client()

    def analyze_task(self, user_query):
        system_prompt = """You are an AI task planner. Break down the request
        into steps with "description" and "reasoning" fields as JSON array."""
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": f"Break down this task: {user_query}"}
        ]
        response = self._call_llm(messages)
        return json.loads(response)

    def execute_step(self, step, context):
        system_prompt = """Execute this specific step using provided context."""
        step_msg = f"Context: {context}\n\nStep: {step['description']}"
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": step_msg}
        ]
        return self._call_llm(messages)

    def solve(self, user_query):
        steps = self.analyze_task(user_query)
        steps_results = []
        context = ""
        for step in steps:
            result = self.execute_step(step, context)
            steps_results.append(result)
            context += f"\n{step['description']}: {result}"
        return self.compile_results(steps_results, user_query)
```
