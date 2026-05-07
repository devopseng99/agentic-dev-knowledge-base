---
title: "Why I Wrote an AI Workflow Engine"
url: "https://dev.to/sean_harrison/why-i-wrote-an-ai-workflow-engine-2jo7"
author: "Sean Harrison"
category: "AI workflow automation Python"
---

# Why I Wrote an AI Workflow Engine

**Author:** Sean Harrison
**Published:** February 18, 2026

## Overview

Introduces Kruxia Flow, an open-source AI-native durable workflow engine in Rust with Python SDK. Single 7.5 MB binary, PostgreSQL-only, with built-in LLM cost tracking.

## Key Concepts

### Problem Statement

The author repeatedly built identical components across AI projects (memoir writing assistant, finance app, customer chatbot, research assistant). All required durable workflow orchestration, AI agent integration, and cost control.

### Existing Solutions Analysis

- **Temporal:** Powerful but operationally heavy, lacks AI cost awareness
- **Airflow:** Designed for batch DAGs, not event-driven. Resource-intensive (1GB+ images)
- **LangChain/LangGraph:** AI-focused but Python-only, lacking native durability. Production requires LangSmith (~$1000/million executions)

### Core Design Insight

"In AI applications, LLM cost is an application concern." Cost decisions should influence workflow execution in real-time.

### Technical Specifications

- Single Rust binary (~7.5 MB)
- Requires only PostgreSQL
- 93 workflows/sec vs Temporal's 66 and Airflow's 8
- 328 MB peak memory vs Airflow's 7.2 GB
- Docker image: 63 MB
- Runs on Raspberry Pi Zero

### AI-Native Capabilities

1. Automatic cost tracking with real-time token counting
2. Pre-execution budget enforcement
3. Cost-aware model fallback chains
4. Provider support: Anthropic, OpenAI, Google, Ollama

### License

AGPL-3.0 (Python SDK: MIT-licensed)

GitHub: github.com/kruxia/kruxiaflow
