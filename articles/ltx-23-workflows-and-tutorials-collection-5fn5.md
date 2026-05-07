---
title: "LTX 2.3 Workflows and Tutorials Collection"
url: "https://dev.to/pixivo-ai/ltx-23-workflows-and-tutorials-collection-5fn5"
author: "pixivo-ai"
category: "ai-image-video-generation"
---
# LTX 2.3 Workflows and Tutorials Collection
**Author:** pixivo-ai  **Published:** 2026-04-17

## Overview
Curated collection of ComfyUI workflows and tutorials for LTX Video 2.3 — Lightricks' open-source video generation model optimized for real-time and near-real-time video synthesis.

## Key Concepts

### What is LTX Video?
LTX-Video is an open-source video generation model from Lightricks, optimized for:
- Real-time/near-real-time generation speed
- Text-to-video and image-to-video
- Running on consumer GPUs (12GB+ VRAM for LTX 2.3)
- Apache 2.0 license (commercial use allowed)

### Key Advantages Over Other Models
- **Speed:** 2-5x faster than CogVideoX or HunyuanVideo at equivalent quality
- **VRAM efficiency:** 12GB VRAM for 768×512 generation
- **Distilled variants:** LTX-2.3-GGUF for 8GB VRAM

### Basic LTX Video Generation in Python

```python
import torch
from diffusers import LTXPipeline
from diffusers.utils import export_to_video

pipe = LTXPipeline.from_pretrained(
    "Lightricks/LTX-Video-2.3",
    torch_dtype=torch.bfloat16
)
pipe.enable_model_cpu_offload()  # For 12GB VRAM

video = pipe(
    prompt="A butterfly landing on a flower in a sunlit garden, slow motion, 4K",
    negative_prompt="worst quality, inconsistent motion, blurry",
    width=768,
    height=512,
    num_frames=49,  # ~3 seconds at 16fps
    num_inference_steps=50,
    guidance_scale=3.0
).frames[0]

export_to_video(video, "butterfly.mp4", fps=24)
```

### Image-to-Video Workflow

```python
from PIL import Image

image = Image.open("reference_frame.jpg")

video = pipe(
    prompt="Camera slowly zooms out to reveal a vast ocean horizon",
    image=image,
    width=768,
    height=512,
    num_frames=49,
    num_inference_steps=40
).frames[0]

export_to_video(video, "zoom_out.mp4", fps=24)
```

### ComfyUI Workflows Included
The collection provides ready-to-use ComfyUI workflows for:
1. **Basic text-to-video** — Simple prompt-to-video
2. **Image-to-video with camera control** — Animate reference images
3. **Multi-scene stitching** — Chain multiple clips with consistent style
4. **GGUF quantized workflow** — For 8GB VRAM machines

### GGUF Variant (8GB VRAM)

```python
# Using GGUF quantized version
from gguf_loader import load_ltx_gguf

model = load_ltx_gguf(
    "LTX-Video-2.3-Q8_0.gguf",
    device="cuda"
)
```

### Performance Benchmarks

| Hardware | Resolution | Duration | Generation Time |
|---------|-----------|----------|-----------------|
| RTX 4090 | 768×512 | 3s | ~8 seconds |
| RTX 3090 | 768×512 | 3s | ~15 seconds |
| RTX 4080 | 1024×576 | 3s | ~12 seconds |
| RTX 3080 | 512×512 | 3s | ~20 seconds |

### Resources
- Model: https://huggingface.co/Lightricks/LTX-Video-2.3
- ComfyUI LTX node: [ComfyUI-LTXVideo](https://github.com/Lightricks/ComfyUI-LTXVideo)
