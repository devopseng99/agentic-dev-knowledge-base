---
title: "Hosting Your AI Agent on Google Cloud VM: A Complete Setup Guide"
url: "https://dev.to/maitrish/hosting-your-ai-agent-on-google-cloud-vm-a-complete-setup-guide-556m"
author: "Maitrish Mukherjee"
category: "cloud-agents"
---

# Hosting Your AI Agent on Google Cloud VM: A Complete Setup Guide
**Author:** Maitrish Mukherjee
**Published:** April 18, 2026

## Overview
Step-by-step guide for deploying an OpenClaw AI agent on a Google Cloud free-tier VM (f1-micro, Debian 12) with Telegram integration, Cloudflare Tunnel for HTTPS, pm2 for process management, and cron jobs for automation.

## Key Concepts

### Node.js Setup

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install 20
nvm use 20
```

### OpenClaw Installation

```bash
npm install -g openclaw
openclaw init
```

### Environment Configuration

```bash
# .env file (chmod 600)
OPENCLAW_TOKEN=...
TELEGRAM_BOT_TOKEN=...
DEVTO_API_KEY=...
GITHUB_TOKEN=...
```

### Cloudflare Tunnel for Public HTTPS

```bash
cloudflared tunnel --url http://localhost:18789
```

### Process Management with pm2

```bash
npm install -g pm2
pm2 start --name openclaw "openclaw gateway start"
pm2 save
pm2 startup
```

### Cost
Free with Google Cloud free tier indefinitely for personal projects using f1-micro instances.
