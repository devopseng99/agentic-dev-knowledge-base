---
title: "We Built a 31-Agent AI Team That Hires Itself, Critiques Itself, and Dreams"
url: "https://dev.to/ikhaled_elazab/we-built-a-31-agent-ai-team-that-hires-itself-critiques-itself-and-dreams-35dj"
author: "Khaled Elazab"
category: "swarm-orchestration"
---
# We Built a 31-Agent AI Team That Hires Itself, Critiques Itself, and Dreams
**Author:** Khaled Elazab  **Published:** April 22, 2026

## Overview
Self-evolving multi-agent system built on Claude Code: 31 agents across 8 tiers, 341 passing structural contract tests, dynamic hiring pipeline, and Shadow Mind parallel cognitive layer. Open source at https://github.com/asiflow/claude-nexus-hyper-agent-team

## Key Concepts

### 8-Tier Architecture
- TIER 1 (BUILDERS): elite-engineer, ai-platform-architect, frontend-platform-eng, beam-architect, elixir-engineer, go-hybrid-engineer
- TIER 2 (GUARDIANS): language experts, deep-qa, deep-reviewer, infra-expert, database-expert, observability-expert, test-engineer, api-expert, beam-sre
- TIER 3 (STRATEGISTS): deep-planner, orchestrator
- TIER 4 (INTELLIGENCE): memory-coordinator, cluster-awareness, benchmark-agent, erlang-solutions-consultant, talent-scout, intuition-oracle
- TIER 5 (META-COGNITIVE): meta-agent, recruiter
- TIER 6 (GOVERNANCE): session-sentinel
- TIER 7: cto
- TIER 8 (VERIFICATION): evidence-validator, challenger

### Innovation 1: Contract-Tested Agent Prompts
341 structural assertions (11 invariants × 31 agents) via pre-commit hooks.

### Innovation 2: NEXUS Syscall Protocol
```javascript
// From inside a running agent:
SendMessage({
  to: "lead",
  message: "[NEXUS:SPAWN] elite-engineer | name=ee-sse-fix | prompt=Fix SSE bug",
})

// Main thread response:
SendMessage({
  to: "original-agent",
  message: "[NEXUS:OK] ee-sse-fix spawned"
})
```

Syscall vocabulary: `SPAWN`, `SCALE`, `RELOAD`, `MCP`, `ASK`, `CRON`, `WORKTREE`, `INTUIT`, `PERSIST`

### Innovation 3: Dynamic Hiring (8-Phase Pipeline)
1. Parse requisition
2. Deep-research domain with citations
3. Mine scar-tissue from adjacent agent memory
4. Synthesize prompt matching AGENT_TEMPLATE.md
5. Run contract tests (3 iteration cap)
6. Route through challenger for adversarial review
7. Hand off to meta-agent for atomic registration
8. Track probation for 5 dispatches

### Innovation 4: Shadow Mind — Parallel Non-Invasive Cognition
Six components: Observer Daemon, Pattern Computer, Pattern Library, Speculator, Dreamer, Intuition Oracle.

Critical: "the conscious layer has zero dependency on the unconscious layer" — verified by disabling Shadow Mind, 341/341 tests still pass.

#### INTUIT Response Format
```yaml
INTUIT_RESPONSE v1
confidence: MEDIUM_CONFIDENCE
sample_size: 54
answer: |
  Pattern matched 3 times in last 90 days.
caveats:
  - n-gram corpus is small: 54 observations
shadow_mind_freshness:
  staleness_flag: FRESH
```

### 5-Week Production Results
- 67 trust-ledger verdicts across 13 agents
- 341/341 contract tests passing on every commit
- 506 signal-bus entries: 138 memory-handoffs, 126 NEXUS syscalls, 59 cross-agent flags
- Parallel code review 3min vs 15min serial

### 10 Novel Patterns
1. Contract-Tested Agent Prompts
2. NEXUS Syscall Protocol with Role-Specific Allowlists
3. Trust Ledger with Bayesian Priors + Lifecycle Status
4. Pair Protocol for Paired Dispatch
5. Shadow Mind — Parallel Non-Invasive Cognition
6. Dynamic Hiring Pipeline
7. Adversarial Self-Review
8. Canonical Signal-Bus Entry Format as Contract
9. Single-Writer Invariant Over Agent Prompts
10. Delete-to-Disable Architecture
