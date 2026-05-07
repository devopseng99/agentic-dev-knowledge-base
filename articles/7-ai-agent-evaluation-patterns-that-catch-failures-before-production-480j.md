---
title: "7 AI Agent Evaluation Patterns That Catch Failures Before Production"
url: "https://dev.to/dohkoai/7-ai-agent-evaluation-patterns-that-catch-failures-before-production-480j"
author: "dohko"
category: "ai-agent-evaluation"
---

# 7 AI Agent Evaluation Patterns That Catch Failures Before Production

**Author:** dohko
**Published:** March 31, 2026

---

## Overview

The article addresses a critical gap in AI agent deployment: the space between "works in demo" and "works in production." It presents seven concrete evaluation patterns with production-ready Python code to catch failures before shipping to users.

---

## Pattern 1: Deterministic Output Assertions

Tests things you know should be true using simple Python assertions rather than LLM-based judging. The `DeterministicEvaluator` class validates output format, required fields, length limits, and content constraints.

**Key use case:** "Always. This is your first line of defense."

```python
@dataclass
class EvalCase:
    name: str
    input_prompt: str
    assertions: list[Callable[[str], bool]]
    max_tokens: int = 4096
    temperature: float = 0.0
```

---

## Pattern 2: Trajectory Evaluation

Evaluates the entire sequence of agent actions rather than single outputs. Checks whether agents exceed step limits, repeat tool calls, stay within cost budgets, and produce responses without errors.

```python
@dataclass
class Trajectory:
    task: str
    actions: list[AgentAction] = field(default_factory=list)
    final_output: str = ""
    total_tokens: int = 0
    total_cost_usd: float = 0.0
```

---

## Pattern 3: LLM-as-Judge Evaluation

Uses a separate LLM to evaluate quality across multiple criteria using a 1-5 scoring scale. The `LLMJudge` class supports configurable evaluation criteria and thresholds.

**Recommendation:** "Use a different model for judging than the one generating outputs."

---

## Pattern 4: Regression Testing with Golden Datasets

Maintains curated examples of known-good outputs and compares new outputs against them using similarity scoring. Catches degradation over time.

```python
@dataclass
class GoldenExample:
    id: str
    input_prompt: str
    expected_output: str
    tags: list[str]
    created_at: str
    similarity_threshold: float = 0.85
```

---

## Pattern 5: Cost & Latency Budgets

Enforces resource limits during execution using `BudgetGuard`. Tracks token usage, API costs, execution time, and tool calls against configured limits.

```python
@dataclass
class BudgetConfig:
    max_cost_usd: float = 1.00
    max_latency_ms: float = 30_000
    max_tokens: int = 50_000
    max_tool_calls: int = 15
```

---

## Pattern 6: Safety & Guardrail Checks

Detects prompt injection attempts, personally identifiable information leakage, and dangerous shell commands using regex patterns. Wraps agents with input/output safety validation.

**Blocked patterns include:**
- Prompt injection ("ignore all previous instructions")
- PII detection (SSNs, credit cards, emails, phone numbers)
- Dangerous commands (`rm -rf`, `drop database`)

---

## Pattern 7: Continuous Eval Pipeline

Integrates all patterns into a CI/CD-friendly pipeline that produces go/no-go deployment decisions based on pass rates, regression rates, latency, and costs.

```python
@dataclass
class EvalPipelineConfig:
    min_pass_rate: float = 90.0
    max_regression_rate: float = 5.0
    max_avg_latency_ms: float = 5000.0
    max_avg_cost_usd: float = 0.10
```

---

## Key Takeaways

1. Start with simple deterministic checks (catch 80% of issues)
2. Test complete trajectories, not just single outputs
3. Use LLM judges sparingly due to cost and non-determinism
4. Build golden datasets incrementally from verified outputs
5. Budget guards prevent runaway API costs
6. Guardrails protect users, company, and agent
7. Automate everything into CI pipelines

---

## Quick Start Checklist

- Add 5 deterministic assertions for output format
- Record one trajectory and add 3 checks
- Create 10 golden examples from best outputs
- Set $0.50/request cost budget maximum
- Add prompt injection detection to inputs
- Wire into CI pipeline
- Run evals on every pull request
