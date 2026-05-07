---
title: "Running Agentic AI at Scale on Google Kubernetes Engine"
url: "https://dev.to/gde/running-agentic-ai-at-scale-on-google-kubernetes-engine-2540"
author: "Saurabh Mishra"
category: "ai-agent-kubernetes-deploy"
---

# Running Agentic AI at Scale on Google Kubernetes Engine

**Author:** Saurabh Mishra
**Published:** April 8, 2026

## Overview

Describes the shift from "can the model answer my question?" to "can the system complete my goal?" Covers GKE infrastructure for agentic AI, framework comparison, observability, and security.

## Key Concepts

### AI Taxonomy (Progression)
1. **Reactive/Inference** - Stateless prompt-response
2. **Conversational AI** - Multi-turn dialog with session context
3. **RAG** - Runtime queries to external knowledge
4. **Agentic AI** - Loop-based planning, action-taking, observation
5. **Multi-Agent Systems** - Specialized agents collaborating

### GKE Advantages
- GPU/TPU node pools for accelerated compute
- Workload Identity for secure API authentication
- Custom metrics-based horizontal pod autoscaling
- Autopilot and Standard deployment modes
- Cloud Run integration for ephemeral tool execution

### Framework Comparison
- **Agent Development Kit (ADK)** - Google's native framework, Kubernetes-first, tight Gemini integration
- **LangGraph** - Graph-based orchestration with explicit state machines, LangSmith tracing
- **CrewAI** - Role-based agent modeling for content and research pipelines

### Observability Requirements
- OpenTelemetry instrumentation for LLM calls and tool invocations
- Structured JSON logging to Cloud Logging
- Custom metrics: task completion, step counts, tool success rates
- LLM-specific evaluation via LangSmith or Vertex AI

### Security
- Prompt injection: Sanitize retrieved content before prompt insertion
- Privilege escalation: Role-specific service accounts via Workload Identity
- Human-in-the-Loop gates for irreversible actions
- Network Policies restricting pod-to-service communication

### Future Directions
- Agent-to-Agent Communication (A2A Protocol)
- Model Context Protocol (MCP) as tool discovery standard
- Vertex AI Agent Engine as managed orchestration layer
