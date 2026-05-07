---
title: "Visualizing AI Agent Memory: Building a Web Browser for Amazon Bedrock AgentCore Memory"
url: "https://dev.to/aws/visualizing-ai-agent-memory-building-a-web-browser-for-amazon-bedrock-agentcore-memory-3571"
author: "Danilo Poccia"
category: "aws-agents"
---

# Visualizing AI Agent Memory: Building a Web Browser for Amazon Bedrock AgentCore Memory
**Author:** Danilo Poccia
**Published:** September 19, 2025

## Overview
AgentCore Memory Browser -- a web-based tool for inspecting what AI agents remember in Amazon Bedrock AgentCore. Addresses visibility challenges when developing agents by providing a web UI to explore both short-term conversation context and long-term knowledge extraction, replacing terminal-based CLI debugging. Built with FastAPI backend and vanilla JavaScript frontend.

## Key Concepts

### AgentCore Memory
- Manages short-term conversation context and long-term knowledge extraction
- Multiple memory strategies: user preferences, factual information, session summaries, conversation history
- Namespace templates with placeholders (e.g., `{memoryStrategyId}`) auto-filled by browser

### Three Core Operations
1. **List events** - temporal flow understanding
2. **Browse memory records** - with pagination
3. **Retrieve via semantic search** - natural language queries

### API Layers
- **Control Plane APIs:** List and describe memory resources
- **Data Plane APIs:** List events, browse records, execute semantic searches

### IAM Permissions Required
- `bedrock-agentcore-control:ListMemories`
- `bedrock-agentcore-control:GetMemory`
- `bedrock-agentcore:ListEvents`
- `bedrock-agentcore:ListMemoryRecords`
- `bedrock-agentcore:RetrieveMemoryRecords`

### Architecture
- FastAPI async backend
- Bootstrap responsive frontend
- Vanilla JavaScript for interactivity
- HTML-escaping for injection prevention
- Session persistence for namespace edits

## Code Examples

### Installation
```shell
uv tool install git+https://github.com/danilop/agentcore-memory-browser.git
```

### Running
```shell
agentcore-memory-browser
```

### Verify AWS Credentials
```shell
aws sts get-caller-identity
```

### Development Setup
```shell
uv sync
uv run agentcore-memory-browser
```

Application launches at `http://localhost:8000`. Requires Python 3.13+ with configured AWS credentials.
