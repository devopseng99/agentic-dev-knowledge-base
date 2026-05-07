---
title: "Run Flux.1 on M3 Mac with Diffusers"
url: "https://dev.to/0xkoji/run-flux1-on-m3-mac-with-diffusers-9m5"
author: "0xkoji"
category: "ai-image-video-generation"
---
# Run Flux.1 on M3 Mac with Diffusers
**Author:** 0xkoji  **Published:** 2024-08-14

## Overview
Guide to running Black Forest Labs' Flux.1 image generation model on Apple Silicon M3 Mac using the HuggingFace Diffusers library with MPS (Metal Performance Shaders) acceleration.

## Key Concepts

### Requirements
- M3 Mac (16GB+ unified memory recommended; 8GB usable with quantization)
- Python 3.11+
- PyTorch with MPS support
- HuggingFace Diffusers

### Installation

```bash
# Create virtual environment
python -m venv flux-env
source flux-env/bin/activate

# Install PyTorch with MPS support
pip install torch torchvision torchaudio

# Install Diffusers and dependencies
pip install diffusers transformers accelerate sentencepiece protobuf
```

### Running Flux.1-schnell (Fastest, Apache 2.0)

```python
import torch
from diffusers import FluxPipeline

# Load Flux.1-schnell
pipe = FluxPipeline.from_pretrained(
    "black-forest-labs/FLUX.1-schnell",
    torch_dtype=torch.bfloat16
)

# Use MPS (Apple Silicon GPU)
pipe = pipe.to("mps")

# Generate image
image = pipe(
    "A majestic snow-capped mountain at dawn, photorealistic",
    guidance_scale=0.0,   # Schnell uses 0 guidance
    num_inference_steps=4, # 4 steps for schnell
    max_sequence_length=256,
    generator=torch.Generator("cpu").manual_seed(0)
).images[0]

image.save("mountain.png")
```

### Running Flux.1-dev (Higher Quality, Non-Commercial)

```python
pipe = FluxPipeline.from_pretrained(
    "black-forest-labs/FLUX.1-dev",
    torch_dtype=torch.bfloat16
)
pipe.enable_model_cpu_offload()  # Reduces peak VRAM

image = pipe(
    "Portrait of a robot chef preparing gourmet food, studio lighting",
    height=1024,
    width=1024,
    guidance_scale=3.5,
    num_inference_steps=50,
    max_sequence_length=512,
    generator=torch.Generator("cpu").manual_seed(42)
).images[0]
```

### Memory Optimization for 8GB M3

```python
# For 8GB unified memory
pipe = FluxPipeline.from_pretrained(
    "black-forest-labs/FLUX.1-schnell",
    torch_dtype=torch.float16  # float16 instead of bfloat16
)

# Enable sequential CPU offloading
pipe.enable_sequential_cpu_offload()

# Reduce image size
image = pipe(
    "Your prompt here",
    height=512,
    width=512,
    num_inference_steps=4
).images[0]
```

### Performance on M3

| Model | M3 Pro 18GB | M3 Max 36GB | Steps |
|-------|------------|------------|-------|
| Flux.1-schnell 512×512 | ~25s | ~15s | 4 |
| Flux.1-schnell 1024×1024 | ~65s | ~40s | 4 |
| Flux.1-dev 1024×1024 | ~8m | ~5m | 50 |

### Comparison vs. GPU Cloud
- Local M3 Pro: ~65s/image at 1024px (schnell)
- Replicate API: ~8s/image
- Trade-off: Local = free, private, offline; Cloud = 8x faster

### HuggingFace Token Required
```bash
huggingface-cli login
# Required for FLUX.1-dev (gated model)
```
