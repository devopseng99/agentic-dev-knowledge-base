---
title: "The Self-Driving Codebase: Full Agent Automation with Otter"
url: "https://dev.to/fiberplane/part-2-the-self-driving-codebase-full-agent-automation-with-otter-5406"
author: "Nele Lea"
category: "autonomous-operations"
---
# The Self-Driving Codebase: Full Agent Automation with Otter
**Author:** Nele Lea  **Published:** May 7, 2026

## Overview
This article explores autonomous agent automation in codebases, focusing on Otter — an opinionated monorepo template that combines enforcement layers with task management for AI-driven development.

## Key Concepts

### fp: Issue Tracking for Agents
The system uses fp, a local-first task tracker with markdown issues stored in `.fp/`. It enforces a structured lifecycle:
- Agents claim tasks before starting
- Progress logged at milestones via comments
- Commits attached to issues upon completion
- Full audit trails enable session reconstruction

### Three fp Extensions

**Auto-done:** Parent issues close automatically when all child issues complete, preventing orphaned epics.

**Check-before-done:** Tasks cannot be marked complete until `bun run check` passes, preventing degraded code from compounding across sessions.

**Update-docs:** Completion triggers reminders to update documentation and refresh drift anchors on modified code.

### Writing Effective Issues
High-quality issues include clear titles, sufficient context, and hierarchical subtasks:
- Parent: "Add rate limiting to GitHub adapter"
  - Validate schema
  - Return typed RateLimitError
  - Log retry attempts

### What `bun run check` Validates
1. oxlint (TypeScript issues)
2. oxfmt (formatting enforcement)
3. tsgo (native type checking)
4. ast-grep scan (architectural rules)
5. drift lint (documentation staleness)

Failures trigger self-correction by agents before task completion.

### Debugging Autonomous Sessions
fp comments create breadcrumb trails documenting agent progress. Effect traces with `EFFECT_TRACE=1` output structured JSON spans, enabling agents to verify behavior and identify failures without human replay.

### Code Examples

```bash
fp issue list --status todo
fp issue update --status in-progress <id>
fp comment <id> "progress note"
fp issue assign <id> --rev <commit>
fp issue update --status done <id>
```

```bash
bun run check
```

```bash
EFFECT_TRACE=1 bun run my-app 2>&1 | grep '"name":"fetchUser"'
```

### Current Limitations
The system handles sequential single-agent workflows but struggles with task dependencies. Parallel agents working the same codebase require explicit sequencing logic not yet solved out-of-box.
