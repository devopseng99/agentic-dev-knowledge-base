---
title: "Multi-Agent A2A with the Agent Development Kit(ADK), Azure ACI, and Gemini CLI"
url: "https://dev.to/gde/multi-agent-a2a-with-the-agent-development-kitadk-azure-aci-and-gemini-cli-1k84"
author: "xbill"
category: "a2a-protocols"
---

# Multi-Agent A2A with ADK, Azure ACI, and Gemini CLI
**Author:** xbill (Google Developer Expert)
**Published:** April 19, 2026

## Overview
5 specialized agents (Researcher, Judge, Orchestrator, Content Builder, Course Builder) communicating via A2A protocol, deployed on Azure Container Instances.

## Key Concepts

### Local Development

```bash
make start      # Launch all agents on ports 8000-8004
make test       # Run 30+ unit tests
make lint       # Code quality checks
```

### Azure Deployment

```bash
make deploy-aci        # Deploy to Azure Container Instances
make endpoint-aci      # Retrieve service endpoint
make test-e2e-aci      # Verify remote functionality
```

### Architecture
Python 3.13+, Gemini CLI, ADK framework. Cross-cloud development bridging Google AI tooling with Azure infrastructure.
