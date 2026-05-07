---
title: "Steering AI Agents in Monorepos with AGENTS.md"
url: "https://dev.to/datadog-frontend-dev/steering-ai-agents-in-monorepos-with-agentsmd-13g0"
author: "Simon Boudrias"
category: "full-code-examples"
---

# Steering AI Agents in Monorepos with AGENTS.md
**Author:** Simon Boudrias
**Published:** September 26, 2025

## Overview
Using AGENTS.md files as steering documents for AI agents in monorepo codebases. Covers file structure, routing patterns, testing methodology, and Claude Code integration.

## Key Concepts

### File Structure & Routing

```
repo-root/
├── AGENTS.md
├── emails/
    └── AGENTS.md
├── go/
    └── services/
        └── AGENTS.md
└── .agents/
    └── unit-tests.md
```

Root AGENTS.md acts as router/map pointing to relevant documents. Nested files provide folder-specific context.

### Claude Code Integration
```
echo "Read @AGENTS.md" > CLAUDE.md
```

### Testing Methodology
1. Create example prompts for common engineering tasks
2. Store prompts in shared, editable locations
3. Test across multiple AI tools (Claude Code, Cursor, Codex CLI)
4. Iterate based on observed failures

### Customization
- Global preferences: `~/AGENTS.md`
- User-specific repo overrides: `.gitignored` `AGENTS.local.md`

### Organization Pattern
Platform teams provide scaffolding; product teams maintain domain-specific instructions, distributing expertise closer to where work happens.

### Key Insight
A well-maintained steering document is "the contract between your codebase and the agent ecosystem." Documents should be concise and designed for AI consumption, not human reading.
