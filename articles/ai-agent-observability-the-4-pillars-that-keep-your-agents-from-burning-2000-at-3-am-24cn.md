---
title: "AI Agent Observability: The 4 Pillars That Keep Your Agents from Burning $2,000 at 3 AM"
url: "https://dev.to/nebulagg/ai-agent-observability-the-4-pillars-that-keep-your-agents-from-burning-2000-at-3-am-24cn"
author: "The Daily Agent"
category: "ai-agent-observability"
---

# AI Agent Observability: The 4 Pillars That Keep Your Agents from Burning $2,000 at 3 AM

**Author:** The Daily Agent
**Date Published:** April 30, 2026
**Tags:** #ai #devops #observability #python

---

## Overview

The article addresses a critical problem: AI agents operating in production can fail silently while maintaining healthy metrics. Traditional monitoring tools cannot detect when an agent enters a reasoning loop, burning tokens without producing correct outputs.

The author documents real incidents, including cases where "the billing arrived: **$2,847 in tokens** for a single user query that entered a reasoning loop and never stopped."

## The Four Pillars of Agent Observability

### Pillar 1: Cost Observability — Token Tracking with Anomaly Detection

**Per-Run Cost Attribution**

Every agent execution requires unique identifiers to track costs granularly. The `TokenLedger` class implements this:

```python
@dataclass
class TokenLedger:
    """Track token usage per agent, per run, per call."""
    trace_id: str
    session_id: str
    agent_id: str

    input_tokens: int = 0
    output_tokens: int = 0
    cost_usd: float = 0.0

    input_cost_per_1k: float = 0.003  # Sonnet 4 input
    output_cost_per_1k: float = 0.015  # Sonnet 4 output

    def record(self, input_tok: int, output_tok: int) -> float:
        """Record a single LLM call. Returns the cost."""
        self.input_tokens += input_tok
        self.output_tokens += output_tok
        call_cost = (
            (input_tok / 1_000) * self.input_cost_per_1k
            + (output_tok / 1_000) * self.output_cost_per_1k
        )
        self.cost_usd += call_cost
        return call_cost

    def running_cost(self) -> float:
        return self.cost_usd
```

This integrates into the agent loop with hard budgets:

```python
MAX_RUN_COST = 0.50  # Hard cap per agent session

ledger = TokenLedger(
    trace_id="trace_abc123",
    session_id="sess_xyz789",
    agent_id="support-agent-v2",
)

while agent_running:
    if ledger.running_cost() >= MAX_RUN_COST:
        logger.error(
            f"Budget exceeded: ${ledger.running_cost():.3f} "
            f"(limit ${MAX_RUN_COST:.2f}). Aborting run."
        )
        break

    response = call_llm(prompt, model="claude-sonnet-4")
    ledger.record(
        input_tok=response.usage.input_tokens,
        output_tok=response.usage.output_tokens,
    )
```

**Real-Time Anomaly Alerts**

```python
class CostAnomalyDetector:
    """Alert when token burn rate exceeds 3x the rolling average."""

    def __init__(self, window_seconds: int = 300, threshold_multiplier: float = 3.0):
        self.window = window_seconds
        self.threshold = threshold_multiplier
        self.burn_rates: deque[tuple[float, float]] = deque()

    def record_burn(self, tokens_per_second: float) -> Optional[str]:
        """Returns alert message if anomaly detected, else None."""
        now = time.time()
        self.burn_rates.append((now, tokens_per_second))

        cutoff = now - self.window
        self.burn_rates = deque(
            (ts, rate) for ts, rate in self.burn_rates if ts >= cutoff
        )

        if len(self.burn_rates) < 5:
            return None

        avg_rate = sum(r for _, r in self.burn_rates) / len(self.burn_rates)
        if tokens_per_second > avg_rate * self.threshold:
            return (
                f"ANOMALY: burn rate {tokens_per_second:.0f} tps "
                f"is {tokens_per_second/avg_rate:.1f}x above average "
                f"({avg_rate:.0f} tps)"
            )
        return None
```

### Pillar 2: Quality Observability — Canary Evaluations in Production

**Canary Query Suite**

Run 10-20 queries with known-correct answers every 5 minutes:

```python
@dataclass
class CanaryQuery:
    question: str
    expected_answer: str
    evaluation_prompt: str

CANARY_QUERIES = [
    CanaryQuery(
        question="What's the status of deployment d-4821?",
        expected_answer="completed",
        evaluation_prompt=(
            "Does the agent's response indicate that deployment d-4821 "
            "was completed successfully? Answer YES or NO."
        ),
    ),
]

def run_canary_suite(agent, queries: list[CanaryQuery]) -> dict:
    results = {}
    for q in queries:
        response = agent.run(q.question)
        judge_result = llm.ask(
            f"{q.evaluation_prompt}\n\nAgent response: {response}"
        )
        passed = "yes" in judge_result.text.lower()
        results[q.question] = passed

    pass_rate = sum(results.values()) / len(results)
    return {"pass_rate": pass_rate, "details": results}
```

**Semantic Drift Detection**

```python
class SemanticDriftDetector:
    def __init__(self, baseline_responses: list[str]):
        self.model = SentenceTransformer("all-MiniLM-L6-v2")
        self.baseline_embeddings = self.model.encode(baseline_responses)

    def check_drift(self, current_responses: list[str]) -> float:
        current_embeddings = self.model.encode(current_responses)
        similarities = np.mean(
            np.dot(current_embeddings, self.baseline_embeddings.T), axis=1
        )
        return float(np.mean(similarities))  # 1.0 = identical, 0.0 = unrelated
```

