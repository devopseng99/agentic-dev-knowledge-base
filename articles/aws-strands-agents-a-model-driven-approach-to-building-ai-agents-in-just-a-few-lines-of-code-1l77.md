---
title: "AWS Strands Agents: A model-driven approach to building AI agents in just a few lines of code"
url: "https://dev.to/aws-builders/aws-strands-agents-a-model-driven-approach-to-building-ai-agents-in-just-a-few-lines-of-code-1l77"
author: "Walter Lee"
category: "aws-agents"
---

# AWS Strands Agents: A model-driven approach to building AI agents in just a few lines of code
**Author:** Walter Lee
**Published:** June 26, 2025

## Overview
Overview of AWS Strands Agents SDK covering key components (Model, Tools, Prompt), the agentic loop architecture, built-in tools, MCP integration, and deployment options. Production-ready and used internally by AWS teams for Amazon Q Developer, AWS Glue, and VPC Reachability Analyzer.

## Key Concepts

### Minimal Agent Example

```python
from strands import Agent
from strands_tools import calculator
agent = Agent(tools=[calculator])
response = agent("What is the square root of 1764?")
```

### Key Components
- **Model:** Supports Amazon Bedrock (Claude, Nova), Anthropic, Meta Llama, others via LiteLLM
- **Tools:** 20+ pre-built tools including semantic search with Bedrock Knowledge Bases; custom via @tool decorator
- **Prompt:** Natural language defining agent tasks and behavior

### Agentic Loop
SDK operates through a loop where LLMs process prompts, reason about tasks, select appropriate tools, and iterate until completion -- eliminating rigid workflows for dynamic planning.

### Deployment Options
- Local development
- AWS Lambda (serverless)
- AWS Fargate (containerized)
- EC2
- On-premises

### Production Features
- OpenTelemetry observability
- Security features
- Reference architectures
- Multi-agent support via MCP protocols
