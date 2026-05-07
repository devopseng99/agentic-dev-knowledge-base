---
title: "Building an AI-powered Docker Solution with Llama and k8sGPT"
url: "https://dev.to/xaverric/building-an-ai-powered-docker-solution-with-llama-and-k8sgpt-jbj"
author: "xaverric"
category: "k8s-native-agents"
---

# Building an AI-powered Docker Solution with Llama and k8sGPT
**Author:** xaverric
**Published:** January 3, 2025

## Overview
Packages k8sGPT with Ollama and Llama 3.2 into a single Docker image for self-contained Kubernetes cluster analysis without external dependencies.

## Key Concepts

### Dockerfile
```dockerfile
FROM ollama/ollama

RUN apt-get update && apt-get install -y curl git build-essential && rm -rf /var/lib/apt/lists/*

RUN curl -LO "https://dl.k8s.io/release/v1.25.3/bin/linux/arm64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

RUN curl -LO "https://github.com/k8sgpt-ai/k8sgpt/releases/latest/download/k8sgpt_Linux_arm64.tar.gz" && \
    tar xzf k8sgpt_Linux_arm64.tar.gz && chmod +x k8sgpt && mv k8sgpt /usr/local/bin/ && rm k8sgpt_Linux_arm64.tar.gz

RUN mkdir -p /root/.ollama && \
    ollama serve & sleep 10 && ollama pull llama3.2:3b && sleep 5 && ollama list && pkill ollama

WORKDIR /opt
COPY ["./k8s/", "/opt/k8s/"]
COPY ["run.sh", "/opt/run.sh"]
ENV KUBECONFIG=/opt/k8s/kubeconfig.yaml
RUN chmod +x /opt/run.sh
ENTRYPOINT ["/opt/run.sh"]
```

### Entry Point Script
```bash
#!/bin/bash
ollama serve &
while ! curl -s localhost:11434 >/dev/null; do
    echo "Waiting for ollama to start..."
    sleep 1
done
k8sgpt auth add --backend ollama --model llama3.2:3b
k8sgpt auth default -p ollama
kubectl config use-context "context name"
k8sgpt analyze --explain
```

### Build and Run
```bash
docker build -t k8sgpt-ollama-llama3-analyzer .
docker run k8sgpt-ollama-llama3-analyzer
```
