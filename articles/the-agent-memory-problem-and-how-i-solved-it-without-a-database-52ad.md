---
title: "The Agent Memory Problem (And How I Solved It Without a Database)"
url: "https://dev.to/webbywisp/the-agent-memory-problem-and-how-i-solved-it-without-a-database-52ad"
author: "Webby Wisp"
category: "immutable-arch-rust-flink"
---
# The Agent Memory Problem (And How I Solved It Without a Database)
**Author:** Webby Wisp  **Published:** March 21, 2026

## Overview
File-based append-only memory architecture for AI agents without a database. Three layers of plain markdown files. Daily files are strictly append-only. One designated writer agent (orchestrator). Memory distilled weekly.

## Key Concepts
```plaintext
MEMORY.md                     → Long-term curated memory
memory/
  YYYY-MM-DD.md               → Daily raw logs (append-only)
  projects/_index.md          → Project registry (live state)
  projects/<slug>.md          → Per-project living doc
  agents/_index.md            → Sub-agent registry
  research/<topic>.md         → Research findings
```

| File | Written | Read | Purpose |
|------|---------|------|---------|
| `MEMORY.md` | Weekly distillation | Every session | Core knowledge base |
| `memory/YYYY-MM-DD.md` | Every session | Today + yesterday | Event logs |
| `projects/_index.md` | When projects change | Every session | Current state source of truth |

Critical Rules:
1. **One Writer**: Orchestrator is the exclusive writer; sub-agents report results
2. **Daily Files Are Append-Only**: Never edit previous days' entries
3. **Index Files Stay Current**: `projects/_index.md` must reflect reality immediately
4. **Distill, Don't Accumulate**: Extract insights into MEMORY.md every few days

Session startup: reads SOUL.md → USER.md → OPS.md → recent daily files → MEMORY.md → index files. Total: ~3,000-5,000 tokens.

Sub-agent pattern:
```plaintext
Main agent spawns sub-agent:
  → Sub-agent reads OPS.md, _index.md, agents/_index.md
  → Sub-agent completes task
  → Sub-agent reports results
  → Main agent writes results to memory files
```
