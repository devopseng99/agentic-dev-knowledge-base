---
title: "HANDOVER + SYNC: multi-agent coordination without a central scheduler"
url: "https://dev.to/amanbhandari/handover-sync-multi-agent-coordination-without-a-central-scheduler-20dc"
author: "Aman Bhandari"
category: "agent-research-testing"
---
# HANDOVER + SYNC: multi-agent coordination without a central scheduler
**Author:** Aman Bhandari  **Published:** April 19, 2026

## Overview
Presents a decentralized coordination pattern for managing multiple Claude Code agents across separate repositories without requiring central scheduling infrastructure. Uses two markdown files following distinct operational patterns to maintain data integrity and intent clarity.

## Key Concepts
1. **Two-File Architecture:**
   - `HANDOVER.md`: Single-writer, append-only data log (facts)
   - `SYNC.md`: Bidirectional intent file with per-agent sections
2. **Core Principle** — Separates "data" (what happened) from "intent" (what's planned next) to prevent conflation and accidental overwrites
3. **Technical Components:**
   - Single-writer append-only pattern for reliability
   - Per-agent section ownership in shared file
   - `.last-processed.md` markers for incremental consumption
   - `CLAUDE.md` precedence rules ensuring agent autonomy
4. **Scope Limitations** — Designed for 2-10 agent teams; async workflows only; no real-time coordination capability
