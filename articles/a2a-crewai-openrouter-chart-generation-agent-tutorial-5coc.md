---
title: "A2A + CrewAI + OpenRouter Chart Generation Agent Tutorial"
url: "https://dev.to/czmilo/a2a-crewai-openrouter-chart-generation-agent-tutorial-5coc"
author: "cz"
category: "ai-agent-image-generation"
---

# A2A + CrewAI + OpenRouter Chart Generation Agent Tutorial

**Author:** cz
**Published:** June 27, 2025

## Overview
Building a chart generation agent using A2A protocol with CrewAI and OpenRouter, including matplotlib visualization and base64 image encoding.

## Key Concepts

### Quick Start

```bash
git clone git@github.com:sing1ee/a2a-crewai-charts-agent.git
cd a2a-crewai-charts-agent
uv venv
source .venv/bin/activate
uv run .
```

### Configuration

```
OPENROUTER_API_KEY=sk-or-v1-your-api-key-here
OPENAI_MODEL_NAME=openrouter/anthropic/claude-3.7-sonnet
```

### Architecture
- AgentCard objects describe capabilities and content types
- CrewAI agents with specialized roles, goals, and tools
- Chart tool: parses CSV, creates matplotlib visualizations, encodes as base64
- Thread-safe in-memory cache with session isolation
- A2A Executor bridges CrewAI responses to protocol format

### Debugging
A2A Inspector (inspector.a2aprotocol.ai) for connection diagnostics and image data validation.
