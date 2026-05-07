---
title: "Textbooks Are All You Need"
url: "https://dev.to/paperium/textbooks-are-all-you-need-3obo"
author: "paperium"
category: "llm-research-evals"
---
# Textbooks Are All You Need
**Author:** paperium  **Published:** May 5, 2026

## Overview
Summary of Microsoft Research's "Textbooks Are All You Need" paper (phi-1), which trained a small 1.3B parameter code generation model to outperform much larger models by training on high-quality, textbook-style synthetic data.

## Key Concepts

### The Core Claim
Training data quality matters more than quantity. A 1.3B parameter model trained on ~7B tokens of high-quality synthetic "textbook" code data outperforms 12B+ parameter models trained on hundreds of billions of tokens of raw internet data.

### The Data Quality Argument
Most internet-scraped code training data is:
- Repetitive boilerplate
- Poorly commented
- Bug-prone examples
- Inconsistent style

Textbook-quality data is:
- Pedagogically structured (concepts introduced before use)
- Explicitly annotated with purpose
- Progressively complex
- Demonstrating best practices

### Phi-1 Results
| Model | HumanEval Pass@1 | Size |
|-------|-----------------|------|
| phi-1 | 50.6% | 1.3B |
| CodeGen-16B | 29.3% | 16B |
| GPT-3.5 (at time) | ~47% | ~175B |

A 1.3B model outperforming a 16B model on code generation benchmarks, with performance approaching GPT-3.5 at 1/100th the size.

### Synthetic Data Generation
The high-quality data was generated using GPT-4 prompted to create textbook-style explanations and exercises. Key insight: using a large model to generate high-quality training data for a small model is significantly more efficient than scraping internet data.

### Implications for LLM Research
1. **Data curation > data scale** — For specialized domains, curated data beats raw scale
2. **Synthetic training data** — Opens new possibilities for targeted capability improvement
3. **Scaling laws revisited** — The standard scaling laws assume internet-quality data; high-quality data shifts the curve
4. **Downstream lineage** — phi-1 led to phi-1.5, phi-2, phi-3, demonstrating the enduring value of the data quality insight

### Follow-on Research
The phi family of models (1, 1.5, 2, 3) all demonstrate that data quality and careful curriculum design can compensate for smaller model size, influencing subsequent work on small language models and efficient training.
