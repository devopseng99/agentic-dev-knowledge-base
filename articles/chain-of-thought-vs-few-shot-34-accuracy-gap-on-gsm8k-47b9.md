---
title: "Chain-of-Thought vs Few-Shot: 34% Accuracy Gap on GSM8K"
url: "https://dev.to/tildalice/chain-of-thought-vs-few-shot-34-accuracy-gap-on-gsm8k-47b9"
author: "TildAlice"
category: "llm-research-evals"
---
# Chain-of-Thought vs Few-Shot: 34% Accuracy Gap on GSM8K
**Author:** TildAlice  **Published:** April 29, 2026

## Overview
Empirical comparison of chain-of-thought (CoT) prompting versus standard few-shot learning on GSM8K (8,500 grade school math word problems), showing a 34 percentage point accuracy improvement at the cost of 3.2x token usage.

## Key Concepts

### The Experiment
Testing GPT-3.5-turbo on GSM8K with two prompting strategies:
- **Standard few-shot:** Provide example problems and answers, ask for final answer
- **Chain-of-thought:** Provide example problems with step-by-step reasoning, ask for step-by-step solution

### Core Result

| Method | GSM8K Accuracy | Token Multiplier |
|--------|---------------|-----------------|
| Standard few-shot | ~23% | 1.0x |
| Chain-of-thought | ~57% | 3.2x |

**34 percentage point improvement** from CoT — a 2.5x relative accuracy gain.

### Why CoT Works on Multi-Step Problems
GSM8K problems require holding multiple arithmetic steps in sequence. Direct generation forces the model to output the answer without intermediate computation — it essentially attempts to compress a multi-step calculation into a single prediction. CoT forces explicit intermediate steps, reducing the probability of arithmetic errors at each step.

### The Token Cost Trade-off
The 3.2x token increase directly translates to:
- Higher API costs (output tokens are typically 3-5x more expensive than input)
- Higher latency (more tokens = more generation time)
- Larger context consumption in multi-turn conversations

### When CoT Doesn't Help
A 2024 study found forcing step-by-step reasoning on certain simple problems *decreased accuracy by over one-third* — suggesting CoT overhead creates errors on tasks where direct generation is more reliable.

### Practical Decision Rule
Use CoT when:
- Tasks require multi-step arithmetic or logical chaining
- Errors in intermediate steps are common without explicit reasoning
- The accuracy improvement justifies the token cost

Don't use CoT when:
- Tasks are single-step (retrieval, summarization, translation)
- Latency constraints are tight
- Models with built-in reasoning are available (CoT is redundant)
