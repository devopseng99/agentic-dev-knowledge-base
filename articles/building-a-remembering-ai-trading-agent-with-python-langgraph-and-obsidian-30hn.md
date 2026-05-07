---
title: "Building a \"Remembering\" AI Trading Agent with Python, LangGraph, and Obsidian"
url: "https://dev.to/jiwoomap/building-a-remembering-ai-trading-agent-with-python-langgraph-and-obsidian-30hn"
author: "Jaeil Woo"
category: "ai-agent-trading-finance"
---

# Building a "Remembering" AI Trading Agent with Python, LangGraph, and Obsidian

**Author:** Jaeil Woo
**Published:** January 11, 2026

## Overview

This article introduces TradingAgents-Dashboard, an open-source project addressing a critical limitation in current AI trading systems: their stateless nature. Conventional AI trading bots analyze markets then immediately "forget everything," unable to recall previous insights or decisions.

## Key Concepts

### The Core Problem

Conventional AI trading bots analyze markets then immediately forget everything. They cannot recall previous insights or decisions. "Didn't we determine last week that inflation affects this stock?"

### The Solution Framework

The project implements persistent memory through three layers:

1. **Analysis Phase:** Multiple agents (Bull, Bear, Risk Manager) debate market conditions using LangGraph orchestration
2. **Persistence Layer:** All insights automatically save to a local Obsidian Vault as Markdown files
3. **Retrieval System:** Before new decisions, agents query ChromaDB to retrieve past lessons and context

### Technology Components

- **Framework:** LangChain/LangGraph for multi-agent orchestration
- **Interface:** Streamlit web dashboard
- **Vector Store:** ChromaDB for RAG implementation
- **Knowledge Base:** Obsidian (Markdown-based)
- **Deployment:** Docker and Docker Compose

### Key Features

- Interactive debate visualization between Bull, Bear, and Risk Manager agents
- Hallucination prevention through URL validation
- Docker containerization for quick setup
- Data sovereignty with local storage
- Persistent memory that grows smarter over time

### Repository

GitHub: jiwoomap/TradingAgents-Dashboard
