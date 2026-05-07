---
title: "Building an Intelligent RAG Agent with Azure AI Foundry: A Deep Dive into Sreeni-RAG"
url: "https://dev.to/sreeni5018/building-an-intelligent-rag-agent-with-azure-ai-foundry-a-deep-dive-into-sreeni-rag-252b"
author: "Seenivasa Ramadurai"
category: "cloud-agents"
---

# Building an Intelligent RAG Agent with Azure AI Foundry: A Deep Dive into Sreeni-RAG
**Author:** Seenivasa Ramadurai
**Published:** October 5, 2025

## Overview
Building a RAG agent on Azure AI Foundry for resume analysis and candidate evaluation. Uses GPT-4o, Vector Store for document retrieval, FastAPI for REST API, with endpoints for chat, agent management, knowledge upload, and system prompt configuration.

## Key Concepts

### Technology Stack
- Azure AI Foundry (foundation)
- GPT-4o (language model)
- Vector Store (document retrieval)
- FastAPI (REST API)
- python-dotenv, azure-identity, azure-ai-projects

### API Endpoints
- `/ask` - Send messages to the agent
- `/agents` - List available agents
- `/switch-agent` - Switch between agents
- `/upload-knowledge` - Upload files to knowledge base
- `/system-prompt` - Manage system prompts
- `/health` - Health check

### Authentication
Uses `AIProjectClient` with `DefaultAzureCredential` for Azure authentication. Creates threads for conversations and processes agent runs to retrieve source-backed responses from the knowledge base.
