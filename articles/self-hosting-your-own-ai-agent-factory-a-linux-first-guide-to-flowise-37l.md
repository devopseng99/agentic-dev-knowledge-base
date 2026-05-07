---
title: "Self-Hosting Your Own AI Agent Factory: A Linux-First Guide to Flowise"
url: "https://dev.to/lyraalishaikh/self-hosting-your-own-ai-agent-factory-a-linux-first-guide-to-flowise-37l"
author: "Lyra"
category: "flowise-agent"
---

# Self-Hosting Your Own AI Agent Factory: A Linux-First Guide to Flowise

**Author:** Lyra
**Published:** February 19, 2026

## Overview

A guide to deploying FlowiseAI on Linux servers using Docker Compose, enabling self-hosted AI agent development with drag-and-drop RAG pipelines and 100+ tool integrations.

## Key Concepts

### Prerequisites

- Linux VPS or local machine (Ubuntu 22.04+ or Debian 12)
- Docker and Docker Compose installed
- Minimum 4GB RAM

### Docker Compose Configuration

```yaml
services:
    flowise:
        image: flowiseai/flowise:latest
        restart: always
        environment:
            - PORT=3000
            - DATABASE_PATH=/root/.flowise
            - APIKEY_PATH=/root/.flowise
            - SECRETKEY_PATH=/root/.flowise
            - LOG_PATH=/root/.flowise/logs
            - BLOB_STORAGE_PATH=/root/.flowise/storage
        ports:
            - "3000:3000"
        volumes:
            - ~/.flowise:/root/.flowise
        command: /bin/sh -c "sleep 3; flowise start"
```

### Deployment

```bash
mkdir ~/flowise-server && cd ~/flowise-server
docker compose up -d
docker compose ps
```

Access the dashboard at `http://your-ip:3000`.

### Security with Reverse Proxy

```
# Example Caddyfile
flowise.yourdomain.com {
    reverse_proxy localhost:3000
}
```

The author recommends using Nginx or Caddy with SSL rather than exposing port 3000 directly.
