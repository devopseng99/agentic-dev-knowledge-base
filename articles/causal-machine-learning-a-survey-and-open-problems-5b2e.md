---
title: "Causal Machine Learning: A Survey and Open Problems"
url: "https://dev.to/paperium/causal-machine-learning-a-survey-and-open-problems-5b2e"
author: "paperium"
category: "llm-research-evals"
---
# Causal Machine Learning: A Survey and Open Problems
**Author:** paperium  **Published:** May 5, 2026

## Overview
Survey of causal machine learning — the intersection of causal inference and ML, covering methods for learning causal structure, estimating causal effects, and enabling out-of-distribution generalization through causal representations.

## Key Concepts

### Why Causality Matters for ML
Standard ML models learn correlations from data. Causal models learn the underlying data-generating process, enabling:
- Robust out-of-distribution generalization (the correlation may change; the mechanism doesn't)
- Counterfactual reasoning ("what would have happened if...")
- Interventional prediction ("what will happen if we do X")

### Three Pillars of Causal ML

**1. Causal Discovery**
Learning the causal structure (DAG) from observational data. Key algorithms: PC algorithm, FCI, NOTEARS, DAGS. Challenge: identifiability from observational data alone requires strong assumptions.

**2. Causal Effect Estimation**
Estimating the effect of interventions from observational data using tools like:
- Instrumental variables
- Regression discontinuity
- Difference-in-differences
- Propensity score methods
- Double machine learning (DML)

**3. Causal Representation Learning**
Learning latent representations that encode causal variables rather than correlated features. Relevant to LLMs: do language models learn causal relationships or just correlations?

### LLM Connection
A key open question: do LLMs learn causal representations? Evidence is mixed:
- LLMs can answer some causal questions correctly
- LLMs fail on out-of-distribution causal scenarios
- Chain-of-thought reasoning improves causal task performance
- Current training objectives don't explicitly optimize for causal structure

### Open Problems Identified
1. Scalable causal discovery for high-dimensional data
2. Causal representation learning without interventional data
3. Evaluating LLM causal reasoning beyond benchmark performance
4. Connecting causal ML to RLHF alignment (reward models may capture confounders)
5. Handling hidden confounders in real-world deployment
