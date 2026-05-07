---
title: "Building an open-source deep research agent from scratch using LlamaIndex, Composio, and ExaAI"
url: "https://dev.to/composiodev/building-an-open-source-deep-research-agent-from-scratch-using-llamaindex-composio-exaai-4j9b"
author: "Sunil Kumar Dash"
category: "llamaindex-agent"
---

# Building an open-source deep research agent from scratch using LlamaIndex, Composio, and ExaAI

**Author:** Sunil Kumar Dash
**Published:** February 10, 2025

## Overview

Creates an open-source alternative to OpenAI's Deep Research feature using LlamaIndex for agent orchestration, Composio for third-party service integrations (Google Docs, ExaAI), and Deepseek R1 as the reasoning LLM with Groq API for function-calling.

## Key Concepts

### Architecture

**Backend (Python):** Agent creation, research execution, and Google Docs integration through Composio's 250+ service connectors.

**Frontend:** Lean web interface using HTML, CSS, and JavaScript with Server-Sent Events (SSE) for real-time response streaming.

### Agent Workflow

1. Generate targeted research questions from user input
2. Execute web searches via Exa integration
3. Analyze and synthesize findings
4. Create formatted reports in Google Docs
5. Stream results to the user interface

### Setup

```bash
pip install llama-index composio-llamaindex groq python-dotenv flask

# Environment variables
GROQ_API_KEY=your_key
COMPOSIO_API_KEY=your_key
```

### Agent Implementation

```python
from llama_index.core.agent import ReActAgent
from llama_index.llms.groq import Groq
from composio_llamaindex import ComposioToolSet, Action

# Initialize Composio tools
toolset = ComposioToolSet()
tools = toolset.get_tools(actions=[
    Action.EXA_SEARCH,
    Action.GOOGLEDOCS_CREATE_DOCUMENT,
    Action.GOOGLEDOCS_INSERT_TEXT,
])

# Create research agent
llm = Groq(model="deepseek-r1-distill-llama-70b")

agent = ReActAgent.from_tools(
    tools=tools,
    llm=llm,
    system_prompt="""You are a deep research agent. When given a topic:
    1. Break it into specific research questions
    2. Search for each question using Exa
    3. Synthesize findings into a comprehensive report
    4. Save the report to Google Docs""",
    verbose=True,
)
```

### Flask SSE Backend

```python
from flask import Flask, Response, request
import json

app = Flask(__name__)

@app.route("/research", methods=["POST"])
def research():
    topic = request.json["topic"]

    def generate():
        response = agent.chat(f"Research this topic: {topic}")
        yield f"data: {json.dumps({'result': str(response)})}\n\n"

    return Response(generate(), mimetype="text/event-stream")
```
