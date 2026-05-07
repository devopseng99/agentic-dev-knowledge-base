---
title: "AI Agent Failures Are Distributed Systems Failures. Here's the Complete Mapping."
url: "https://dev.to/arif/ai-agent-failures-are-distributed-systems-failures-heres-the-complete-mapping-216k"
author: "arif"
category: "distributed-agent-decision"
---
# AI Agent Failures Are Distributed Systems Failures. Here's the Complete Mapping.
**Author:** arif  **Published:** February 20, 2026

## Overview
"An AI agent is not a program that figures things out. It is a graph of tasks, each processed by a nondeterministic worker." Every AI agent failure maps to a distributed systems problem engineers solved 15 years ago.

## Key Concepts

### Mapping Table
| Distributed Systems | AI Agent Equivalent |
|---|---|
| Message queue | Task buffer between steps |
| Dead letter queue | Failed tasks awaiting review |
| Idempotency key | Deterministic task ID |
| Circuit breaker | Model fallback strategy |
| Saga pattern | Multi-step workflow rollback |
| Two-phase commit | Human approval gates |
| Distributed tracing | Per-step observability |
| Backpressure | Concurrency limits |
| Bulkhead pattern | Cost/rate isolation |

### Problem 1: Silent Failures — Validate at Every Step
```go
func (w *Worker) processStep(ctx context.Context, input string, schema string) (*StepResult, error) {
    raw, err := w.llm.Complete(ctx, input)
    if err != nil { return nil, err }
    if err := w.validator.Validate(raw, schema); err != nil {
        corrected, err2 := w.llm.Complete(ctx, fmt.Sprintf(
            "Your previous response failed validation: %s\n\nOriginal task: %s\n\nTry again.",
            err.Error(), input,
        ))
        if err2 != nil { return nil, err }
        if err3 := w.validator.Validate(corrected, schema); err3 != nil {
            return nil, fmt.Errorf("validation failed after correction: %w", err3)
        }
        raw = corrected
    }
    return &StepResult{Raw: raw, Valid: true, Schema: schema}, nil
}
```

### Problem 2: Idempotency — Cache First Output
```go
func (w *Worker) run(ctx context.Context, task Task) (string, error) {
    if result, ok, err := w.store.Get(ctx, task.ID); err != nil {
        return "", fmt.Errorf("store get: %w", err)
    } else if ok { return result, nil }
    result, err := w.processStep(ctx, task.Input, task.Schema)
    if err != nil { return "", err }
    if err := w.store.Set(ctx, task.ID, result.Raw); err != nil {
        return "", fmt.Errorf("store set: %w", err)
    }
    return result.Raw, nil
}
```

### Problem 3: Multi-step Rollbacks — Saga Pattern
```go
type Saga struct {
    steps    []Step
    executed []int
}
func (s *Saga) Run(ctx context.Context, state *State) error {
    for i, step := range s.steps {
        if err := step.Execute(ctx, state); err != nil {
            for j := len(s.executed) - 1; j >= 0; j-- {
                s.steps[s.executed[j]].Compensate(ctx, state)
            }
            return fmt.Errorf("step %d (%s) failed: %w", i, step.Name, err)
        }
        s.executed = append(s.executed, i)
    }
    return nil
}
```

### Problem 4: Human-in-the-Loop — Scope by Blast Radius
```go
type BlastRadius int
const (
    BlastRadiusRead        BlastRadius = iota
    BlastRadiusReversible
    BlastRadiusIrreversible
)
```

### Problem 5: Circuit Breakers
```go
func (cb *CircuitBreaker) Allow() bool {
    cb.mu.Lock()
    defer cb.mu.Unlock()
    switch cb.state {
    case StateOpen:
        if time.Since(cb.lastFailure) > cb.timeout {
            cb.state = StateHalfOpen
            return true
        }
        return false
    default:
        return true
    }
}
```

### Problem 6: Cost Attribution
```go
func tokenCost(model string, prompt, completion int) float64 {
    rates := map[string][2]float64{
        "gpt-4o":              {0.0000025, 0.000010},
        "claude-3-5-sonnet":   {0.000003, 0.000015},
        "claude-3-5-haiku":    {0.0000008, 0.000004},
    }
    r, ok := rates[model]
    if !ok { return 0 }
    return float64(prompt)*r[0] + float64(completion)*r[1]
}
```

### Key Insight
"The prompt engineering is the interesting part. The infrastructure is what makes it shippable."
