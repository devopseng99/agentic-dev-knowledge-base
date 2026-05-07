---
title: "The Yoga of Image Generation – Part 1"
url: "https://dev.to/raphiki/the-yoga-of-image-generation-part-1-1gan"
author: "Raphael Semeteys"
category: "ai-image-video-generation"
---
# The Yoga of Image Generation – Part 1
**Author:** Raphael Semeteys  **Published:** 2025-02-11

## Overview
Introduction to image generation using Stable Diffusion and ComfyUI, focused on a practical goal: generating yoga poses locally without internet-sourced images. Part 1 of a 5-part series.

## Key Concepts

### Stable Diffusion Background
Stable Diffusion began in Germany as a collaboration between organizations in 2021, introducing latent diffusion model technology. Stability AI now maintains these models under OpenRAIL licenses (with enterprise restrictions from v3.5 onward).

Community ecosystem includes: fine-tuned models, ControlNets, LoRA adapters, Automatic1111 Web UI, Hugging Face, and civitai.com.

### ComfyUI
GPL 3 licensed GUI for Stable Diffusion running locally, using modular interconnected nodes.

Recommended plugins:
- ComfyUI-Manager
- ComfyUI-Crystools
- ComfyUI-Workspace-Manager

### Simple Text-to-Image Workflow

**Model Node:** SDXL 1.0 checkpoint

**Prompt structure:**
```
girl, doing yoga, lotus pose, green eyes, cinematic lighting, long hair, ((blue yoga outfit)), best quality, park
```

CLIP model (OpenAI, 2021, MIT license) trained on 400M image-text pairs supports keyword weighting:
- `((yoga))` — highest weight
- `(yoga:1.2)` — explicit weight multiplier

**KSampler Node Parameters:**
- Seed: controls initial randomness
- Steps: default 20 (more = better quality, slower)
- CFG: guidance strength (7-8 typical)
- Denoising: 100% (1.00) for complete generation from scratch

### Latent Space
The diffusion process operates in mathematical vector space rather than pixel space. A "VAE Decode" (Variational Autoencoder) node converts results back to visible images.

### Embeddings (Textual Inversions)
Embeddings are "vector representations of text providing preset instructions for style, theme, texture, etc." They serve as shortcuts avoiding exhaustive prompts. Downloadable from civitai.com — but only work with content already present in the underlying model.

### Limitations Discovered
Standard text-to-image produces anatomically incorrect yoga poses. This sets up Part 2: advanced techniques using ControlNet for pose-accurate generation.

### Series Context
- Part 1: Basic text-to-image with ComfyUI (this article)
- Part 2: ControlNet for accurate poses
- Part 3: JSON style guides
- Part 4: QR code enhancement
- Part 5: Advanced techniques
