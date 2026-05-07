---
title: "app.build -- Open-Source AI Agent That Builds Full-Stack Apps"
url: "https://dev.to/neon-postgres/appbuild-open-source-ai-agent-that-builds-full-stack-apps-1cmg"
author: "David Gomes"
category: "full-code-examples"
---

# app.build -- Open-Source AI Agent That Builds Full-Stack Apps
**Author:** David Gomes (Neon)
**Published:** June 4, 2025

## Overview
Neon launched app.build, an open-source agent that can build and deploy full-stack applications with end-to-end tests and automated deployments.

## Key Concepts

### GitHub Repository
https://github.com/appdotbuild

### Quick Start

```bash
npx @app.build/cli
```

Signs in with GitHub, creates a repository in your account, and deploys to the Internet with a real backend and database.

### Platform Features
1. Authentication provider (defaults to Neon Auth)
2. Hosted database (defaults to Neon Postgres)
3. Frontend and backend deployed immediately (Neon + Koyeb infrastructure)
4. Hosted repository on your own GitHub account

### Agent Architecture
- Divide-and-conquer principle: app creation decomposed into multiple independent tasks
- Tasks may have subtasks -- no reliance on LLMs generating large chunks at once
- Each task passes compilation, ESLint, and test checks
- Agent writes end-to-end tests and runs them as part of the generation pipeline
- Base template for web apps uses Fastify, Drizzle, React, Vite

### Local Running
Everything can run locally. Supports bringing your own models including self-hosted ones.

### CLI Capabilities
- Create new apps from scratch
- Iterate on previously created apps (add features or changes)
