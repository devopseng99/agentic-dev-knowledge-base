---
title: "AI Paper Review: ORPO - Monolithic Preference Optimization without Reference Model"
url: "https://dev.to/bullmouse/ai-paper-review-24l4"
author: "sangjun_park"
category: "llm-eval-alignment"
---
# AI Paper Review: ORPO - Monolithic Preference Optimization without Reference Model
**Author:** sangjun_park  **Published:** January 1, 2025

## Overview
ORPO (Odds Ratio Preference Optimization) is a novel single-stage preference alignment method that eliminates the need for reference models or multi-step training pipelines. It combines supervised fine-tuning with odds-ratio-based optimization in a unified loss function.

## Key Concepts

### The Problem with Standard SFT
Standard Supervised Fine-Tuning increases log probability for both preferred and rejected responses equally, failing to distinguish quality. Cross-entropy loss lacks direct penalties for undesired outputs, necessitating additional preference-alignment mechanisms.

### ORPO's Core Innovation
ORPO directly penalizes undesired generation patterns while maintaining domain adaptation benefits through a unified loss function:

**Main loss:** `L = L_SFT + λL_OR`

Where the odds-ratio component uses log-sigmoid wrapping to ensure smooth, differentiable penalties that suppress non-preferred responses without harsh suppression that degrades model quality.

### Why Odds Ratio Beats Probability Ratio
Odds ratio provides moderate, stable preference prioritization compared to probability ratio's excessive suppression, which causes problematic logit flattening and convergence issues during combined SFT-preference training.

### Performance Results
- **AlpacaEval 2.0:** Up to 12.20% improvement over existing methods
- **IFEval:** 66.19% performance
- **MT-Bench:** 7.32 score on Mistral models

### Experimental Models Tested
- OPT (125M-1.3B parameters)
- Phi-2 (2.7B)
- Llama-2 (7B)
- Mistral (7B)

### Datasets
- Anthropic's HH-RLHF
- Binarized UltraFeedback

### Comparison: ORPO vs DPO vs PPO

| Feature | ORPO | DPO | PPO |
|---------|------|-----|-----|
| Reference model | Not needed | Needed | Needed (as KL baseline) |
| Training stages | 1 (unified) | 2 (SFT + DPO) | 3 (SFT + RM + RL) |
| Stability | High | High | Moderate |
| Complexity | Low | Low | High |

ORPO is integrated into TRL, Axolotl, and LLaMA-Factory libraries, making it widely accessible.
