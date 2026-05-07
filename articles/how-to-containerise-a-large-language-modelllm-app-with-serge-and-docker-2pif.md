---
title: "How to Containerise a Large Language Model(LLM) App with Serge and Docker"
url: "https://dev.to/ajeetraina/how-to-containerise-a-large-language-modelllm-app-with-serge-and-docker-2pif"
author: "Ajeet Singh Raina"
category: "llm-agent-docker"
---

# How to Containerise a Large Language Model(LLM) App with Serge and Docker

**Author:** Ajeet Singh Raina
**Published:** November 6, 2023

## Overview
Deploy LLM applications using Serge (open-source chat platform) with Docker containerization and Kubernetes deployment. Includes memory requirements: 7B needs ~4.5GB RAM, 13B needs ~12GB, 30B needs ~20GB.

## Code Examples

### Clone and Setup

```bash
mkdir my-app
cd my-app
git clone https://github.com/serge-chat/serge.git
```

### Dockerfile

```dockerfile
FROM serge-chat/serge:latest
COPY my-model.pkl /app/
CMD ["python", "app.py"]
```

### Build and Run

```bash
docker build -t my-app .
docker run -it my-app
```

### Docker Compose

```yaml
services:
  serge:
    image: ghcr.io/serge-chat/serge:latest
    container_name: serge
    restart: unless-stopped
    ports:
      - 8008:8008
    volumes:
      - weights:/usr/src/app/weights
      - datadb:/data/db/

volumes:
  weights:
  datadb:
```

### Kubernetes Deployment

```bash
kubectl create ns serge-ai
kubectl apply -f manifest.yaml
```

Includes Service, Deployment (1 replica, 5-8GB memory), PersistentVolumeClaims (64Gi weights, 16Gi database), Ingress with Nginx, and optional Cert-Manager TLS.

### Model Download in K8s

```bash
kubectl exec -it serge-58959fb6b7-px76v -n serge-ai python3 /usr/src/app/api/utils/download.py tokenizer 7B
```
