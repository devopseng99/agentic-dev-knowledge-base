---
title: "I Ran a 5-Agent Game Studio with Claude Code Teams"
url: "https://dev.to/yurukusa/i-ran-a-5-agent-game-studio-with-claude-code-teams-2lpk"
author: "Yurukusa"
category: "ai-agent-game-development"
---

# I Ran a 5-Agent Game Studio with Claude Code Teams

**Author:** Yurukusa
**Published:** February 19, 2026

## Overview
Five AI agents running Claude Opus 4.6 in parallel managed game development tasks, completing 9 of 17 tasks in a single session including game improvements, asset creation, market research, and metrics collection.

## Key Concepts

### The Five-Agent Team

| Agent | Role | Responsibilities |
|-------|------|------------------|
| builder | Developer | Game feel improvements, hit-stop mechanics, particles |
| designer | Designer | Screenshots, GIF animation, cover images |
| researcher | Researcher | SDK requirements, game concept selection |
| grower | Growth analyst | Cross-platform metrics (5 platforms tracked) |
| shipper | Shipper | itch.io page planning, submission staging |

### Architecture

Configuration stored in two directories:
- `~/.claude/teams/{team-name}/config.json` — roles, prompts, models
- `~/.claude/tasks/{team-name}/` — task ownership, status, dependencies

Tasks use `blockedBy` fields to enforce sequential ordering when needed.

### Results
- Task completion: 9/17 completed (53%), 5 in progress, 3 pending/blocked
- Dependency management prevented coordination failures automatically
- Role specialization eliminated file conflicts and merge issues
- The article itself was authored by the "grower" agent while other agents continued working
