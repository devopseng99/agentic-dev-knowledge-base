---
title: "Chain-of-Thought Prompting: Make AI Think Step by Step (With Examples)"
url: "https://dev.to/novaelvaris/chain-of-thought-prompting-make-ai-think-step-by-step-with-examples-13h1"
author: "Nova Elvaris"
category: "agent-chain-of-thought"
---

# Chain-of-Thought Prompting: Make AI Think Step by Step (With Examples)

**Author:** Nova Elvaris
**Published:** February 16, 2026

## Overview
Practical guide to CoT prompting with reusable templates. Nudge the model into a deliberate, step-by-step mode so it does not jump to the first plausible output.

## Code Examples

### Pattern 1: Plan - Execute - Verify

```
You are {role}. Solve {task}.

Process:
1) Plan: write a short plan (3-6 bullets).
2) Execute: follow the plan.
3) Verify: list 2-3 quick checks (edge cases, math check, sanity check).

Output:
- Final answer:
- Verification:
```

### Debugging CoT Prompt

```
You are a senior JS dev helping me debug.

Task:
- Explain why the output is what it is.
- Provide 2 fixes (one strict, one flexible).
- Add a tiny test snippet to prove it.

Process:
1) Identify the root cause in one sentence.
2) Show the minimal code change.
3) Verify with tests.

Code:
function sum(a, b) {
  return a + b
}
console.log(sum("2", 3))

Output format:
- Root cause:
- Fix A (strict types):
- Fix B (coerce inputs):
- Tests:
```

### Architecture Analysis CoT

```
You are my pragmatic tech lead.

Context:
- Product: SaaS API
- Workload: 2k req/s peak
- Cached objects: ~5 KB each
- Cache TTL: 5 minutes

Task:
Recommend Redis or Postgres-based caching.

Process:
1) List decision criteria (latency, complexity, cost, failure modes).
2) Compare options in a table.
3) Give a recommendation + when it changes.
4) Provide 2 counterexamples where your recommendation is wrong.
```

### Universal CoT Template

```
You are a helpful expert.

Goal: {what I want}
Context: {inputs, constraints, audience}

Approach:
1) Write a short plan (max 5 bullets).
2) Solve step by step, keeping it concise.
3) Verify: list 2-3 checks or edge cases.

Output:
- Answer:
- Key steps:
- Verification:
```
