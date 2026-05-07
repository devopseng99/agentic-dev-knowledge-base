---
title: "How I Built an 8-Agent AI Team That Ships Code Autonomously"
url: "https://dev.to/vikash_ruhil_a43b452d4a88/how-i-built-an-8-agent-ai-team-that-ships-code-autonomously-2j0h"
author: "Vikash Ruhil"
category: "agent-team-coordination"
---
# How I Built an 8-Agent AI Team That Ships Code Autonomously
**Author:** Vikash Ruhil  **Published:** February 8, 2026

## Overview
AI Agent Manager is a Claude Code plugin providing eight specialized AI agents for software development. Pure Markdown files with YAML frontmatter — no servers, no APIs, no infrastructure.

## Key Concepts

### Agent Configuration
```yaml
---
tools: [Read, Glob, Grep, Bash, Write, Edit]
model: sonnet
memory: project
skills:
  - supervisor-readiness
  - context-setup
  - quality-checklist
---
```

### The Eight Agents
1. **Launch Pad** — Readiness Planner (VALIDATE → DISCOVER → ANALYZE → DECOMPOSE → PACKAGE → REFINE)
2. **Supervisor** — Parallel Orchestrator (INIT → ACQUIRE → PLAN → EXECUTE → FINALIZE → LOOP)
3. **Context-Keeper** — Memory Manager (3-turn limit, preserves ~800 tokens)
4. **Worker** — Builder in isolated git worktrees (cannot execute git commits)
5. **Product Owner** — Requirements Translator (Given/When/Then criteria)
6. **Orchestrator** — Task Architect (EPIC, TASK, SUBTASK dependency graphs)
7. **Code Reviewer** — Quality Gatekeeper (PASS/FAIL/NEEDS_HUMAN)
8. **Red Team Reviewer** — Adversarial Auditor (FATAL/CRITICAL/WARNING/WEAKNESS)

### Parallel Execution: Git Worktrees
```
project/                    # Main worktree
../project-BD-12a/          # Worker A
../project-BD-12b/          # Worker B
../project-BD-12c/          # Worker C
```

### Getting Started
```bash
/plugin marketplace add ./
/plugin install ai-agent-manager-plugin@ai-agent-manager-marketplace

/launch-pad goal: "describe what you want to build"
/supervisor  # Let it run
```

### Three-Tier Quality Gates
1. Plugin Hooks — Automated via `SubagentStop` and `TaskCompleted`
2. Code Reviewer — Full pattern and security review
3. Red Team Reviewer — Optional adversarial audit pre-launch

### Key Insight
"Planning is not overhead — it's the highest-leverage activity." Launch Pad produces 200-400 lines of structured analysis before any execution begins.
