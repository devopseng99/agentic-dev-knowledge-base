---
title: "How to Self-Host n8n with Docker -- AI Workflow Automation Guide 2026"
url: "https://dev.to/jangwook_kim_e31e7291ad98/how-to-self-host-n8n-with-docker-ai-workflow-automation-guide-2026-3lec"
author: "Jangwook Kim"
category: "AI workflow automation Python"
---

# How to Self-Host n8n with Docker -- AI Workflow Automation Guide 2026

**Author:** Jangwook Kim
**Published:** April 5, 2026

## Overview

Comprehensive guide to self-hosting n8n, an open-source workflow automation platform with 1,400+ integrations. Covers both the AI Starter Kit and minimal setup, plus AI agent workflows with tool use.

## Key Concepts

### AI Starter Kit Setup

```bash
git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit
cp .env.example .env
```

```env
POSTGRES_USER=n8n_user
POSTGRES_PASSWORD=your-secure-password-here
POSTGRES_DB=n8n
N8N_ENCRYPTION_KEY=generate-a-random-32-char-string
N8N_USER_MANAGEMENT_JWT_SECRET=generate-another-random-string
N8N_DEFAULT_BINARY_DATA_MODE=filesystem
```

```bash
openssl rand -hex 32  # Generate keys
docker compose --profile cpu up -d
```

### Minimal Docker Compose Setup

```yaml
volumes:
  n8n_storage:
  postgres_storage:

services:
  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - postgres_storage:/var/lib/postgresql/data
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -h localhost -U ${POSTGRES_USER} -d ${POSTGRES_DB}']
      interval: 5s
      timeout: 5s
      retries: 10

  n8n:
    image: n8nio/n8n:2.14.2
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_USER=${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_USER_MANAGEMENT_JWT_SECRET=${N8N_USER_MANAGEMENT_JWT_SECRET}
      - N8N_DIAGNOSTICS_ENABLED=false
    volumes:
      - n8n_storage:/home/node/.n8n
    depends_on:
      postgres:
        condition: service_healthy
```

### AI Content Summarizer Workflow

LLM Prompt:

```
Summarize the following web page content in 3-5 bullet points. Focus on the key facts and actionable information. Return the summary as JSON with the format: {"title": "...", "bullets": ["...", "..."], "word_count": N}

Content:
{{ $json.data }}
```

Test:

```bash
curl -X POST http://localhost:5678/webhook/summarize \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

### Production: Reverse Proxy with Caddy

```yaml
caddy:
  image: caddy:2-alpine
  restart: unless-stopped
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./Caddyfile:/etc/caddy/Caddyfile
    - caddy_data:/data
```

```
n8n.yourdomain.com {
    reverse_proxy n8n:5678
}
```

### Backup Script

```bash
#!/bin/bash
BACKUP_DIR="/backups/n8n/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"
docker compose exec -T postgres pg_dump -U n8n_user n8n > "$BACKUP_DIR/n8n-db.sql"
docker run --rm -v n8n_storage:/data -v "$BACKUP_DIR":/backup alpine \
  tar czf /backup/n8n-storage.tar.gz -C /data .
echo "Backup completed: $BACKUP_DIR"
```

### Pulling Additional Ollama Models

```bash
docker compose exec ollama ollama pull mistral
docker compose exec ollama ollama pull codellama
docker compose exec ollama ollama pull nomic-embed-text
```

### Cost Comparison

- n8n Cloud Pro: ~$60/month for 30,000 executions
- Self-hosted on $5 VPS: unlimited executions
