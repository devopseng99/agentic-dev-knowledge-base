---
title: "Cross-Repository Development with Antigravity"
url: "https://dev.to/gdg/cross-repository-development-with-antigravity-26be"
author: "Razan Fawwaz"
category: "ai-agent-game-development"
---

# Cross-Repository Development with Antigravity

**Author:** Razan Fawwaz
**Published:** April 2, 2026

## Overview
Antigravity is Google's latest IDE with an integrated AI Agent Manager. The article shows how to use Agent Rules for cross-repository development when a single Agent needs to operate across multiple separate repositories.

## Key Concepts

### The Problem
Antigravity lacks native "Linked Workspace" functionality, preventing a single Agent from seamlessly operating across multiple separate repositories.

### The Workaround: Agent Rules

```
You are working on a frontend project located at /path/to/frontend.
There is a paired backend project located at /path/to/backend (Go, net/http, SQLite).
Whenever a frontend change requires an API or backend change, apply those changes
to the backend project as well. Always keep both repositories in sync.
```

### Practical Implementation
Tested with a todo application featuring login and full CRUD functionality, integrated with a Go + net/http + SQLite backend. The agent recognized the rules immediately, requested approval before modifications, installed packages, developed the backend first, and then transitioned to frontend setup with Vite + React.
