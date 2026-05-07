---
title: "Introducing Composio Tools: Agentic LLMs API Gateway"
url: "https://dev.to/kamalabot/introducing-composio-tools-agentic-llms-api-gateway-1ldm"
author: "Kamalabot"
category: "a2a-protocols"
---

# Introducing Composio Tools
**Author:** Kamalabot
**Published:** December 12, 2024

## Overview
Composio provides 200+ integrated applications for AI agents, handling authentication and API execution.

## Key Concepts

Function names map to specific actions:
```
tool_calls=[ChatCompletionMessageToolCall(
  function=Function(
    arguments='{"owner":"crewAIInc","repo":"crewAI-tools"}',
    name='GITHUB_STAR_A_REPOSITORY_FOR_THE_AUTHENTICATED_USER'
  )
)]
```

Solves the bottleneck of connecting agentic LLMs to external applications.
