---
title: "Testing AI Agents Like Code: the `oa test` Harness"
url: "https://dev.to/sg-prime/testing-ai-agents-like-code-the-oa-test-harness-oh"
author: "Scotty G"
category: "agent-research-testing"
---
# Testing AI Agents Like Code: the `oa test` Harness
**Author:** Scotty G  **Published:** April 23, 2026

## Overview
Introduces `oa test`, a testing harness for AI agents included in Open Agent Spec 1.4. Enables developers to test agents similarly to traditional code, using YAML-based test files that run evaluation cases against real models and produce CI-friendly JSON output.

## Key Concepts
1. **Test File Structure** — Tests are defined in YAML alongside agent specifications with named cases, task targets, inputs, and optional assertions
2. **Assertion Vocabulary** — Supports: `contains`, `equals`, `type`, `min_length`, and `max_length`; can be combined and use dotted path notation with array indexing
3. **Testing Philosophy** — Tests should validate "shape and invariants" rather than exact outputs; verify schema conformance, structural constraints, and refusal handling
4. **CI Integration** — Human-readable terminal output and JSON mode for pipeline integration with non-zero exit codes on failure

## Code Examples

```yaml
# YAML Test Configuration
spec: ./summariser.yaml
cases:
  - name: summarises short documents
    task: summarise
    input:
      document: "The sky is blue..."
    expect:
      output.summary: { type: string, min_length: 10 }
```

```bash
pipx install open-agent-spec
oa test .agents/summariser.test.yaml --quiet
```

```yaml
# GitHub Actions CI Workflow
- run: |
    for test in .agents/*.test.yaml; do
      oa test "$test" --quiet
    done
```
