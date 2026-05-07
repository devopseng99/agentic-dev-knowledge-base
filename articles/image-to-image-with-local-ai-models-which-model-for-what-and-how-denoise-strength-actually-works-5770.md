---
title: "image-to-image with local AI models — which model for what, and how denoise strength actually works"
url: "https://dev.to/purpledoubled/image-to-image-with-local-ai-models-which-model-for-what-and-how-denoise-strength-actually-works-5770"
author: "David"
category: "ai-image-video-generation"
---
# image-to-image with local AI models — which model for what, and how denoise strength actually works
**Author:** David  **Published:** 2026-04-10

## Overview
Explains Image-to-Image (I2I) functionality in local AI image generation, focusing on how "denoise strength" controls transformation level and which model to choose for each use case.

## Key Concepts

### Denoise Strength Scale (0.0–1.0)
- 0.1–0.3: "Subtle adjustments. Color grading, minor style shifts"
- 0.4–0.6: Moderate transformation (described as "the sweet spot")
- 0.7–0.9: Heavy reimagining with loose image guidance
- 1.0: Functions as text-to-image (ignores source entirely)

### Model Recommendations

**SDXL Models** (Juggernaut XL, RealVisXL, DreamShaper XL)
- Best for: Photorealistic work
- VRAM: 6–8 GB minimum
- Recommended denoise: 0.5-0.75 for transformations

**FLUX Models** (Schnell, Dev, 2 Klein)
- Best for: Text rendering in images, prompt adherence
- VRAM: 8–12 GB
- Recommended denoise: 0.4-0.6 (preserves more structure)

**Z-Image** (Turbo/Base)
- Best for: Unrestricted content generation
- VRAM: 10–16 GB
- Note: AGPL-3.0 licensed

### Practical Workflows
- **Style transfer:** 0.6-0.7 denoise, start from reference photo
- **Sketch-to-render:** 0.7-0.85 denoise, sketch as reference
- **Iterative refinement:** 0.3-0.5 denoise, keep adjusting
- **Background replacement:** 0.5-0.7 with inpainting mask

### Implementation
Feature available in Locally Uncensored v2.3.0+

## GitHub Repository
[PurpleDoubleD/locally-uncensored](https://github.com/PurpleDoubleD/locally-uncensored) — AGPL-3.0 licensed local AI image generation interface
