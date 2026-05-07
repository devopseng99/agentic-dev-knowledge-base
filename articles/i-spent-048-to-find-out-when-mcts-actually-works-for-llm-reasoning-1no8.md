---
title: "I Spent $0.48 to Find Out When MCTS Actually Works for LLM Reasoning"
url: "https://dev.to/queelius/i-spent-048-to-find-out-when-mcts-actually-works-for-llm-reasoning-1no8"
author: "Alex Towell"
category: "llm-research-evals"
---
# I Spent $0.48 to Find Out When MCTS Actually Works for LLM Reasoning
**Author:** Alex Towell  **Published:** April 10, 2026

## Overview
Controlled experiments comparing four reasoning methods (Pass@1, Best-of-N, Self-consistency, MCTS) on constraint satisfaction problems using Claude Haiku. MCTS only outperforms alternatives under specific conditions — and those conditions are more constrained than commonly assumed.

## Key Concepts

### Methods Compared
- **Pass@1** — Single attempt, direct answer
- **Best-of-N (N=8)** — 8 independent solutions, pick the one passing verification
- **Self-consistency** — Multiple reasoning paths, majority vote on final answer
- **MCTS** — 5 initial solutions + 3 guided explorations using search tree

### Core Finding
MCTS outperformed competing approaches only for the hardest problems. On problems with 6-8 variables and 12-15 constraints:
- MCTS: 100% solve rate
- Other methods: ~90% solve rate ceiling

One problem (v6_3) was unsolvable by any independent sampling approach — MCTS succeeded by learning from partial failures through the search tree.

### Three Conditions Where MCTS Adds Value
1. **Deterministic verifier** — Not learned reward models or LLM judges; only works with true right/wrong verification
2. **Partial credit signals** — The verifier must provide gradient information (how close to correct), not just pass/fail
3. **Sufficient problem difficulty** — Where independent sampling hits a ceiling

### The Self-Consistency Conflict
A key insight: there is a structural incompatibility between self-consistency (diversity through independent sampling) and UCB1 exploration (systematic search). MCTS degrades to self-consistency when the verifier only provides binary feedback.

```python
# MCTS adds value when:
# (1) You have a true verifier: verify(solution) -> score in [0, 1]
# (2) Problems are hard enough that best_of_n fails
# (3) Partial credit guides the search tree

# MCTS does NOT add value when:
# - Verifier is another LLM (unreliable gradient)
# - Problems are easy enough for sampling
# - Only binary pass/fail is available
```

### Cost Analysis
Full experiment: $0.48 on API costs. Best-of-N (N=8) provides most MCTS benefits at lower complexity for problems below the difficulty ceiling. MCTS becomes worthwhile only above the threshold where sampling stops working.

### Open Source
Implementation: github.com/queelius/mcts-reasoning
