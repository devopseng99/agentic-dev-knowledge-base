---
title: "5 AI Agent Error Handling Patterns That Keep Your Agent Running at 3 AM"
url: "https://dev.to/thedailyagent/5-ai-agent-error-handling-patterns-that-keep-your-agent-running-at-3-am-2j0j"
author: "The Daily Agent"
category: "error-handling"
---

# 5 AI Agent Error Handling Patterns That Keep Your Agent Running at 3 AM

**Author:** The Daily Agent
**Date Published:** April 29, 2026

## Overview

This article addresses a critical vulnerability in production AI agents: silent failures that look exactly like success. Traditional error handling designed for deterministic systems fails to catch the confidence errors of probabilistic AI models.

## The Core Problem

"The most dangerous failures look exactly like success." An agent confidently mapped fields incorrectly and wrote corrupted data -- all with 200 OK responses. Nothing crashed, making detection difficult.

## Five Error Handling Patterns

### Pattern 1: Quality-Aware Circuit Breakers

Extends traditional circuit breakers beyond HTTP status codes to track output quality failures. The pattern tracks three states:

- **CLOSED:** Normal operation
- **OPEN:** Stop requests after repeated quality failures
- **HALF_OPEN:** Allow probe requests to test recovery

**Key implementation:** Record failures when LLM outputs violate schema or semantic invariants, not just when transport fails.

```python
class QualityCircuitBreaker:
    def record_quality_failure(self):
        """Called when LLM output fails validation (not HTTP error)."""
        self.failures += 1
        self.last_failure_time = time.time()
        if self.failures >= self.failure_threshold:
            self.state = CircuitState.OPEN

    def allow_request(self) -> bool:
        if self.state == CircuitState.CLOSED:
            return True
        if self.state == CircuitState.OPEN:
            elapsed = time.time() - self.last_failure_time
            if elapsed >= self.reset_timeout:
                self.state = CircuitState.HALF_OPEN
                return True
            return False
        return True  # Half-open: allow exactly one probe
```

**Insight:** When circuits open, stop burning tokens. Implement model fallback chains for degraded states.

---

### Pattern 2: Validation Gates Before Tool Execution

"Never let an agent's output directly trigger a side effect. Always validate before execution."

Three validation layers:

1. **Schema validation** -- Is output structurally correct?
2. **Sanity checks** -- Does the action make sense (e.g., delete limits)?
3. **Boundary enforcement** -- Is the agent within scope (e.g., no production table access)?

```python
class ValidationGate:
    def validate(self, call: ToolCallValidation) -> tuple[bool, str]:
        # 1. Schema: is this a known tool?
        if call.tool_name not in ALLOWED_TOOLS | DESTRUCTIVE_TOOLS:
            return False, f"Unknown tool: {call.tool_name}"

        # 2. Sanity: does the action make sense?
        if call.tool_name == "delete_record":
            count = call.parameters.get("count", 1)
            if count > MAX_DELETE_COUNT:
                return False, (
                    f"Delete count {count} exceeds limit of {MAX_DELETE_COUNT}"
                )

        # 3. Boundary: is the agent in allowed scope?
        if call.tool_name == "query_database":
            table = call.parameters.get("table")
            if table == "production_billing":
                return False, "Agent cannot access production_billing"

        return True, "OK"
```

**Design principle:** Constrain what agents can do to prevent errors at the source.

---

### Pattern 3: Idempotent Sagas for Multi-Step Workflows

Multi-step agents face compounding failure risk. "A 95% success rate per step yields only 60% completion for 10-step workflows (0.95^10)."

The saga pattern adds:

- **Checkpoint recording** before execution
- **Idempotency** through skipping already-completed steps on retry
- **Compensation actions** for rollback

```python
class SagaExecutor:
    def execute(self, steps: list[SagaStep]) -> dict[str, str]:
        completed_steps = []

        for step in steps:
            if self._is_completed(step.name):
                continue  # Idempotent: skip already-completed steps

            try:
                result = step.execute()
                self._record_checkpoint(step.name, str(result))
                completed_steps.append(step)
            except Exception as e:
                # Rollback: execute compensation in reverse order
                for completed in reversed(completed_steps):
                    if completed.compensate:
                        completed.compensate()
                raise

        return {s.name: "completed" for s in steps}
```

**Classification:** Categorize every step as read-only, pure function, reversible, compensatable, or irreversible. Only irreversible steps need the most validation.

---

### Pattern 4: Budget Guardrails for Runaway Loops

Prevent infinite reasoning loops through dual budgets:

**Token Budget:**
```python
@dataclass
class TokenBudget:
    max_tokens: int = 50_000
    used_tokens: int = 0
    cost_per_1k: float = 0.01

    def is_exhausted(self) -> bool:
        return self.used_tokens >= self.max_tokens

    def estimate_cost(self) -> float:
        return (self.used_tokens / 1_000) * self.cost_per_1k
```

**Cycle Budget:**
```python
@dataclass
class CycleBudget:
    max_cycles: int = 15
    current_cycle: int = 0

    def increment(self) -> bool:
        """Returns True if cycles remain."""
        self.current_cycle += 1
        return self.current_cycle <= self.max_cycles
```

**Enforcement:** When exhausted, agents must return results or escalate -- never continue silently.

---

### Pattern 5: Observability and Escalation Hooks

The article establishes observability as foundational, enabling rapid incident response when patterns fail. Escalation hooks define what happens when multiple safeguards trigger.

## Key Takeaways

- **Probabilistic systems need probabilistic error handling.** HTTP status codes alone miss silent data corruption.
- **Defense in depth:** Each pattern catches different failure modes.
- **Cost visibility matters:** Budget guardrails prevent expensive runaway loops.
- **Idempotency is essential:** Multi-step workflows need checkpointing and compensation actions.
- **Validate before execution:** Gatekeeping prevents unexpected deletions from agent hallucinations.
