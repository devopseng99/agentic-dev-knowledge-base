---
title: "Deploying Local AI Agents In Kubernetes"
url: "https://dev.to/thenjdevopsguy/deploying-local-ai-agents-in-kubernetes-3087"
author: "Michael Levan"
category: "ai-agent-kubernetes-deploy"
---

# Deploying Local AI Agents In Kubernetes

**Author:** Michael Levan
**Published:** November 8, 2025

## Overview

Tutorial for deploying self-managed local AI models (Ollama with llama3) on Kubernetes using the kagent framework, as an alternative to SaaS-based LLM APIs for organizations prioritizing data control and security.

## Key Concepts

### Deploying Ollama

```bash
kubectl create ns ollama
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ollama
  namespace: ollama
spec:
  selector:
    matchLabels:
      name: ollama
  template:
    metadata:
      labels:
        name: ollama
    spec:
      initContainers:
      - name: model-puller
        image: ollama/ollama:latest
        command: ["/bin/sh", "-c"]
        args:
          - |
            ollama serve &
            sleep 10
            ollama pull llama3
            pkill ollama
        volumeMounts:
        - name: ollama-data
          mountPath: /root/.ollama
        resources:
          requests:
            memory: "8Gi"
          limits:
            memory: "12Gi"
      containers:
      - name: ollama
        image: ollama/ollama:latest
        ports:
        - name: http
          containerPort: 11434
          protocol: TCP
        volumeMounts:
        - name: ollama-data
          mountPath: /root/.ollama
        resources:
          requests:
            memory: "8Gi"
          limits:
            memory: "12Gi"
      volumes:
      - name: ollama-data
        emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: ollama
  namespace: ollama
spec:
  type: ClusterIP
  selector:
    name: ollama
  ports:
  - port: 80
    name: http
    targetPort: http
    protocol: TCP
```

### Verify Model Download
```bash
kubectl exec -n ollama deployment/ollama -- ollama list
```

### Deploying kagent

```bash
helm install kagent-crds oci://ghcr.io/kagent-dev/kagent/helm/kagent-crds \
    --namespace kagent --create-namespace

export ANTHROPIC_API_KEY=your_api_key

helm upgrade --install kagent oci://ghcr.io/kagent-dev/kagent/helm/kagent \
    --namespace kagent \
    --set providers.default=anthropic \
    --set providers.anthropic.apiKey=$ANTHROPIC_API_KEY \
    --set ui.service.type=LoadBalancer
```

### ModelConfig for Ollama

```yaml
apiVersion: kagent.dev/v1alpha2
kind: ModelConfig
metadata:
  name: llama3-model-config
  namespace: kagent
spec:
  model: llama3
  provider: Ollama
  ollama:
    host: http://ollama.ollama.svc.cluster.local:80
```

### Key Technical Details
- Local models require substantial resources (8Gi minimum RAM)
- EmptyDir volumes store model data during pod lifecycle
- Ollama initContainer downloads models before main container starts
- kagent integrates with Kubernetes via custom resource definitions (CRDs)
