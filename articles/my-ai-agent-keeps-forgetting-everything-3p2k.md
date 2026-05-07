---
title: "My AI Agent Keeps Forgetting Everything"
url: "https://dev.to/snewhouse/my-ai-agent-keeps-forgetting-everything-3p2k"
author: "Stephen J Newhouse"
category: "immutable-arch-rust-flink"
---
# My AI Agent Keeps Forgetting Everything
**Author:** Stephen J Newhouse  **Published:** April 7, 2026

## Overview
AA-MA Forge: five-file memory architecture for AI coding agents with adversarial verification, HITL/AFK task dispatch, and compaction hooks. Designed for regulated industries and multi-week timelines. Built by a developer with multiple sclerosis where repeating context has real cognitive cost.

## Key Concepts
Five files separating knowledge by behavioral type:
1. **Immutable reference file** — API endpoints, file paths, constants
2. **Decisions log** — architectural choices and trade-offs
3. **Task state file** — current progress and what's next
4. **Plan document** — milestones and acceptance criteria
5. **Provenance log** — commits and session checkpoints (append-only)

Features:
- **11 mandatory planning outputs** including executive summaries and risk registers
- **6-angle adversarial verification** attacking plans from independent perspectives
- **HITL/AFK task dispatch** distinguishing human-required from autonomous tasks
- **HARD/SOFT milestone gates** for approval workflows
- **Compaction hook** preserving context when Claude Code's window fills
- **Complexity routing** for tasks scoring 80%+ on weighted algorithms

```shell
# Plan: brainstorm with the agent, then generate structured artifacts
/aa-ma-plan "build a REST API for user authentication"

# Execute: work through each milestone, sync the files, commit
/execute-aa-ma-milestone

# Archive: move completed work to the done pile
/archive-aa-ma auth-api
```

**Source:** https://github.com/snewhouse/aa-ma-forge
