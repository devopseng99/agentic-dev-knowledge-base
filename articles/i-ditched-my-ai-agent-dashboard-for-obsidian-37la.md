---
title: "I Ditched My AI Agent Dashboard for Obsidian"
url: "https://dev.to/thedaviddias/i-ditched-my-ai-agent-dashboard-for-obsidian-37la"
author: "David Dias"
category: "agent-ui-frameworks"
---

# I Ditched My AI Agent Dashboard for Obsidian
**Author:** David Dias
**Published:** February 8, 2026

## Overview
Abandoned a React dashboard for managing AI agents in favor of Obsidian and markdown files synced via rsync, discovering that agents need data, not dashboards.

## Key Concepts
- Agents don't need dashboards, they need data
- File-based communication: agents read/write markdown files in organized folders
- Markdown files in synced folder eliminates database dependencies and UI maintenance
- Stack: Linux + OpenClaw + rsync over SSH via Tailscale + Obsidian with Dataview plugin
- Plain text enables debugging with CLI tools and git version control
- Resilience through transparency vs opaque system dependencies
