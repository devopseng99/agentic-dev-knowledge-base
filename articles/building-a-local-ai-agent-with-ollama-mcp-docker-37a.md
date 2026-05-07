---
title: "Building a Local AI Agent with Ollama + MCP + LangChain + Docker"
url: "https://dev.to/rajeev_3ce9f280cbae73b234/building-a-local-ai-agent-with-ollama-mcp-docker-37a"
author: "RajeevaChandra"
category: "llm-agent-docker"
---

# Building a Local AI Agent with Ollama + MCP + LangChain + Docker

**Author:** RajeevaChandra
**Published:** April 21, 2025

## Overview
Build an offline AI agent that performs filesystem operations using natural language. Combines Ollama for local LLMs (qwen2:7b), LangChain MCP for tool integration, FastAPI for the tool server, Streamlit for frontend, and Docker Compose for orchestration.

## Key Concepts

### Why MCP?
MCP allows models to discover tools at runtime via RESTful API dynamically. Benefits: runtime tool discovery without hardcoding, modular declarative tool architecture, easy tool management without changing model logic.

### Architecture

```
[Ollama (LLM)]
    |
[LangChain Agent w/ MCP Tool Access]
    |
[FastAPI MCP Server]
    |
[Local Filesystem]
```

## Code Examples

### Run Local Model

```bash
ollama run qwen2:7b
```

### Deploy with Docker Compose

```bash
git clone https://github.com/rajeevchandra/mcp-ollama-file-agent
cd ollama-mcp-tool-agent
docker-compose up --build
```

This starts three components:
- mcp-server (FastAPI tool server)
- streamlit (UI interface)
- agent-runner (LangChain agent with Ollama + MCP tools)

### Capabilities
- List text files in local folders
- Summarize selected files
- Operate entirely offline without API keys

### Agent Workflow Example
Prompt: "List files in ./docs and summarize the first one"
1. Agent selects list_files tool
2. Processes returned file list
3. Selects first file
4. Calls read_and_summarize
5. Generates summary using local model
