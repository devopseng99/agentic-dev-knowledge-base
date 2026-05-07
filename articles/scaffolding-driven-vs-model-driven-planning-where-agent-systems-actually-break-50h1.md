---
title: "Scaffolding-Driven vs Model-Driven Planning: Where Agent Systems Actually Break"
url: "https://dev.to/eyorata/-scaffolding-driven-vs-model-driven-planning-where-agent-systems-actually-breakby-eyoel-nebiyu-50h1"
author: "Eyoel Nebiyu"
category: "llm-research-evals"
---
# Scaffolding-Driven vs Model-Driven Planning: Where Agent Systems Actually Break
**Author:** Eyoel Nebiyu  **Published:** May 6, 2026

## Overview
Analysis of where hybrid AI agent systems fail — specifically at the boundary between probabilistic model reasoning and deterministic execution scaffolding. Failures cluster at handoff points where uncertain interpretations become execution-ready actions prematurely.

## Key Concepts

### The Core Problem
Agent systems combine deterministic scaffolding (states, routers, policy gates) with model-based judgment. These hybrid systems look clean in demos but fail in production at the handoff point where the model's uncertain interpretation becomes the scaffolding's deterministic action.

### Three Decision Classes

**Class D — Deterministic-Owned:**
- Policy constraints
- Compliance checks
- Idempotency enforcement
- Sequencing rules
- These should never involve model judgment

**Class M — Model-Owned:**
- Intent parsing
- Ambiguity detection
- Entity extraction
- Clarification generation
- These should never be hardcoded

**Class H — Hybrid Arbitration:**
- Clarification vs. proceed decisions
- Branch selection under uncertainty
- These require structured negotiation between model and scaffolding

### The Operating Principle
"Model proposes, scaffolding ratifies before side effects."

The model suggests an interpretation and action. The scaffolding validates that interpretation meets completeness requirements before allowing execution. Side effects only occur after scaffolding validation.

### Two Common Failure Patterns

**Pattern 1: Mixed Intent**
User acceptance plus clarification in one message treated as single intent. Example: "Yes, delete the file — but which version?" gets parsed as pure acceptance, triggering deletion before the clarification is resolved.

**Pattern 2: Underspecified Acceptance**
Positive sentiment mapped directly to execution without completeness validation. "Sounds good" interpreted as confirmed execution even when required parameters are unspecified.

### Recommended Architecture Rules
1. Never let acceptance alone trigger side effects
2. Preserve uncertainty across model-to-router boundaries (don't coerce uncertain states to boolean)
3. Add intermediate states like `accepted_but_incomplete`
4. Use stricter gates for high-risk writes than reads
5. Log boundary artifacts (model confidence, extracted intent, validation result) for auditability

### Why This Matters for Agent Evaluation
Standard agent benchmarks present clean, unambiguous tasks. Production failures cluster in the ambiguous cases — exactly what benchmark design optimizes away. Agent evals need to include mixed-intent and underspecified scenarios as first-class test cases.
