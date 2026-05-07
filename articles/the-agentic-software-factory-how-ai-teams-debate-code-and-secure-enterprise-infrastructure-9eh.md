---
title: "The Agentic Software Factory: How AI Teams Debate, Code, and Secure Enterprise Infrastructure"
url: "https://dev.to/uenyioha/the-agentic-software-factory-how-ai-teams-debate-code-and-secure-enterprise-infrastructure-9eh"
author: "Ugo Enyioha"
category: "agent-consensus"
---
# The Agentic Software Factory: How AI Teams Debate, Code, and Secure Enterprise Infrastructure
**Author:** Ugo Enyioha  **Published:** February 26, 2026

## Overview
Multi-agent AI workflow for enterprise software development where Claude, Codex, and Gemini collaborate on architecture, implementation, and security review through structured Git-based processes.

## Key Concepts

### Factory Architecture — Three Model Lanes
- **Claude Opus 4**: Quality guardian (debate), Architecture review (implementation)
- **Gemini 3.1 Pro**: System architect (debate), QA validation (implementation)
- **GPT-5.3 Codex**: Implementation lead (debate), SecOps review (implementation)

### The Debate Protocol: Three-Round Design Convergence
Round 1: Divergent positions — Claude rejected custom handlers, Gemini proposed plugins, Codex introduced `txn_hash`.

Round 2: Challenge-based review — Gemini retracted plugin proposal after Claude's fault-isolation argument.

Round 3: Convergence on:
- External HTTP pre-issue action service
- RFC 9396 `authorization_details` field
- Mandatory DPoP for transaction-token requests
- Resource-server-side `txn_id` ledger for one-time use enforcement

### Implementation Results
PR #38: 7 files, 654 lines of code, DPoP validation and `txn_hash` integrity checks, 5 security-focused test cases.

### Tri-Model Review Pipeline

**Analysis Phase (Read-only)**
- Claude: response schema inconsistencies, module boundary concerns
- Gemini: unbounded request-body accumulation (blocking issue)
- Codex: independently identified same memory-exhaustion risk + overly-permissive DPoP validation

**Publishing Phase (Write-only)**
- Idempotency markers prevent duplicate comments during retries
- Identity validation ensures correct model attribution

Results: 10 canonical findings (F-01 through F-10), 1 cross-validated finding, prioritized action plan: P0/P1/P2.

### Key Learnings
1. **Adversarial Structure Over Consensus** — Highest-value outputs came from direct model-to-model challenges
2. **Separation of Analysis and Publishing** — Mixed read-write responsibilities created non-deterministic behavior
3. **Graceful Degradation Design** — Partial lane failures still produced useful cross-validated synthesis
4. **Specification Quality Amplification** — Strong input (RFC 9396, RFC 9449) → traceable architecture
