---
title: "ORPO, DPO, and PPO: Optimizing Models for Human Preferences"
url: "https://dev.to/fotiecodes/orpo-dpo-and-ppo-optimizing-models-for-human-preferences-3ni6"
author: "fotiecodes"
category: "llm-eval-alignment"
---
# ORPO, DPO, and PPO: Optimizing Models for Human Preferences
**Author:** fotiecodes  **Published:** November 8, 2024

## Overview
Three prominent techniques for refining LLMs to align with human preferences — ORPO, DPO, and PPO — each offering distinct advantages for creating models that generate responses users actually prefer.

## Key Concepts

### DPO (Direct Preference Optimization)
DPO simplifies preference alignment by eliminating the need for a separate reward model. Instead, it employs a classification loss function to optimize responses based on preference datasets.

- Uses datasets with prompts paired with preferred and non-preferred responses
- Trains the model to favor positively-rated outputs via loss function
- Applied to: sentiment control, summarization, dialogue generation
- More stable and computationally efficient than reinforcement techniques

### ORPO (Odds Ratio Preference Optimization)
Introduced in 2024 by Hong and Lee, ORPO merges supervised fine-tuning with preference alignment into a single unified process.

- Combines SFT with preference alignment in a single step
- Employs an odds ratio loss term penalizing unwanted responses while reinforcing preferred ones simultaneously
- Integrated into TRL, Axolotl, and LLaMA-Factory libraries
- Streamlines training, saving time and resources vs. multi-step pipelines

### PPO (Proximal Policy Optimization)
PPO operates within reinforcement learning frameworks, maintaining stability through controlled policy updates.

- Maintains updates within defined limits to prevent drastic behavioral changes
- Improves iteratively through multiple update cycles
- Widely used in domains requiring steady learning progression
- Applications extend beyond language models to robotics and game AI

### Method Comparison Guide

| Method | Best For |
|--------|----------|
| DPO | When simplicity and computational efficiency are prioritized |
| ORPO | When combining instruction tuning with preference alignment is needed |
| PPO | When controlled, iterative updates are essential |

### Conclusion
- DPO offers directness and simplicity
- ORPO streamlines through unified training
- PPO excels with controlled, steady learning

Together, they enable development of models that are not only intelligent but also aligned with human preferences.
