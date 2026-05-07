---
title: "I built a pytest-like tool for AI agents because 'it passed once' isn't good enough"
url: "https://dev.to/alepot55/i-built-a-pytest-like-tool-for-ai-agents-because-it-passed-once-isnt-good-enough-2j30"
author: "Alessandro Potenza"
category: "ai-agent-unit-testing"
---

# I built a pytest-like tool for AI agents because "it passed once" isn't good enough

**Author:** Alessandro Potenza
**Published:** February 5, 2026

## Overview
Agentrial is a statistical testing framework that executes multiple trials and generates reliability metrics with confidence intervals, rather than single-pass testing.

## Key Concepts

### Configuration

```yaml
suite: my-agent
agent: my_module.agent
trials: 10
threshold: 0.85

cases:
  - name: basic-math
    input:
      query: "What is 15 * 37?"
    expected:
      output_contains: ["555"]
      tool_calls:
        - tool: calculate
```

### Running

```bash
pip install agentrial
agentrial run
```

### Sample Output

```
┌──────────────────────┬────────┬──────────────┬──────────┐
│ Test Case            │ Pass   │ 95% CI       │ Avg Cost │
├──────────────────────┼────────┼──────────────┼──────────┤
│ easy-multiply        │ 100.0% │ 72.2%-100.0% │ $0.0005  │
│ medium-population    │ 90.0%  │ 59.6%-98.2%  │ $0.0006  │
│ hard-multi-step      │ 70.0%  │ 39.7%-89.2%  │ $0.0011  │
└──────────────────────┴────────┴──────────────┴──────────┘
```

### CI/CD Integration

```yaml
- uses: alepot55/agentrial@v0.1.4
  with:
    trials: 10
    threshold: 0.80
```

PRs blocked if pass rates drop below 80%. Statistical foundation includes Wilson interval calculations and Fisher exact testing.

**Repository:** github.com/alepot55/agentrial (MIT Licensed)
