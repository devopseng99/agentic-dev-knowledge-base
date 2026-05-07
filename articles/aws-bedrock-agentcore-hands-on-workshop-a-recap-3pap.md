---
title: "AWS Bedrock AgentCore Hands-On Workshop: A Recap"
url: "https://dev.to/soniarahal/aws-bedrock-agentcore-hands-on-workshop-a-recap-3pap"
author: "Sonia Rahal"
category: "aws-agents"
---

# AWS Bedrock AgentCore Hands-On Workshop: A Recap
**Author:** Sonia Rahal
**Published:** December 20, 2025

## Overview
Recap of a Montreal AWS User Group workshop exploring Amazon Bedrock AgentCore platform for running AI agents at scale. Covers six modules: Runtime, Gateway, Identity, Memory, Built-in Tools, and Observability with hands-on demos for each component.

## Key Concepts

### Workshop Modules

**Runtime (Weather + Calculator Agent):** Execution environment managing infrastructure, scaling, and session isolation using Strands Agent and ECR.

**Gateway (Mars Weather Agent):** Agent integration with external systems via NASA Open APIs. Gateway allows defining tools with metadata about names, descriptions, input/output schemas, and behavior specifications.

**Identity (Authorization Demo):** Access control via Amazon Cognito and JWT tokens. Agents return AccessDeniedException without proper credentials.

**Memory (AI Learning Agent):** Short-term memory maintains session context; long-term memory preserves information across sessions. Demo showed agent remembering user details across multiple interactions.

**Built-in Tools (Amazon Revenue Extraction):** Browser tool with Nova Act SDK for extracting data from websites. Code Interpreter for specialized task handling.

**Observability (CrewAI Travel Agent):**

```python
from crewai import Agent
CrewAIInstrumentor().instrument()
prompt = "What are some rodeo events happening in Oklahoma?"
```

Monitored via CloudWatch dashboards with custom time-frame filtering using AWS Distro for OpenTelemetry.

### Why AgentCore Matters
- Scalable deployment without infrastructure management
- Secure, authorized execution
- Contextual and persistent memory
- External system integration
- Full operational visibility
