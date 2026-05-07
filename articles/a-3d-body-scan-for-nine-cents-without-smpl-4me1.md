---
title: "A 3D Body Scan for Nine Cents — Without SMPL"
url: "https://dev.to/arkadiuss/a-3d-body-scan-for-nine-cents-without-smpl-4me1"
author: "Arkadiusz"
category: "3d-ai-generation"
---
# A 3D Body Scan for Nine Cents — Without SMPL
**Author:** Arkadiusz  **Published:** 2026-03-27

## Overview
Commercial 3D body reconstruction without SMPL is feasible at $0.09 per body. This article presents a pipeline using Naver's Anny and Meta's MHR—both with permissive Apache 2.0 licenses released in November 2025.

## Key Concepts

### The SMPL Licensing Trap
SMPL's license restricts commercial use unless companies obtain a sub-license from Meshcapade. The license also prohibits training neural networks for commercial use. Affected projects include HMR 2.0, TokenHMR, SMPLer-X, ROMP, HybrIK, and WHAM.

### The Landscape (March 2026)

**Anny (Naver Labs Europe):**
- 11 semantic shape parameters (gender, age, weight, height, muscle, cup size)
- 256 local blendshapes for region-specific changes
- 14K vertices, 163 bones, fully differentiable
- Apache 2.0 license

**MHR (Meta):**
- 45 abstract shape coefficients
- 18K vertices, 127 joints, 7 LOD levels
- Apache 2.0 license
- Integrates with Meta's SAM 3D Body for commercial HMR

### Pipeline Architecture
Two input paths converge:

1. **Photo Path:** SAM 3D Body → MHR params → custom MHR→Anny conversion
2. **Questionnaire Path:** 8 inputs predict Anny params directly (<1s, no GPU)

Both converge at measurement tuning, optimizing body parameters to match known measurements.

### Cost Analysis

| Service | Cost per scan |
|---------|--------------|
| PixelAPI (photo path) | ~$0.09 (unoptimized) |
| Questionnaire path | <$0.01 (no GPU) |
| 3DLOOK | $2–5 |
| Meshcapade | ~€1–5 |
| FASHN (diffusion VTO) | $0.049–0.075 |

### Evaluation Results
- **MHR→Anny conversion:** ~10mm mean nearest-neighbor surface error
- **Photo pipeline (early testing):** 5–8cm MAE on bust-waist-hips measurements
- Professional scanners achieve ±0.5–1.6cm; the goal is to get close enough that measurement tuning can close the gap

## GitHub Links
- Anny (Naver): https://github.com/naver/anny
- MHR (Meta): https://github.com/facebookresearch/MHR
- SAM 3D Body (Meta): https://github.com/facebookresearch/sam-3d-body
- MultiHMR (Naver): https://github.com/naver/multi-hmr
