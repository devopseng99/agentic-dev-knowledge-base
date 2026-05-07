---
title: "LlamaIndex File Chat Workflow with A2A Protocol"
url: "https://dev.to/czmilo/llamaindex-file-chat-workflow-with-a2a-protocol-bah"
author: "cz"
category: "llamaindex-agent"
---

# LlamaIndex File Chat Workflow with A2A Protocol

**Author:** cz
**Published:** June 3, 2025

## Overview

A conversational agent built using LlamaIndex Workflows and the A2A protocol. The system enables file uploads, multi-turn conversations, streaming responses, and inline citations using LlamaParse for document parsing.

## Key Concepts

### Features
- File upload and parsing capabilities
- Multi-turn conversational interactions
- Real-time streaming updates
- Webhook-based push notifications
- Conversational memory across sessions
- LlamaParse integration for accurate file parsing

### Setup

```bash
# Prerequisites: Python 3.12+, UV package manager
git clone <repository>
cd a2a-file-chat
uv venv
uv sync

# Configure .env
OPENROUTER_API_KEY=your_key_here
LLAMA_CLOUD_API_KEY=your_key_here

# Run
uv run a2a-file-chat
```

### Architecture

The workflow uses LlamaIndex for document parsing and conversation management, with OpenRouter providing the LLM backend. The A2A protocol standardizes client-agent communication, supporting JSON-RPC requests for task submission and streaming event responses.

### Limitations
- Text-only output currently supported
- LlamaParse free tier covers ~3,333 pages
- In-memory session storage (not persisted across restarts)
- Document insertion into context window not scalable for large files; vector databases recommended for production RAG
