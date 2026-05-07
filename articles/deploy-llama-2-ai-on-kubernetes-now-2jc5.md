---
title: "Deploy Llama 2 AI on Kubernetes, Now"
url: "https://dev.to/chenhunghan/deploy-llama-2-ai-on-kubernetes-now-2jc5"
author: "chh"
category: "k8s-native-agents"
---

# Deploy Llama 2 AI on Kubernetes, Now
**Author:** chh
**Published:** July 19, 2023

## Overview
Deploying Llama 2 13B on Kubernetes using Helm charts with ialacol as the serving layer, providing an OpenAI-compatible API.

## Key Concepts

### Helm Deployment
```bash
cat > values.yaml <<VALEOF
replicas: 1
deployment:
  image: quay.io/chenhunghan/ialacol:latest
  env:
    DEFAULT_MODEL_HG_REPO_ID: TheBloke/Llama-2-13B-chat-GGML
    DEFAULT_MODEL_FILE: llama-2-13b-chat.ggmlv3.q4_0.bin
    THREADS: 8
    BATCH_SIZE: 8
    CONTEXT_LENGTH: 1024
service:
  type: ClusterIP
  port: 8000
VALEOF
helm repo add ialacol https://chenhunghan.github.io/ialacol
helm install llama-2-13b-chat ialacol/ialacol -f values.yaml
```

### Test API
```bash
kubectl port-forward svc/llama-2-13b-chat 8000:8000
curl -X POST -H 'Content-Type: application/json' \
  -d '{"messages": [{"role": "user", "content": "Hello"}], "temperature":"1", "model": "llama-2-13b-chat.ggmlv3.q4_0.bin"}' \
  http://localhost:8000/v1/chat/completions
```
