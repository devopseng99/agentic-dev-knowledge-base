---
title: "Multi-Agent A2A with the Agent Development Kit (ADK), Azure AKS, and Gemini CLI"
url: "https://dev.to/gde/multi-agent-a2a-with-the-agent-development-kitadk-azure-aks-and-gemini-cli-231o"
author: "xbill"
category: "google-adk"
---

# Multi-Agent A2A with the Agent Development Kit (ADK), Azure AKS, and Gemini CLI

**Author:** xbill
**Published:** April 14, 2026
**Organization:** Google Developer Experts

---

## Overview

This article demonstrates building multi-agent applications using Google's Agent Development Kit (ADK) with Gemini LLM capabilities, deployed to Azure Kubernetes Service (AKS).

## Key Concepts

### What Makes This Different

The author notes that while numerous Python ADK demonstrations exist, this deep dive focuses on advanced multi-agent testing with "Gemini CLI tooling" integrated throughout development, debugging, and deployment workflows.

### Technology Stack

- **Python 3.13+** with version management via pyenv
- **Azure Kubernetes Service (AKS)** for container orchestration
- **Gemini CLI** for AI-assisted development
- **Agent Development Kit (ADK)** - an open-source Python framework for multi-agent systems

## Multi-Agent Architecture

The system consists of five specialized agents:

1. **Researcher** - gathers information
2. **Judge** - evaluates findings
3. **Orchestrator** - coordinates the pipeline
4. **Content Builder** - transforms research into structured content
5. **Course Builder** - generates educational modules

## Setup Instructions

### Environment Configuration

```bash
cd ~
git clone https://github.com/xbill9/gemini-cli-azure
cd multi-aks
source init2.sh
make install
```

### Testing Locally

Run the researcher agent:
```bash
adk run researcher
```

Test the web interface:
```bash
adk web --host 0.0.0.0
```

For Google Cloud Shell, add CORS exemption:
```bash
adk web --host 0.0.0.0 --allow_origins 'regex:.*'
```

### Local Development

Start all services:
```bash
make start
```

Service URLs become available at:
- Frontend: http://localhost:5173
- Backend: http://localhost:8000
- Researcher: http://localhost:8001
- Judge: http://localhost:8002
- Content Builder: http://localhost:8003
- Orchestrator: http://localhost:8004

## Azure AKS Deployment

### Deploy to Cluster

```bash
make deploy
```

### Check Status

```bash
make status
```

The deployment provides an external IP for accessing the course creator interface.

### End-to-End Testing

```bash
make e2e-test-aks
```

## Key Features

- **State Management:** Passes data through event content with callback-based recovery
- **Streaming:** Server-Sent Events with overlap deduplication for quality user experience
- **Service Authentication:** Identity tokens for secure agent-to-agent communication
- **Cloud-Native Design:** Production-ready for distributed deployments

## Code Review Highlights

Gemini CLI analysis revealed:

- Coordinated orchestration using SequentialAgent and LoopAgent patterns
- Resilient state flow across independent session stores
- Polished streaming implementation with noise handling
- Cloud-native architecture with proper authentication

## Key Takeaway

"The separation of specialized agents coordinated by a central Orchestrator demonstrates mature microservice-oriented design" suitable for production AI systems.

---

**Series Context:** Part 28 of a 37-part Azure deployment series covering ADK agents across various Azure services.
