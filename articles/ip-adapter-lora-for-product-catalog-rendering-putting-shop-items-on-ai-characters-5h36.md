---
title: "IP-Adapter + LoRA for product catalog rendering — putting shop items on AI characters"
url: "https://dev.to/sm1ck/ip-adapter-lora-for-product-catalog-rendering-putting-shop-items-on-ai-characters-5h36"
author: "sm1ck"
category: "ai-image-video-generation"
---
# IP-Adapter + LoRA for product catalog rendering — putting shop items on AI characters
**Author:** sm1ck  **Published:** 2026-04-25

## Overview
Combines two AI image generation techniques to render product items on AI characters while maintaining facial consistency. LoRA stabilizes character appearance; IP-Adapter pulls visual features from reference product images.

## Key Concepts

### The Challenge
Balancing character face stability and product fidelity when combining LoRA and IP-Adapter in ComfyUI.

### Core Technical Solution
Two critical parameters control the balance:
- **Weight** (0-1 range): Controls IP-Adapter's influence; recommended "lower half" (0.3-0.5) to preserve character identity
- **end_at** (0-1 range): Determines when IP-Adapter stops influencing generation; earlier handoff (0.7-0.8) allows LoRA to "reassert" facial features in final denoising steps

### Recommended Node Order
```
Checkpoint → LoRA → FreeU → IP-Adapter → KSampler
```
LoRA applied before IP-Adapter so character features can reassert during late generation steps.

### Starting Parameters
- weight=0.4, end_at=0.8
- Adjust in 0.05 increments
- If face drifts: lower weight or lower end_at
- If product not visible enough: raise weight

### Production Lessons
Common issues encountered:
- Face drifting when IP-Adapter weight runs too high
- Expired presigned URLs from S3 storage
- IP-Adapter model version mismatches with base checkpoints
- Non-visual catalog items crashing the pipeline

### Use Case
E-commerce product catalogs: photograph product once, generate it worn/used by diverse AI characters without reshooting.

## GitHub Repository
[sm1ck/honeychat/tutorial/04-ipadapter](https://github.com/sm1ck/honeychat/tree/main/tutorial/04-ipadapter) — Runnable ComfyUI workflow with Python client code
