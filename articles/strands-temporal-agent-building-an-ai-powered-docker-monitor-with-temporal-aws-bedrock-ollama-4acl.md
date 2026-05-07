---
title: "Strands Temporal Agent: Building an AI-Powered Docker Monitor with Temporal, AWS Bedrock & Ollama"
url: "https://dev.to/arun12415/strands-temporal-agent-building-an-ai-powered-docker-monitor-with-temporal-aws-bedrock-ollama-4acl"
author: "Arun Rao"
category: "llm-agent-docker"
---

# Strands Temporal Agent: Building an AI-Powered Docker Monitor

**Author:** Arun Rao
**Published:** April 1, 2026

## Overview
An intelligent Docker monitoring system combining natural language processing, local LLMs (Ollama + LLaMA 3), and Temporal fault-tolerant workflows. Accepts plain English commands like "show nginx logs" and executes appropriate Docker operations with automatic retries.

## Key Concepts

### Architecture Layers
1. User Input (natural language queries)
2. AI Orchestrator Activity (parses intent, generates operation plan)
3. Temporal Workflow (executes with retry policies)
4. Docker Activities (status checks, health monitoring, logs, restarts)

### Five Core Activities
- AI Orchestrator: Converts natural language to operation plans
- Container Status: Reports container states
- Health Check: Verifies container health
- Logs: Retrieves container logs
- Restart: Restarts specified containers

### Example Parsing
- "show nginx logs" -> `logs:nginx:100`
- "is redis healthy?" -> `health:redis`
- "restart postgres" -> `restart:postgres`

### Key Challenges
- Stop-words filtering: action verbs like "analyze" were not excluded
- Error handling: error strings being executed as operations
- Combined operations: managing multi-step requests like "check health AND show logs"

### Key Takeaways
- Temporal's reliability advantages over manual retry logic
- Local LLMs via Ollama are effective for parsing
- Real-world NLP parsing is more complex than it appears
