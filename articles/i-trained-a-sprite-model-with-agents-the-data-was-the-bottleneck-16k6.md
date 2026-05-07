---
title: "I trained a sprite model with agents. The data was the bottleneck."
url: "https://dev.to/danfking/i-trained-a-sprite-model-with-agents-the-data-was-the-bottleneck-16k6"
author: "danfking"
category: "gaming-agents"
---
# I trained a sprite model with agents. The data was the bottleneck.
**Author:** Daniel King  **Published:** May 6, 2026

## Overview
Daniel King built a small autoregressive transformer model (2.9M parameters) that generates 32x32 pixel art sprites of reef sea creatures. The model was constructed end-to-end using AI agents to handle code generation and implementation. While the technical components worked well, King discovered that data quality became the limiting factor — two of six sprite categories never converged properly.

## Key Concepts
- **Agentic ML development**: Division of labor between AI agents (fast code generation, loss optimization) and humans (data curation, aesthetic judgment)
- **Data curation as premium activity**: In agent-driven workflows, the bottleneck shifts from code to data quality — the human's unique contribution
- **Loss metrics vs. output quality**: Agents optimize for measurable metrics; aesthetics and domain suitability require human evaluation
- **Domain-specific model architecture**: Constrained visual vocabularies (32x32 pixel art) warrant specialized small models over general-purpose approaches
- **Procedural shaders**: Palette-aware post-processing applied to model output for consistent pixel art aesthetics
- **Agent limitations on slow signals**: Agents excel at fast, local correctness signals (code execution, loss reduction) but struggle with slower aesthetic judgments

## Key Finding
Two of six sprite categories (reef creatures) never converged properly despite the model architecture working correctly — the training images for those categories lacked sufficient quality and consistency. Human oversight for data curation remains essential even when agents handle all code.

## GitHub Repository
https://github.com/danfking/pixel-llm
