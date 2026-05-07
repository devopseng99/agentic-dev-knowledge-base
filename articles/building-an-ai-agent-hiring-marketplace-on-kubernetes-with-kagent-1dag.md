---
title: "Building an AI Agent Hiring Marketplace on Kubernetes with kagent"
url: "https://dev.to/opspawn/building-an-ai-agent-hiring-marketplace-on-kubernetes-with-kagent-1dag"
author: "OpSpawn"
category: "k8s-native-agents"
---

# Building an AI Agent Hiring Marketplace on Kubernetes with kagent
**Author:** OpSpawn
**Published:** February 21, 2026

## Overview
HireWire is a Kubernetes-native marketplace where agents can autonomously discover, negotiate, hire, and pay each other using MCP tools and x402 micropayments via kagent CRDs.

## Key Concepts

### MCPServer CRD
```yaml
apiVersion: kagent.dev/v1alpha1
kind: MCPServer
metadata:
  name: hirewire-mcp
  namespace: kagent
spec:
  deployment:
    image: "ghcr.io/opspawn/hirewire-mcp:latest"
    cmd: "python"
    args: ["-m", "src.mcp_server"]
  transportType: "stdio"
```

### Agent CRD
```yaml
apiVersion: kagent.dev/v1alpha2
kind: Agent
metadata:
  name: hirewire-agent
spec:
  type: Declarative
  declarative:
    modelConfig: default-model-config
    systemMessage: "You are HireWire, an AI hiring manager..."
    tools:
      - type: McpServer
        mcpServer:
          name: hirewire-mcp
          toolNames:
            - hire_agent
            - list_agents
            - marketplace_search
            - pay_agent
```

### ModelConfig CRD
```yaml
apiVersion: kagent.dev/v1alpha2
kind: ModelConfig
metadata:
  name: default-model-config
spec:
  provider: OpenAI
  model: gpt-4o
```
