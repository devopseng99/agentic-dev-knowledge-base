---
title: "Deploying Ollama on Openshift with the Ollama Operator"
url: "https://dev.to/austincunningham/deploying-ollama-on-openshift-with-the-ollama-operator-1l5l"
author: "Austin Cunningham"
category: "k8s-native-agents"
---

# Deploying Ollama on Openshift with the Ollama Operator
**Author:** Austin Cunningham
**Published:** July 31, 2025

## Overview
Step-by-step guide for deploying Ollama on OpenShift using the Llama Stack K8s Operator, including quickstart script and API testing.

## Key Concepts

### Install Operator
```bash
oc apply -f https://raw.githubusercontent.com/llamastack/llama-stack-k8s-operator/main/release/operator.yaml
```

### Deploy via Quickstart
```bash
git clone https://github.com/opendatahub-io/llama-stack-k8s-operator.git
cd llama-stack-k8s-operator
./hack/deploy-quickstart.sh
```

### Test API
```bash
oc port-forward -n ollama-dist svc/ollama-server-service 11434:11434
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{"model": "llama3.2:1b", "prompt": "Hello, how are you?", "stream": false}'
```

### Try Different Models
```bash
./hack/deploy-quickstart.sh --provider ollama --model mistral:latest
```
