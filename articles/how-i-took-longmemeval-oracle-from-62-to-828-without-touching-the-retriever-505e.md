---
title: "How I took LongMemEval oracle from 62% to 82.8% without touching the retriever"
url: "https://dev.to/t49qnsx7qtkpanks/how-i-took-longmemeval-oracle-from-62-to-828-without-touching-the-retriever-505e"
author: "t49qnsx7qt-kpanks"
category: "llm-research-evals"
---
# How I took LongMemEval oracle from 62% to 82.8% without touching the retriever
**Author:** t49qnsx7qt-kpanks  **Published:** April 21, 2026

## Overview
Documented improvements to a memory layer for AI agents on the LongMemEval benchmark — from 62% to 82.8% accuracy — achieved primarily through answer quality improvements, not retrieval changes. The largest gain came from a single prompt engineering intervention.

## Key Concepts

### Starting Point
- Baseline: 62-64% accuracy
- Stack: Claude Sonnet-4 as answerer, GPT-4o as judge
- Architecture: MnemoPay memory layer with session-based retrieval

### Improvement Progression

| Optimization | Accuracy | Delta |
|--------------|----------|-------|
| Baseline | 62% | — |
| Session summarization | ~72% | +10% |
| Entity graph with spreading | 77.2% | +5.2% |
| Model swap to Azure GPT-4o | 81.4% | +4.2% |
| Question classification prompt | 82.8% | +1.4% aggregate, +20% in preference bucket |

### The Winning Intervention: Question Classification
The largest single lift came from prompt engineering that classifies questions before answering:

```
System prompt:
"First, classify the question.
(A) Factual lookup: answer strictly from context, refuse if not present.
(B) Recommendation / advice: extract signals about the user from context,
    ground your suggestion in named specifics."
```

This prevented spurious refusals where the model incorrectly claimed missing information when users asked for advice — the model was conflating "I don't have a recommendation" with "the context doesn't contain the answer."

### Approaches That Failed
- **HyDE + reranking** — Dropped performance to 74.6% (down 2.6 points)
- **Larger context window** (8k→32k) — Gained only 0.4 points
- **More retrieval candidates** (top-k 5→20) — No improvement; added noise

### Concurrent Stress Test Results
```
Agents: 100
Total ops: 1,036,685
Throughput: 2,904 ops/sec
Latency P50/P95/P99: 29 / 70 / 93 ms
Errors: 0.31%
Adversarial txs: 5,798 injected, 5,598 blocked (96.6%)
Ledger imbalance: $0.00
```

### Key Lessons for Agent Memory Evaluation
1. RAG optimization through answer quality outperforms retrieval volume increases
2. Failure analysis yields more gains than hyperparameter sweeps
3. Model selection is a high-leverage variable in LLM pipelines
4. Semantic prompt engineering often outperforms technical retrieval modifications
5. The LongMemEval preference bucket (advice/recommendation questions) is the hardest category — and the most underoptimized
