---
title: "The Missing Link Between AI Agents and the Code They Modify"
url: "https://dev.to/jimutt/the-missing-link-between-ai-agents-and-the-code-they-modify-kke"
author: "Jimmy Utterström"
category: "immutable-arch-rust-flink"
---
# The Missing Link Between AI Agents and the Code They Modify
**Author:** Jimmy Utterström  **Published:** March 25, 2026

## Overview
Decision-Linked Development (DLD): an append-only decision log inspired by event sourcing. Decisions are never edited, only superseded. Code annotations trigger context loading before agent changes. Tested on a solar-powered Raspberry Pi bird-recording station spanning hardware, Bun.js backend, PostgreSQL, and Astro/Svelte frontend — accumulated 99 decisions.

## Key Concepts
- Append-only decision log: every decision records what was decided, rationale, and related code sections
- Code annotations like `@decision(DL-XXX)` signal AI agents to read referenced decision before making changes
- Specifications generated from the log (derived, not authoritative)
- Works alongside manual coding in hybrid workflows

Slash commands:
```
/dld-plan          # Break features into decisions
/dld-implement     # Code a specific decision
/dld-decide        # Record a single decision
/dld-snapshot      # Regenerate documentation
/dld-audit         # Detect decision-code drift
/dld-retrofit      # Bootstrap decisions from existing code
```

Decision record format:
```yaml
---
id: DL-045
title: "Species/hour activity matrix on dashboard"
status: accepted
namespace: web
tags: [web-dashboard]
references:
  - path: apps/web/src/components/ActivityMatrix.svelte
  - path: apps/web/src/components/Dashboard.svelte
---

## Context
The dashboard is the landing page...

## Decision
Build a species/hour activity matrix as the main dashboard component...

## Rationale
The hour-by-species matrix gives an immediate overview of activity patterns...

## Consequences
- Needs a backend query...
- Color intensity scale needs careful design...
```

Code annotation:
```typescript
// @decision(DL-008)
function retryWithBackoff(fn: () => Promise<Response>): Promise<Response> {
  // ...
}
```

**Source:** https://github.com/jimutt/dld-kit
