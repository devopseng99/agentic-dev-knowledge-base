---
title: "The Autoresearch Ecosystem - How One Repo Spawned 9 Different Types of AI Projects"
url: "https://dev.to/eristoddle/the-autoresearch-ecosystem-how-one-repo-spawned-9-different-types-of-ai-projects-335c"
author: "eristoddle"
category: "gaming-agents"
---
# The Autoresearch Ecosystem - How One Repo Spawned 9 Different Types of AI Projects
**Author:** Stephan Miller  **Published:** May 5, 2026

## Overview
Comprehensive analysis examining Karpathy's autoresearch repository and documents nine distinct categories of derivative projects. The original autoresearch implements an autonomous ML research loop: modify code, train briefly, evaluate metrics, keep improvements or revert failures, repeat. The pattern generalizes far beyond ML — from game modding to creative writing to production optimization.

## Key Concepts
- **The Core Pattern**: Constraint + mechanical metric + autonomous iteration
- **Meta-skill**: `program.md` instructs the agent how to be a researcher
- **Discard Mechanism**: Automatic rollback via git prevents bad experiments from poisoning subsequent ones
- **Generalization**: The loop works for any measurable task with fast verification — game AI training, prompt optimization, code performance
- **Reward Hacking Risk**: Metrics can be gamed if not carefully designed
- **Orchestration Layer**: Autoresearch functions best as a worker within larger systems

## Nine Project Categories
1. Platform Ports (macOS MPS, Apple Silicon MLX, Windows RTX, Browser WebGPU)
2. ML Research Enhancers (Bayesian inference, multi-GPU infrastructure)
3. Prompt Optimizers (reaching 100% accuracy in 8 experiments)
4. Generalized Frameworks (substrate-agnostic implementations)
5. Production Codebase Optimization (real-world industrial applications)
6. Agent Factory (autonomous creation of specialized agents)
7. Research OS/Skills Systems (institutional methodology)
8. Creative Writing (novel generation, prose refinement)
9. Orchestration Patterns (autoresearch as worker in multi-agent systems)

```python
# Basic AutoLoop Usage
from autoloop import AutoLoop

loop = AutoLoop(
    target="src/optimize_me.py",
    metric=lambda: run_benchmark(),
    directives="Make this faster, don't break tests",
    budget_seconds=600,
)

results = loop.run(experiments=100)
```

## Real-World Results
- Shopify Liquid Engine: 7,374µs → 4,815µs parsing (-34%), 62,620 → 37,355 allocations
- Idealo Search: 3.9ms → 0.66ms preprocessing (-83%), $7 in API costs, 1 hour supervision
- Prompt Optimization: 74.72% → 100% accuracy in 8 experiments, zero human intervention
- GPU Cluster: ~910 experiments in 8 hours on 16-GPU cluster, 9x faster than sequential

## GitHub Repositories
- Original: github.com/karpathy/autoresearch
- pip package: github.com/menonpg/autoloop
- Prompt optimization: github.com/az9713/autoresearch-prompt-optimization
- Agent creation: github.com/Dominien/agent-factory
