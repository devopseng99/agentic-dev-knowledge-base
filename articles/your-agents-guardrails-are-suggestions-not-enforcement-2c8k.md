---
title: "Your agent's guardrails are suggestions, not enforcement"
url: "https://dev.to/brianrhall/your-agents-guardrails-are-suggestions-not-enforcement-2c8k"
author: "Brian Hall"
category: "agent-guardrails"
---

# Your agent's guardrails are suggestions, not enforcement

**Author:** Brian Hall
**Published:** April 1, 2026

## Overview
Argues that prompt-based guardrails are fundamentally probabilistic suggestions, not true enforcement. The critical gap exists between agent decision-making and tool execution. References the OWASP Agentic Top 10 documenting ten agent-specific attack categories.

## Key Concepts

### Why Prompt Guardrails Fail in Production
1. **Prompt Injection:** Attackers embed instructions in content agents read. Research shows attack success rates exceeding 90%.
2. **Multi-Step Reasoning:** Clean input boundaries don't prevent dangerous tool calls discovered later in reasoning chains.
3. **Model Updates:** Guardrails tuned for one model version may fail when probability distributions shift.

### The Enforcement Gap
The critical gap exists between agent decision-making and tool execution. Prompt guardrails operate before this moment; enforcement layers must operate during it.

## Code Examples

### The Unprotected Tool Call
```python
# The agent decides to call a tool
tool_call = {
    "name": "stripe/refund",
    "arguments": {"amount": 800, "customer_id": "cust_123"}
}

# The tool executes without enforcement
result = stripe_refund(amount=800, customer_id="cust_123")
```

### Runtime Policy Enforcement with Faramesh
```python
faramesh run agent.py
```

### Faramesh Policy Language (FPL)
```
agent payment-bot {
  default deny
  model "gpt-4o"
  framework "langgraph"

  rules {
    deny! shell/* reason: "never shell"

    defer stripe/refund
      when amount > 500
      notify: "finance"
      reason: "high value refund"

    permit stripe/*
      when amount <= 500
  }
}
```

The `deny!` effect is a compile-time guarantee that no subsequent rules can override.

## Key Distinction
Guidance systems (prompts) differ fundamentally from enforcement systems (runtime policy checks). This distinction becomes critical as agents handle consequential operations in production.
