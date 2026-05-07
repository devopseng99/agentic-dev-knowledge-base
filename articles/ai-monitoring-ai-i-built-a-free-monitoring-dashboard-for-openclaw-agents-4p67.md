---
title: "AI monitoring AI - I built a free monitoring dashboard for OpenClaw agents"
url: "https://dev.to/flik2002/ai-monitoring-ai-i-built-a-free-monitoring-dashboard-for-openclaw-agents-4p67"
author: "flik2002"
category: "ai-agent-observability"
---

# "AI monitoring AI" - I built a free monitoring dashboard for OpenClaw agents

**Author:** flik2002
**Published:** May 4, 2026

## Overview
A self-hostable monitoring dashboard for OpenClaw agents with heartbeat detection, gateway management, real-time status, JWT auth, and i18n support (EN/CN).

## Key Concepts

### Problem
OpenClaw has no built-in status page, heartbeat alerts, or way to see if agents are processing tasks or sitting idle.

### Tech Stack
- Frontend: Vue 3 (Composition API) + Element Plus + Vite
- Backend: Express + SQLite (sql.js)
- Auth: JWT
- i18n: Chinese + English

### Features
- Heartbeat Detection - knows immediately when agents go down
- Gateway Management - manage multiple gateway configs from one UI
- Real-time Status - live view of agent operations
- Responsive design for desktop and mobile

## Code Examples

### Quick Start

```bash
git clone https://github.com/flik2002/openclaw-monitor-frontend.git
cd openclaw-monitor-frontend
npm install
npm run dev
```
