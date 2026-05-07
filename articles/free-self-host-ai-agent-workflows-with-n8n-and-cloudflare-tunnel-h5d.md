---
title: "Free Self-Host AI Agent Workflows with n8n and Cloudflare Tunnel"
url: "https://dev.to/dalenguyen/free-self-host-ai-agent-workflows-with-n8n-and-cloudflare-tunnel-h5d"
author: "Dale Nguyen"
category: "cloudflare-agents"
---

# Free Self-Host AI Agent Workflows with n8n and Cloudflare Tunnel
**Author:** Dale Nguyen
**Published:** June 22, 2025

## Overview
Self-hosting n8n workflow automation with Docker and Cloudflare Tunnel for secure, cost-free remote access.

## Key Concepts

### Docker Setup
```yaml
version: '3'
services:
  n8n:
    image: n8nio/n8n
    restart: always
    ports:
      - 5678:5678
    environment:
      - N8N_HOST=your-subdomain.your-domain.com
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://your-subdomain.your-domain.com
    volumes:
      - ./n8n_data:/home/node/.n8n
```

### Cloudflare Tunnel
```bash
cloudflared login
cloudflared tunnel create n8n-tunnel
cloudflared tunnel route dns n8n-tunnel n8n.your-domain.com
cloudflared tunnel run n8n-tunnel --url http://localhost:5678
```

### Backup Strategy
```bash
#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d")
tar -czf n8n_backup_$TIMESTAMP.tar.gz ./n8n_data
ls -tp | grep -v '/$' | tail -n +8 | xargs -I {} rm -- {}
```

**Repository:** https://github.com/dalenguyen/n8n-self-hosted-starter
