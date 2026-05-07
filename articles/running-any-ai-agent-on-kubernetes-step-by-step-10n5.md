---
title: "Running Any AI Agent on Kubernetes: Step-by-Step"
url: "https://dev.to/thenjdevopsguy/running-any-ai-agent-on-kubernetes-step-by-step-10n5"
author: "Michael Levan"
category: "ai-agents-kubernetes"
---

# Running Any AI Agent on Kubernetes: Step-by-Step

**Author:** Michael Levan
**Date Published:** December 13, 2025
**Original Source:** cloudnativedeepdive.com

---

## Overview

This article explains how to deploy AI agents on Kubernetes using kagent, a framework that supports "Bring Your Own" (BYO) agents created with various frameworks like CrewAI, ADK, or LangChain.

## Prerequisites

- Kubernetes cluster with kagent installed
- Python 3.10 or higher
- Docker Desktop or Docker engine

## Key Concepts

### BYO Agents

"BYO (Bring Your Own) means you can create an Agent in any of the supported providers from kagent." Developers can containerize existing agents from various frameworks rather than rebuilding them from scratch.

## Building an Agent

### Creating with ADK

```bash
pip install google-adk
adk create NAME_OF_YOUR_AGENT
cd adk/NAME_OF_YOUR_AGENT && adk run NAME_OF_YOUR_AGENT
```

### Using an Existing Agent

**Dockerfile example:**

```dockerfile
ARG DOCKER_REGISTRY=ghcr.io
ARG VERSION=0.7.4
FROM $DOCKER_REGISTRY/kagent-dev/kagent/kagent-adk:$VERSION

WORKDIR /app

COPY troubleshootagent/ troubleshootagent/
COPY pyproject.toml pyproject.toml
COPY uv.lock uv.lock
COPY how-it-works.md how-it-works.md

RUN uv sync --locked --refresh

CMD ["troubleshootagent"]
```

**Building the image:**

```bash
docker build . -t troubleshootagent:latest
docker tag troubleshootagent:latest yourusername/troubleshootagent:latest
docker push yourusername/troubleshootagent:latest
```

## Kubernetes Deployment

### 1. Set API Key

```bash
export GOOGLE_API_KEY=your_key_here
```

### 2. Create Secret

```bash
kubectl apply -f- <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: kagent-google
  namespace: kagent
type: Opaque
stringData:
  GOOGLE_API_KEY: $GOOGLE_API_KEY
EOF
```

### 3. Deploy Agent via CRD

```yaml
apiVersion: kagent.dev/v1alpha2
kind: Agent
metadata:
  name: troubleshoot-agent
  namespace: kagent
spec:
  description: This agent is used to be a Platform Engineering troubleshoot expert.
  type: BYO
  byo:
    deployment:
      image: adminturneddevops/troubleshootagent:latest
      env:
        - name: GOOGLE_API_KEY
          valueFrom:
            secretKeyRef:
              name: kagent-google
              key: GOOGLE_API_KEY
```

### 4. Verify Deployment

```bash
kubectl get pods -n kagent
```

## Key Takeaways

- Containerization enables declarative agent deployment on Kubernetes
- Multiple agent frameworks are supported through a unified platform
- LLM API credentials are managed via Kubernetes Secrets
- kagent CRDs provide infrastructure-as-code approach to agent management
