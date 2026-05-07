---
title: "Preference Fine-Tuning of LLMs Should Leverage Suboptimal, On-Policy Data"
url: "https://dev.to/aimodels-fyi/preference-fine-tuning-of-llms-should-leverage-suboptimal-on-policy-data-2946"
author: "Mike Young"
category: "llm-eval-alignment"
---
# Preference Fine-Tuning of LLMs Should Leverage Suboptimal, On-Policy Data
**Author:** Mike Young  **Published:** April 26, 2024

## Overview
Preference fine-tuning aligns LLM outputs with what humans find desirable or ethical. Current methods often depend on carefully selected expert data. This research argues that incorporating real-world model-generated (suboptimal, on-policy) data improves results by capturing authentic model behavior and deployment patterns — especially when preference objectives diverge from original training goals.

## Key Concepts

### The Core Argument
Standard preference fine-tuning relies on expert-curated datasets. The researchers propose a unifying framework showing that approaches leveraging suboptimal, on-policy data (outputs generated during actual model deployment) can outperform expert-curated-only approaches.

### Framework Components
1. **Preference learning objectives** — How preferences are encoded and optimized
2. **Data collection processes** — How training examples are gathered (expert vs. on-policy)
3. **Fine-tuning procedures** — The specific optimization approaches applied

### Key Finding
Empirical testing on language tasks showed that when preference objectives diverge from original training goals, real-world deployment data provides training signal that expert curations miss. On-policy data captures the distribution of actual model outputs — the exact regime where alignment matters.

### Critical Analysis
The paper does not adequately address:
- Risks of bias amplification from on-policy data
- Risk of undesirable behavior propagation (models learning from their own mistakes)
- Real-world deployment complexities beyond the test tasks

### Implications
This work presents a valuable framework for improving LLM alignment with human values, which grows increasingly important as these systems see wider adoption. The insight that suboptimal data is valuable challenges the assumption that only expert-quality demonstrations are useful for alignment.
