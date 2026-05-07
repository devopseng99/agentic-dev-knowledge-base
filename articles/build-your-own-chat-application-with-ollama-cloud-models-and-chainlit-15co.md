---
title: "How to Build Your Own AI Platform with Ollama Cloud Models"
url: "https://dev.to/coderforfun/build-your-own-chat-application-with-ollama-cloud-models-and-chainlit-15co"
author: "ELI"
category: "agent-ui-frameworks"
---

# How to Build Your Own AI Platform with Ollama Cloud Models
**Author:** ELI
**Published:** November 24, 2025

## Overview
AI chat application combining Ollama Cloud managed LLM infrastructure with Chainlit for document processing, voice input, MCP tool connections, and persistent chat sessions.

## Key Concepts
- Chainlit as purpose-built framework for complex agentic workflows
- Multi-format document analysis (PDF, DOCX, images)
- MCP integration for external tools
- Persistent sessions with PostgreSQL + SQLAlchemy
- OAuth authentication via Auth0
- Multi-model switching through chat profiles

```bash
git clone https://github.com/EliAbdiel/ollama-chat-application.git
uv sync
chainlit run main.py -w
```