Drift below 0.7 indicates fundamental shifts requiring investigation.

### Pillar 3: Behavioral Observability — Tracing Agent Reasoning

**The Structured Agent Log**

Every agent action produces consistent JSON telemetry:

```json
{
  "timestamp": "2026-04-30T04:23:45Z",
  "trace_id": "trace_abc123",
  "span_id": "span_001",
  "event_type": "tool_call",
  "agent_name": "support-agent-v2",
  "tool_name": "query_database",
  "tool_input": {"query": "SELECT status FROM deployments WHERE id = 'd-4821'"},
  "tool_output_summary": "status=completed",
  "latency_ms": 142,
  "input_tokens": 245,
  "output_tokens": 1023,
  "cost_usd": 0.002,
  "reasoning_depth": 3,
  "confidence_score": 0.87,
  "parent_span_id": null
}
```

Key fields:
- **reasoning_depth**: Loops exceeding 8 indicate stuck agents
- **confidence_score**: Low confidence + high reasoning depth = trapped agent
- **tool_output_summary**: Truncated preview plus status indicator

**Tool-Call Attribution**

```python
class ToolCallTracker:
    def __init__(self, max_calls_per_tool: int = 50):
        self.max_calls = max_calls_per_tool
        self.call_counts: dict[str, int] = {}
        self.call_history: list[dict] = []

    def record(self, tool_name: str, reasoning_step: dict) -> None:
        self.call_counts[tool_name] = self.call_counts.get(tool_name, 0) + 1
        self.call_history.append({
            "tool": tool_name,
            "step": reasoning_step,
            "call_number": self.call_counts[tool_name],
        })

        if self.call_counts[tool_name] > self.max_calls:
            raise ToolCallLimitExceeded(
                f"Tool '{tool_name}' called {self.call_counts[tool_name]} times "
                f"(limit {self.max_calls})"
            )

    def get_distribution(self) -> dict[str, int]:
        return dict(self.call_counts)
```

### Pillar 4: Dependency Observability — Mapping External Worlds

**The Dependency Health Map**

```python
async def agent_health_check(agent) -> dict:
    start = time.time()

    llm_start = time.time()
    llm_response = await agent.llm.complete("Say 'healthy'")
    llm_latency = (time.time() - llm_start) * 1000

    tools_status = {}
    for tool in agent.tools:
        try:
            await tool.ping(timeout=3.0)
            tools_status[tool.name] = "healthy"
        except Exception as e:
            tools_status[tool.name] = f"error: {type(e).__name__}"

    canary_start = time.time()
    canary_result = await agent.run("What is 2+2?")
    canary_latency = (time.time() - canary_start) * 1000
    canary_passed = "4" in canary_result

    return {
        "status": "healthy" if canary_passed and all(
            s == "healthy" for s in tools_status.values()
        ) else "degraded",
        "llm_latency_ms": round(llm_latency),
        "model_version": agent.llm.model,
        "tools": tools_status,
        "canary_passed": canary_passed,
        "canary_latency_ms": round(canary_latency),
        "uptime_seconds": agent.uptime(),
    }
```

**Agent-to-Agent Tracing**

Distributed tracing across agent boundaries prevents error cascades:

```
trace: user-query-abc123
├── span: agent.research (2.4s, $0.12)
│   ├── span: gen_ai.chat — query planning (0.3s)
│   ├── span: tool.vector_search (0.8s)
│   ├── span: tool.web_search (0.6s)
│   └── span: gen_ai.chat — synthesize findings (0.7s)
├── span: agent.writer (1.8s, $0.08)
│   ├── span: gen_ai.chat — draft generation (1.2s)
│   └── span: gen_ai.chat — self-review (0.6s)
└── span: agent.reviewer (1.1s, $0.05)
    ├── span: gen_ai.chat — quality check (0.8s)
    └── span: gen_ai.chat — scoring (0.3s)
```

## The Dashboard That Actually Helps

A production agent dashboard should answer these five questions:

1. Real-time spending and budget status
2. Canary pass rates and confidence score trends
3. Tool call distribution and reasoning depth patterns
4. Dependency health status per tool/API
5. Error rates by user segment (not aggregate)

## Key Takeaways

1. **Start with cost tracking on day one.** Hard budget caps prevent catastrophic cost overruns.

2. **Run production canary queries.** Pre-deployment evals miss model degradation and tool API changes post-launch.

3. **Structure logs as queryable events.** JSON telemetry with consistent schemas beats text logs requiring regex parsing.

4. **Track two numbers catching 80% of failures:** reasoning depth exceeding 8 (stuck agent) and unexpected tool call counts (wrong selection loops).

5. **Map dependencies explicitly.** Health checks should answer whether failures stem from the agent or external services.

6. **Export in OpenTelemetry format.** OTLP-standard spans prevent vendor lock-in and enable observability backend flexibility.

---

## Conclusion

"Monitor [agents] like distributed systems, not like HTTP endpoints." Traditional APM assumes deterministic execution; agents are probabilistic systems across non-deterministic workflows. The observability gap reflects a mental model shift rather than a technology problem.
