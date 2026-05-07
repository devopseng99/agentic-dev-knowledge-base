---
title: "The Best Way to Do Agentic Development in 2026"
url: https://dev.to/chand1012/the-best-way-to-do-agentic-development-in-2026-14mn
author: Chandler
category: agentic-development
---

# The Best Way to Do Agentic Development in 2026

**Author:** Chandler
**Published:** January 23, 2026
**Updated:** February 10, 2026

## Overview

This article documents the author's evolution through different AI-assisted coding tools, culminating in a recommended stack of Claude Code enhanced with plugins and Conductor for orchestrating parallel development tasks.

## Main Content

### Claude Code: Foundation but Imperfect

The author acknowledges Claude Code as "an amazing tool" used by many colleagues, but found it initially underwhelming. While capable, it "never always worked well, nor did it ever seem to work on the first try." Performance improved with model upgrades (Sonnet 4.5 to Opus 4.5), but gaps remained.

### OpenCode + Oh-My-OpenCode: A Compelling Alternative

The author discovered this combination offered significant improvements, describing it as making developers feel like "an actual developer that lives on your machine." The plugin spawns subagents for context gathering and enables "ultrawork" mode for delegating background tasks.

**Key limitation:** Cost became prohibitive when Anthropic blocked subscription-based API access, forcing reliance on expensive API keys with persistent idle time during agent processing.

### Conductor: The Orchestration Layer

This macOS application (Windows/Linux coming soon) coordinates multiple git worktrees using Claude Code or OpenAI's Codex. Key features include:

- Tight Linear and GitHub integration
- Parallel agent execution across repositories
- One-click CI failure fixes and merge conflict resolution
- GitHub PR management from within the app

### Superpowers Plugin: The Game Changer

This Claude Code plugin dramatically improved performance through:

- Planning mode that asks clarifying questions
- Subagent spawning for context collection
- Testing suite integration to verify code quality
- Skill-based system matching Oh-My-OpenCode capabilities

### Supporting Plugins

**Context7:** Documentation provider enabling proper API usage on first attempts.

**Tavily:** Web search and research integration for discovering implementation patterns and undocumented features.

## Setup Instructions

### Claude Code Installation

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

### Plugin Installation

```bash
claude plugin marketplace add obra/superpowers-marketplace
claude plugin install superpowers@superpowers-marketplace
claude plugin install context7@claude-plugins-official
claude plugin install playwright@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
```

### Tavily Configuration

Add to `~/.claude/settings.json`:

```json
{
  "env": {
    "TAVILY_API_KEY": "tvly-YOUR_API_KEY"
  }
}
```

Then install skills:

```bash
npx skills add https://github.com/tavily-ai/skills
```

## Recommended Workflow

- Always use Planning mode
- Inject Linear/GitHub issues for context
- Leverage `/research` commands
- Run parallel agents across multiple worktrees
- Use NotebookLM for gathering context from documents
- Always attach issues to commands when Conductor ignores them

## Key Takeaway

Combining Conductor's orchestration capabilities with Claude Code's enhanced plugins creates a "force multiplier" enabling developers to tackle multiple issues in parallel while maintaining code quality standards.
