---
title: "Tutorial: Set Up Your First AI Agent Team in 5 Minutes"
url: "https://dev.to/bridgeace/tutorial-set-up-your-first-ai-agent-team-in-5-minutes-21gk"
author: "Bridge ACE"
category: "agent-team-coordination"
---
# Tutorial: Set Up Your First AI Agent Team in 5 Minutes
**Author:** Bridge ACE  **Published:** March 18, 2026

## Overview
Step-by-step guide to launching a coordinated multi-agent AI system using Bridge ACE with three agents working in parallel.

## Key Concepts

### Installation
```bash
git clone https://github.com/Luanace-lab/bridge-ide.git
cd bridge-ide
./install.sh
./Backend/start_platform.sh
```

### Team Configuration
```json
{
  "agents": [
    {
      "id": "coordinator",
      "role": "Project Coordinator",
      "engine": "claude",
      "scope": ["*"]
    },
    {
      "id": "backend",
      "role": "Backend Developer",
      "engine": "codex",
      "scope": ["src/api/", "src/models/"]
    },
    {
      "id": "frontend",
      "role": "Frontend Developer",
      "engine": "claude",
      "scope": ["src/ui/", "src/components/"]
    }
  ]
}
```

### UI Endpoints
- Chat: `http://localhost:9111/chat.html`
- Config: `http://localhost:9111/project_config.html`
- Control Center: `http://localhost:9111/control_center.html` — live status, cost analysis, task board

### Background Operations
- Individual tmux sessions per agent with filesystem access
- Real-time WebSocket communication
- 16 background daemons managing health, crashes, rate limiting
- File protection through Scope Locks
