---
title: "Runtime Constitutional AI: Validating Every Agent Action Before Execution"
url: "https://dev.to/zer0h1ro/runtime-constitutional-ai-validating-every-agent-action-before-execution-546c"
author: "Anton Illarionov"
category: "llm-eval-alignment"
---
# Runtime Constitutional AI: Validating Every Agent Action Before Execution
**Author:** Anton Illarionov  **Published:** February 23, 2026

## Overview
ODEI applies constitutional AI principles at runtime — validating actions before an autonomous agent takes them. Unlike training-time constitutional AI which constrains model outputs during learning, runtime constitutional AI prevents duplicate actions, hallucinated references, and unauthorized operations in production.

## Key Concepts

### Training-Time vs. Runtime

| Approach | Timing | Strengths |
|----------|--------|-----------|
| Training-time | During model training | Works well for content generation |
| Runtime | Before every execution | Prevents production errors, validates current context |

### Seven Runtime Constitutional Checks
1. **Immutability** — Prevents modification of locked entities like completed transactions
2. **Temporal Context** — Validates action timing; instructions and sessions have expiration windows
3. **Referential Integrity** — Confirms referenced entities exist; addresses the #1 LLM failure mode: confident references to things that do not exist
4. **Authority** — Verifies agent authorization against governance rules
5. **Deduplication** — Detects repeated actions via content-hashing parameters
6. **Provenance** — Traces instructions to trusted sources
7. **Constitutional Alignment** — Applies highest-level safety principles

### Production Results (ODEI on Virtuals Protocol ACP, since January 2026)
- 92% task success rate
- Zero hallucination errors
- Zero duplicate actions
- ~20% escalation rate for human review

### Code Example

```python
result = requests.post(
    "https://api.odei.ai/api/v2/guardrail/check",
    json={"action": "transfer 500 USDC to 0x...", "severity": "high"}
).json()

# verdict: APPROVED | REJECTED | ESCALATE
```

### Conclusion
Runtime constitutional AI is complementary to training-time approaches. One prevents harm through outputs; the other through autonomous actions. Both are necessary for production-grade agent safety.
