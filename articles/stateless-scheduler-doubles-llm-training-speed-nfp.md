---
title: "Stateless scheduler doubles LLM training speed"
url: "https://dev.to/olaughter/stateless-scheduler-doubles-llm-training-speed-nfp"
author: "Papers Mache"
category: "llm-research-evals"
---
# Stateless scheduler doubles LLM training speed
**Author:** Papers Mache  **Published:** May 7, 2026

## Overview
RoundPipe is a scheduling approach that improves LLM fine-tuning efficiency by treating GPUs as stateless execution workers rather than binding model stages to fixed devices. Achieves 1.48-2.16x throughput improvements on eight RTX 4090 GPUs.

## Key Concepts

### The Pipeline Bubble Problem
Traditional pipeline parallelism wastes GPU capacity — heavyweight model stages create bottlenecks while other cards sit idle. Bubbles consume up to 30% of pipeline throughput.

### RoundPipe: Stateless Round-Robin Scheduling
Rather than assigning specific model layers to specific GPUs, RoundPipe treats GPUs as a pool of stateless execution workers and dynamically dispatches computation stages across devices in a round-robin manner, achieving a near-zero-bubble pipeline.

**Results on 8x RTX 4090:**
- 1.7B parameter model: 2.16x throughput improvement
- 32B parameter model: 1.48x throughput improvement
- Near-zero pipeline bubbles vs. ~30% for baseline

### Stochastic KV Routing (Secondary Innovation)
Reduces key-value cache memory through depth-wise sharing:

| Metric | Baseline | Stochastic KV Routing |
|--------|----------|----------------------|
| Memory at 8K tokens | 1170MB | 293MB (4x improvement) |
| Decode throughput | 34.0 tok/s | 41.6 tok/s (+22%) |

### Why Statelessness Works
By decoupling model stage assignment from specific hardware, RoundPipe enables continuous work rebalancing. When one GPU completes its round earlier than expected, the scheduler immediately assigns the next available computation rather than waiting for the next pipeline stage.

### Key Concepts
- Stateless pipeline parallelism
- Round-robin GPU dispatch
- KV cache optimization
- Stochastic cache routing
- Memory efficiency in LLM training and inference
