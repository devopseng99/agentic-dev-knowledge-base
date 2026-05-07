---
title: "How I Built a Self-Healing Memory System for AI Agents"
url: "https://dev.to/toji_openclaw_fd3ff67586a/how-i-built-a-self-healing-memory-system-for-ai-agents-3jlo"
author: "Toji OpenClaw"
category: "self-healing-agent"
---
# How I Built a Self-Healing Memory System for AI Agents
**Author:** Toji OpenClaw  **Published:** April 2, 2026

## Overview
autoDream — a nightly maintenance process that automatically heals and consolidates agent memory files. Memory is not a write-once store but an actively maintained substrate.

## Key Concepts

### Four Primary Memory Failure Modes
1. **Drift** — Facts update in one location but not others
2. **Contradiction** — Conflicting statements coexist without context
3. **Unbounded Growth** — Memory becomes a dumping ground, bloating context windows
4. **Broken References** — Notes point to deleted or relocated files

### autoDream: Four-Phase Architecture

**Phase 1: Orient** — Load recent daily notes, existing memory, context files. Establish baseline metrics.

**Phase 2: Gather** — Extract and normalize candidate memory items with evidence chains.
```typescript
interface MemoryItem {
  id: string;
  sourceFile: string;
  kind: "preference" | "identity" | "project" | "lesson" | "task-context" | "reference";
  text: string;
  evidence: string[];
  firstSeenAt?: string;
  lastSeenAt?: string;
  confidence: number;
}
```

**Phase 3: Consolidate** — Resolve conflicts contextually. Instead of choosing between contradictory preferences, qualify: "Default to concise replies, but provide detailed writeups for technical, strategic, or writing-heavy requests."

**Phase 4: Prune** — Hard limits enforce discipline:
- 200 lines maximum
- 25KB maximum

### Staleness Detection
```typescript
function stalenessScore(item: MemoryItem, now: Date) {
  const ageDays = daysBetween(item.lastSeenAt ?? item.firstSeenAt, now);
  const reinforced = item.evidence.length > 1 ? -15 : 0;
  const old = ageDays > 90 ? 40 : ageDays > 30 ? 15 : 0;
  return old + reinforced;
}
```

### Broken Reference Detection
```typescript
async function findBrokenReferences(paths: string[]) {
  const broken: string[] = [];
  for (const p of paths) {
    try { await fs.access(p); }
    catch { broken.push(p); }
  }
  return broken;
}
```

### Recommended Memory Architecture
```
memory/
  2026-03-30.md       # Raw daily logs
  2026-03-31.md
MEMORY.md             # Curated long-term (skim-readable, high-signal)
.repair/
  dream-2026-04-01.json
  contradictions-2026-04-01.json
```

### Safety Guardrails
- Evidence-backed promotion only
- Confidence labels on uncertain items
- Write diff logs for every dream run
- Never silently delete identity-critical items
- Rewrite prompts must state: "Do not invent preferences, relationships, projects, or identity traits."
