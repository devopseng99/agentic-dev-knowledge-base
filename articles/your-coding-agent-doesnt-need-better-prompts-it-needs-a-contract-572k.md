---
title: "Your Coding Agent Doesn't Need Better Prompts. It Needs a Contract."
url: "https://dev.to/fabibi/your-coding-agent-doesnt-need-better-prompts-it-needs-a-contract-572k"
author: "Fabibi"
category: "erp-business-law"
---
# Your Coding Agent Doesn't Need Better Prompts. It Needs a Contract.
**Author:** Fabibi  **Published:** May 2, 2026

## Overview
Addresses a critical failure mode in AI-driven code generation: silent drift. "A prompt asks the agent to behave. A contract gives the repo a way to reject behavior it never approved." The real danger is "plausible code that passes tests, implements something close to the request, and expands the product surface in a direction nobody approved."

## Key Concepts

**The Problem: Quiet Drift**
An agent implementing `scan --json` with three specified keys (anchors, mappings, findings) adds a `meta` key with diagnostics. Tests pass because they only validate expected fields exist — they don't reject unexpected ones. The code ships undetected.

**Three Operating Principles**
1. Contract-first: Observable behavior defined before implementation. `docs/contract.md` specifies commands, outputs, schemas, exit codes, and determinism rules.
2. Eval-driven: Verification gates derived from contract enforce compliance. Byte-for-byte golden testing catches schema drift.
3. Scope-closed: Agents cannot invent behavior outside the contract.

**Four-File Bootstrap**
- AGENTS.md: Entry map stating that `docs/` is authoritative
- docs/contract.md: Observable runtime behavior specification
- docs/evals.md: Verification gates and test fixtures
- docs/tasks.md: Execution plan with current task state

**Closed JSON Schema Validation**
```javascript
// Instead of permissive:
expect(result).toHaveProperty('anchors');

// Use closed bounds:
expect(Object.keys(result)).toEqual([
    "anchors",
    "mappings",
    "findings"
]);
```

Or with JSON Schema:
```json
{
    "type": "object",
    "properties": {
        "anchors": {},
        "mappings": {},
        "findings": {}
    },
    "additionalProperties": false
}
```

**When NOT to Use This Approach**
Exploratory prototypes or throwaway scripts. Framework pays dividends when: observable behavior others depend on, quiet drift becomes compatibility problems, surface stability matters.

**Cultural Shift**
From "validate what you expect" (Postel's Law) to "reject what you didn't authorize" — "Agents don't need latitude — they need walls."
