---
title: "Building a Personal Agent"
url: "https://dev.to/juhapellotsalo/building-a-personal-agent-502l"
author: "Juha Pellotsalo"
category: "full-code-examples"
---

# Building a Personal Agent
**Author:** Juha Pellotsalo
**Published:** April 28, 2026

## Overview
Building a personal AI agent using Claude Code as the harness with a file-system-based architecture using markdown and YAML for data storage. Covers skills, CLIs, memory systems, and background daemons.

## Key Concepts

### Core Architecture
- Each session starts by loading `AGENT.md` (or `CLAUDE.md`) containing agent identity, principles, and skill organization
- Skills: Playbooks containing instructions for CLI calls
- CLIs: Custom bash commands (calendar-cli, gmail-cli, drive-cli, reddit-cli, youtube-cli)
- File System Database: Markdown and YAML files with folder structure as schema

### Data Storage Pattern

```markdown
---
id: project-axiom
status: active
priority: high
related: [agent-system, langgraph-experiments]
---

# The Axiom

Notes and references...
```

### Memory System
- Journal files organized by date: `memory/journal/YYYY-MM/DD.md`
- File-based SQLite-vec indexing with dynamic chunking
- Hybrid retrieval: vector similarity blended with BM25 keyword scores at 70/30 ratio

### Knowledge Bases
Raw notes compile nightly into continuously-updated wikis per project.

### Background Daemon
Headless agent sessions run on schedule; heartbeat task backs up system to git every 30 minutes.

### Web Layer
Small Trello-like web app reads the same raw markdown files the agent does for board visualization.

### GitHub Reference
- ALS validation tool: https://github.com/nfrith/als
