---
title: "Prompt-Based Alignment Has a Ceiling — 3-Model Prisoner's Dilemma Evidence"
url: "https://dev.to/shimo4228/prompt-based-alignment-has-a-ceiling-3-model-prisoners-dilemma-evidence-1pie"
author: "Shimo"
category: "llm-research-evals"
---
# Prompt-Based Alignment Has a Ceiling — 3-Model Prisoner's Dilemma Evidence
**Author:** Shimo  **Published:** March 9, 2026

## Overview
An empirical study of AI alignment through an iterated Prisoner's Dilemma framework, testing whether injecting ethical reasoning prompts maintains effectiveness across different model sizes. Core finding: prompt-based alignment shows diminishing returns as model intelligence increases.

## Key Concepts

### The Four Axioms Framework
The experiment uses a contemplative ethical framework (Mindfulness, Emptiness, Non-duality, Infinite Compassion) injected via system prompt to encourage cooperative behavior in a game-theoretic setting.

### Experimental Results

| Model | Cohen's d | Cooperation Baseline | Cooperation w/ Prompt |
|-------|-----------|---------------------|----------------------|
| Qwen 2.5 (7B) | 1.11 (large effect) | 52.5% | 99.2% |
| Qwen 3.5 (9B) | 0.18 (negligible) | 61.7% | 70.0% |
| GPT-4o-mini | 0.32 (small effect) | 75.0% | 87.5% |

### The Blind Compassion Problem
Against AlwaysDefect (an opponent that exploits cooperation), Qwen 2.5 with the contemplative prompt achieved a 1 vs 96 score — blind compassion that self-sacrificed completely, demonstrating that alignment without strategic awareness is dangerous.

### Core Argument
True ethical behavior emerges when the rational optimal play is to defect. Smarter models resist ethical prompt injections because they've learned game-theoretic judgment through RLHF training that cannot be easily overridden by system prompts alone.

### Configuration for Disabling Thinking Mode

```python
payload = {
    "model": "qwen3.5:9b",
    "prompt": prompt,
    "stream": False,
    "think": False,  # Prevents 300-second timeouts
    "options": {"temperature": 0.3, "num_predict": 20},
}
```

### Implications for Alignment Strategy
Alignment requires defense in depth — combining:
- Prompt-level intervention
- Weight-level tuning (Constitutional AI)
- Structural constraints
- Human oversight

Relying solely on prompts creates a ceiling effect that larger models overcome through game-theoretic reasoning.

### Acknowledged Limitations
- Single trial per model (insufficient for statistical significance)
- Fixed temperature parameter
- Undisclosed parameter counts for GPT-4o-mini
- Thinking mode disabled on Qwen 3.5 (untested impact)
