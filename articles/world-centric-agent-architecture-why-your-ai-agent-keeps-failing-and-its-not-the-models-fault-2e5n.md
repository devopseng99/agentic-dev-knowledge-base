---
title: "World-Centric Agent Architecture: Why Your AI Agent Keeps Failing (And It's Not the Model's Fault)"
url: "https://dev.to/eggp/world-centric-agent-architecture-why-your-ai-agent-keeps-failing-and-its-not-the-models-fault-2e5n"
author: "Jung Sungwoo"
category: "immutable-arch-rust-flink"
---
# World-Centric Agent Architecture: Why Your AI Agent Keeps Failing (And It's Not the Model's Fault)
**Author:** Jung Sungwoo  **Published:** December 30, 2025

## Overview
Proposes a paradigm shift where the world exists as an explicit, immutable entity separate from the intelligence system. Agent failures stem not from insufficient model intelligence but from poor world modeling. Introduces World-Centric Architecture with immutable snapshots and declarative patches.

## Key Concepts
Seven-layer Core Architecture with immutable snapshots:
- Layer 7: EXPLAIN — Structural interpretation
- Layer 6: PATCH/APPLY — Only mechanism for state changes
- Layer 5: EFFECT RUNTIME — External execution via handlers
- Layer 4: ACTION — Availability gates
- Layer 3: SNAPSHOT — Immutable state at a point in time
- Layer 2: DAG — Dependency graph for incremental recompute
- Layer 1: EXPRESSION — Pure computation (no side-effects)

```typescript
type Snapshot<T> = {
  readonly data: T;
  readonly computed: Record<string, unknown>;
  readonly validity: ConstraintResult;
  readonly version: number;
};

// Creating new state instead of mutation
const newSnapshot = applyPatches(snapshot, [
  set('user.email', 'new@example.com')
]);
```

```typescript
const SubmitAction = defineAction(AppState, () => ({
  availability: get('user.computed.isValid'),
  effect: effect('api.submit', {
    email: get('user.email'),
  }),
}));
```

```typescript
const result = explainAvailability(SubmitAction, snapshot);
// Returns: available: false with tree showing root causes
```

Trust Boundaries:
```
TRUSTED ZONE: Core, Orchestrator, Authority, Projection
UNTRUSTED ZONE: LLM Actor, External I/O

Firewall Principle:
LLM → Proposal → Authority → Approval → Core.apply()
NOT: LLM → State (forbidden)
```

Runtime Flow:
```
1. PROJECTION renders Snapshot → View
2. ACTOR observes View
3. ACTOR proposes ChangeSet
4. Wrap ChangeSet → Proposal
5. AUTHORITY decides (approved/rejected/changes_requested)
6. ORCHESTRATOR forwards to Core
7. CORE.executeAction()
   - Check availability
   - Resolve effect parameters
   - Execute handler → Patch[]
   - Apply patches → New Snapshot
   - Recompute affected values
8. Loop
```
