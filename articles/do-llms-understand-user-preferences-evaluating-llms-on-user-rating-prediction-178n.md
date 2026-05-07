---
title: "Do LLMs Understand User Preferences? Evaluating LLMs On User Rating Prediction"
url: "https://dev.to/paperium/do-llms-understand-user-preferences-evaluating-llms-on-user-rating-prediction-178n"
author: "paperium"
category: "llm-research-evals"
---
# Do LLMs Understand User Preferences? Evaluating LLMs On User Rating Prediction
**Author:** paperium  **Published:** May 6, 2026

## Overview
Research evaluating whether LLMs can predict user ratings for items (movies, books, products) based on user history and item descriptions — testing whether LLMs genuinely understand user preferences or merely generate plausible-sounding predictions.

## Key Concepts

### The Research Question
Can LLMs predict what a specific user will rate an item, given their historical preferences? This tests whether LLMs model individual preference distributions, not just average population preferences.

### Evaluation Methodology
- **Task:** Predict user ratings (e.g., 1-5 stars) given user history and item descriptions
- **Benchmark datasets:** Standard recommender system datasets (MovieLens, Amazon reviews)
- **Comparison baselines:** Collaborative filtering, content-based filtering, hybrid recommenders
- **Metrics:** RMSE, MAE, ranking accuracy (NDCG, MRR)

### Key Findings
1. **Zero-shot LLMs underperform** — Without user-specific calibration, LLMs predict toward average ratings rather than individual preferences
2. **Few-shot with history improves significantly** — Providing 10-20 past ratings in context substantially closes the gap with specialized recommenders
3. **LLMs excel at cold-start** — For users with limited history, LLM semantic reasoning about item attributes outperforms collaborative filtering
4. **Preference drift is poorly handled** — LLMs don't naturally account for how preferences evolve over time

### Architectural Implications
The results suggest LLMs represent a useful component for recommender systems rather than a direct replacement:
- Use LLMs for cold-start and semantic understanding
- Use collaborative filtering for users with rich history
- Hybrid approaches combining both show the best performance

### Broader Implication for LLM Evaluation
The study illustrates a general principle: LLMs that perform well on population-level tasks (average preferences) may perform poorly on individual-level tasks (personalized preferences). Benchmark design should distinguish these cases.
