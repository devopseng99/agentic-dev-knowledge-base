---
title: "Building an AI Agent Supervisor: Series Index"
url: "https://dev.to/battyterm/building-an-ai-agent-supervisor-series-index-m4p"
author: "Batty"
category: "supervisor-agent-pattern"
---

# Building an AI Agent Supervisor: Series Index

**Author:** Batty
**Published:** April 5, 2026

## Overview

Series index for a 12-part series documenting the architecture, decisions, and lessons from building Batty -- a Rust CLI that supervises teams of AI coding agents in tmux. Open source, MIT licensed.

## Key Concepts

### The Architecture

- How to run multiple AI coding agents in parallel
- Building a tmux-native supervisor in Rust
- Why synchronous polling was chosen over async patterns
- How tmux became the runtime for agent teams

### The Patterns

- **Git worktrees** for agent isolation - each agent works in its own worktree
- **Markdown** as a task format for agents
- **Context rotation** when agents run out of memory
- **Validation and verification** of agent completion
- Test gating as the quality gate
- Exit code 0 means done

### The Practice

- Lessons from parallel agent execution
- Migration path from single to multi-agent systems
- Cost analysis of running multiple agents
- Orchestrator comparison for 2026

### Key Design Decisions

```
# Agent isolation via git worktrees
git worktree add ../agent-1-worktree feature/task-1
git worktree add ../agent-2-worktree feature/task-2
git worktree add ../agent-3-worktree feature/task-3

# Each agent runs in its own tmux pane
tmux new-session -d -s agents
tmux split-window -h
tmux split-window -v
```

### Tool

GitHub: https://github.com/battysh/batty
Built in Rust, MIT licensed.
