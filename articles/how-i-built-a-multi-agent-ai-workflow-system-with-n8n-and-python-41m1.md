---
title: "How I Built a Multi-Agent AI Workflow System with n8n and Python"
url: "https://dev.to/roman_60d27e756c682fc5272/how-i-built-a-multi-agent-ai-workflow-system-with-n8n-and-python-41m1"
author: "Roman Buhyna"
category: "multi-agent system Python"
---

# How I Built a Multi-Agent AI Workflow System with n8n and Python

**Author:** Roman Buhyna
**Published:** October 29, 2025

## Overview
Roman describes developing an AI Agents Repository -- a modular framework enabling developers to contribute AI agents solving real-world automation tasks using n8n, LangChain, and Python microservices. The system employs a three-layer architecture: n8n for orchestration, Python/FastAPI microservices for LLM operations, and PGVector/Pinecone for semantic memory.

## Key Concepts

### Architecture
1. **n8n Workflow** (Agent Orchestrator)
2. **Python Microservice** (LangChain/FastAPI)
3. **Shared Vector Database** (PGVector/Pinecone)

Each agent runs within n8n but delegates LLM operations to a Python microservice utilizing FastAPI, with LangChain managing context retrieval and reasoning.

### Use Case: Sales Call Prep Agent
- **Inputs:** Prospect name, company domain, LinkedIn profile
- **Outputs:** Person/company summary, identified pain points, suggested call flow with value propositions
- Runs daily, producing structured JSON and Markdown outputs for human review

### Technology Stack
- n8n (orchestration)
- LangChain (LLM pipelines)
- FastAPI (microservice backend)
- PostgreSQL + PGVector (semantic memory)
- Docker Compose (local development)
- OpenAI/Claude APIs (model layer)

### Key Lessons
1. Separating orchestration from logic simplifies debugging
2. Schema validation ensures downstream automation reliability
3. Vector databases eliminate brittle keyword matching
