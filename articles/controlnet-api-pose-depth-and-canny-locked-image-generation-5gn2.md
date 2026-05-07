---
title: "ControlNet API: pose, depth, and canny-locked image generation"
url: "https://dev.to/om_prakash_3311f8a4576605/controlnet-api-pose-depth-and-canny-locked-image-generation-5gn2"
author: "Om Prakash"
category: "ai-image-video-generation"
---
# ControlNet API: pose, depth, and canny-locked image generation
**Author:** Om Prakash  **Published:** 2026-05-05

## Overview
Introduces a unified API endpoint (`POST /v1/image/controlnet`) for guided image generation that preserves specific visual characteristics from reference images while regenerating other aspects based on text prompts. Originally published at pixelapi.dev.

## Key Concepts

### Control Types
The API extracts control signals from reference images using four control types:
- **Canny**: Preserves edge detection
- **Depth**: Locks 3D structural information
- **OpenPose**: Maintains human body positioning
- **Scribble**: Retains rough line drawings

### Essential Request Parameters
- `image_url` (required): Publicly accessible reference image
- `control_type` (required): One of the four signal types
- `prompt` (required): Desired output description
- `negative_prompt` (optional): Elements to exclude
- `strength` (0.0–1.0, default 0.8): Controls adherence strictness

### Pricing
14 credits per call (₹0.0095 or $0.00011 USD), regardless of control type. Failed requests don't consume credits.

### Practical Use Cases

**Product Photography:** Teams can shoot a model once in multiple poses, then generate different outfits and backdrops while maintaining stance consistency.

**Illustration Workflow:** Artists sketch compositions, which become control signals for finished colored artwork generation.

**Architectural Visualization:** Depth passes from wireframes lock building geometry while allowing variations in lighting, materials, and weather conditions.

```bash
curl -X POST https://api.pixelapi.dev/v1/image/controlnet \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "image_url": "https://example.com/reference.jpg",
    "control_type": "openpose",
    "prompt": "professional model wearing blue suit, studio lighting",
    "strength": 0.8
  }'
```

```python
import requests

resp = requests.post(
    "https://api.pixelapi.dev/v1/image/controlnet",
    headers={
        "Authorization": "Bearer YOUR_API_KEY",
        "Content-Type": "application/json",
    },
    json={
        "image_url": "https://example.com/reference.jpg",
        "control_type": "depth",
        "prompt": "photorealistic building exterior, golden hour lighting",
        "negative_prompt": "blurry, distorted",
        "strength": 0.75,
    },
    timeout=60,
)
resp.raise_for_status()
result = resp.json()
print(result)
```
