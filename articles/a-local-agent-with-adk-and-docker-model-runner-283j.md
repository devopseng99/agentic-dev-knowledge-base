---
title: "A Local Agent with ADK and Docker Model Runner"
url: "https://dev.to/zenika/a-local-agent-with-adk-and-docker-model-runner-283j"
author: "Jean-Phi Baconnais"
category: "llm-agent-docker"
---

# A Local Agent with ADK and Docker Model Runner

**Author:** Jean-Phi Baconnais (Zenika)
**Published:** March 20, 2026

## Overview
Deploy AI agents locally using Google's Agent Development Kit (ADK) combined with Docker Model Runner (DMR). Uses langchain4j to bridge ADK with local models, containerized with docker-compose for both model and application.

## Key Concepts

### Docker Model Runner Commands
- `docker model pull` - Download models
- `docker model list` - List available models
- `docker model run` - Run interactive sessions

### Architecture
- ADK for agent framework (Java-based)
- Docker Model Runner for local LLM inference
- langchain4j library bridges ADK and local models
- OpenAiChatModel configured with local model URL
- docker-compose launches both model and application

### Advantages Over Cloud
- No cloud dependency for specific use cases
- Small Language Models may outperform general-purpose cloud models for specific tasks
- Possibility of custom model training for dedicated tasks
