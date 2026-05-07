---
title: "Post-training tricks cut LLM cost without losing ability"
url: "https://dev.to/olaughter/post-training-tricks-cut-llm-cost-without-losing-ability-108f"
author: "Papers Mache"
category: "llm-research-evals"
---
# Post-training tricks cut LLM cost without losing ability
**Author:** Papers Mache  **Published:** May 7, 2026

## Overview
Four recent post-training techniques for reducing LLM computational and memory costs: TESSY (style-consistent distillation), TIP (token importance selection), KV Packet (immutable cache packets), and IceCache (CPU-offloaded semantic caching).

## Key Concepts

### TESSY: Style-Consistent Knowledge Distillation
Interleaves teacher and student models during data generation. Rather than replacing student data entirely with teacher outputs, TESSY preserves the student's distribution through "style tokens."

**Results on Qwen3-8B:**
- LiveCodeBench-Pro: +11.25% improvement
- OJBench: +6.68% improvement
- Standard teacher-generated data showed performance *drops* of 3.25% and 10.02% on the same benchmarks

### TIP: Token Importance in On-Policy Distillation
Categorizes tokens by student entropy and teacher-student divergence. Retaining only high-entropy tokens cuts peak memory by up to 47% while matching full-token baselines.

**Key result:** Training on fewer than 10% of tokens nearly matches complete baselines.

### KV Packet: Immutable Cache Documents
Treats cached documents as immutable packets wrapped in lightweight adapters. Reports FLOPs reduced by approximately 4 orders of magnitude compared to alternatives like CacheBlend and EPIC, while maintaining competitive performance.

### IceCache: CPU-Offloaded Semantic Caching
Offloads KV cache to CPU and clusters semantically similar tokens. With a 256-token budget, maintains 99% of original accuracy while using only a quarter of the token budget.

### Trade-offs Summary

| Technique | Memory Reduction | Accuracy Impact | Use Case |
|-----------|-----------------|-----------------|----------|
| TESSY | Moderate | Positive (+11%) | Fine-tuning |
| TIP | Up to 47% | Neutral | Distillation |
| KV Packet | 4 orders of magnitude FLOPs | Neutral | Long context |
| IceCache | 75% token budget | -1% | Long context inference |

### Research Significance
These four papers collectively demonstrate that post-training efficiency is achievable through smarter data selection and caching strategies, not just through architectural changes or quantization.
