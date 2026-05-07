---
title: "My AI agent cost me $400 overnight, so I built pytest for agents and open-sourced it"
url: "https://dev.to/hidai25/my-ai-agent-cost-me-400-overnight-so-i-built-pytest-for-agents-and-open-sourced-it-492c"
author: "Hidai Bar-Mor"
category: "ai-agent-unit-testing"
---

# My AI agent cost me $400 overnight, so I built pytest for agents and open-sourced it

**Author:** Hidai Bar-Mor
**Published:** December 8, 2025

## Overview
After an agent repeatedly called the same tool 47 times in a loop during production, spiking the OpenAI bill from $80 to $400 in a single day, the author built EvalView for testing agent behavior.

## Key Concepts

### YAML Test Example

```yaml
name: order lookup
input: 
  query: "What's the status of order 12345?"
expected:
  tools:
    - get_order_status
thresholds:
  max_cost: 0.10
```

### Running It

```bash
pip install evalview
evalview quickstart
evalview run
```

### Results
- Before EvalView: 2-3 incident reports per deployment
- After EvalView: 10 consecutive error-free deployments

Compatible with LangGraph, CrewAI, OpenAI, Anthropic, and HTTP-accessible systems. Includes LLM-as-judge for output quality evaluation.

**Repository:** https://github.com/hidai25/eval-view
