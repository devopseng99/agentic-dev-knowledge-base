---
title: "Building NetGenius Instructor Copilot: A Multi-Agent AI System on Google Cloud Run"
url: "https://dev.to/racampos/building-netgenius-instructor-copilot-a-multi-agent-ai-system-on-google-cloud-run-54if"
author: "Rafael Campos"
category: "hackathons"
---

# Building NetGenius Instructor Copilot: A Multi-Agent AI System on Google Cloud Run
**Author:** Rafael Campos
**Published:** November 11, 2025

## Overview
Four-agent orchestration system for automating networking lab creation. Reduces lab creation from 2-4 hours to 5-10 minutes. Built for the Google Cloud Run Hackathon.

## Key Concepts

### Four Agents
1. **Planner Agent** - Multi-turn conversations with instructors
2. **Designer Agent** - Generates network topology YAML and device configurations
3. **Author Agent** - Creates step-by-step lab guides with verification commands
4. **Validator Agent** - Headless network simulation and validation

### Deployment
```bash
gcloud builds submit --tag gcr.io/netgenius-hackathon/netgenius-orchestrator
gcloud run deploy netgenius-orchestrator \
  --image gcr.io/netgenius-hackathon/netgenius-orchestrator \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars GOOGLE_API_KEY=${GOOGLE_API_KEY}

gcloud run jobs create headless-runner \
  --image us-central1-docker.pkg.dev/netgenius-hackathon/netgenius/headless-runner:latest \
  --region us-central1 \
  --task-timeout 10m
```

- Cold start: ~2 seconds, Per-lab cost: ~$0.50
- Tech: Next.js on Vercel, FastAPI + Google ADK on Cloud Run, Gemini 2.5 Flash

### GitHub Repository
- https://github.com/racampos/cloud-run-hackathon

**Live Demo:** https://copilot.netgenius.ai
