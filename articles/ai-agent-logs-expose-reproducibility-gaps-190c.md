---
title: "AI agent logs expose reproducibility gaps"
url: "https://dev.to/olaughter/ai-agent-logs-expose-reproducibility-gaps-190c"
author: "Papers Mache"
category: "llm-research-evals"
---
# AI agent logs expose reproducibility gaps
**Author:** Papers Mache  **Published:** May 7, 2026

## Overview
Two research studies reveal significant gaps between headline AI performance scores and actual reliability. AI agent performance varies substantially across repeated executions of identical tasks, exposing fundamental reproducibility problems in current benchmarking practice.

## Key Concepts

### The Reproducibility Problem
AI agent reliability varies significantly across repeated executions. Single-run benchmarks mask real-world instability. Web navigation tasks show the widest performance swings — a task solved once may fail on the next identical run.

### Real Developer Session Analysis
Examining real developer sessions:
- Only 44.3% of agent-generated code survives into user commits
- Users reject agent suggestions in 39% of interactions
- Ambiguous task specifications drive inconsistent outcomes

### The Clarification Intervention
One key finding: clarification leads to consistent improvements across models, with more tasks transitioning from "not reliably solved" to "reliably solved." Disambiguation prompts improve reproducibility more than model capability upgrades.

### Implications for Benchmark Design
Current practice reports peak performance (single run, best prompt, optimal conditions). Better metrics:
- **Pass^k** — probability of success given k attempts
- **Wilcoxon scores** — capturing variance across runs
- **Stability ratio** — proportion of consistent successes across repeated runs

### Recommendations for Production Use
- Treat stability as a primary evaluation metric alongside accuracy
- Implement repeated-run testing in CI/CD pipelines
- Report variance-aware scores rather than peak performance
- Automate disambiguation dialogs for vague task specifications
- Monitor early warning signals to prevent costly rollbacks

### Research Implication
Reported benchmark scores for agents may systematically overstate production-level reliability by 20-40% depending on task type. Web navigation and multi-step reasoning tasks show the highest variability.
