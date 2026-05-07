---
title: "Generate Professional AI Videos in Seconds with LTX by Lightricks"
url: "https://dev.to/nodeshiftcloud/generate-professional-ai-videos-in-seconds-with-ltx-by-lightricks-o97"
author: "Aditi Bindal (NodeShift)"
category: "ai-media-generation"
---
# Generate Professional AI Videos in Seconds with LTX by Lightricks
**Author:** Aditi Bindal (NodeShift)  **Published:** May 14, 2025

## Overview
This tutorial demonstrates how to install and operate LTX-Video, a DiT-based video generation model that creates 30 FPS videos at 1216×704 resolution. The guide covers GPU setup via NodeShift cloud services and practical implementation of both text-to-video and image-to-video generation pipelines.

## Key Concepts
- Denoising Diffusion Transformer (DiT) architecture for video synthesis
- Real-time video rendering capabilities
- Text-to-video and image-to-video generation modes
- GPU infrastructure requirements (RTX A6000 minimum with 16GB VRAM)
- Cloud-based deployment and SSH connectivity

```python
import torch
from diffusers import LTXPipeline
from diffusers.utils import export_to_video

pipe = LTXPipeline.from_pretrained("Lightricks/LTX-Video", torch_dtype=torch.bfloat16)
pipe.to("cuda")

prompt = "A woman with blood on her face..."
negative_prompt = "worst quality, inconsistent motion, blurry..."

video = pipe(
    prompt=prompt,
    negative_prompt=negative_prompt,
    width=704,
    height=480,
    num_frames=161,
    num_inference_steps=50,
).frames[0]
export_to_video(video, "output.mp4", fps=24)
```

```python
import torch
from diffusers import LTXImageToVideoPipeline
from diffusers.utils import export_to_video, load_image

pipe = LTXImageToVideoPipeline.from_pretrained("Lightricks/LTX-Video", torch_dtype=torch.bfloat16)
pipe.to("cuda")

image = load_image("https://...")
prompt = "A young girl stands calmly..."
video = pipe(image=image, prompt=prompt, width=704, height=480, num_frames=161, num_inference_steps=50).frames[0]
export_to_video(video, "output.mp4", fps=24)
```

```bash
python inference.py --prompt "PROMPT" --height HEIGHT --width WIDTH --num_frames NUM_FRAMES --seed SEED --pipeline_config ltxv-13b-0.9.7-dev.yaml
```

- GitHub: https://github.com/Lightricks/LTX-Video
