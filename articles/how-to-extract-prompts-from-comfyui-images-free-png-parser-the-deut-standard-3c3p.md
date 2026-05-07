---
title: "How to Extract Prompts from ComfyUI Images: Free PNG Parser & the .deut Standard"
url: "https://dev.to/yuriy_sydorenko_deut/how-to-extract-prompts-from-comfyui-images-free-png-parser-the-deut-standard-3c3p"
author: "Yuriy Sydorenko"
category: "ai-image-video-generation"
---
# How to Extract Prompts from ComfyUI Images: Free PNG Parser & the .deut Standard
**Author:** Yuriy Sydorenko  **Published:** 2026-02-25

## Overview
ComfyUI embeds full workflow metadata in PNG files. This article covers how to extract that metadata programmatically and introduces the `.deut` standard for portable, interoperable AI image metadata.

## Key Concepts

### ComfyUI PNG Metadata
When ComfyUI generates an image, it embeds the complete workflow JSON and prompt data in the PNG's metadata chunks. This data can be extracted to reproduce exactly the same generation.

### Extracting Metadata Programmatically

```python
from PIL import Image
import json

def extract_comfyui_metadata(image_path: str) -> dict:
    """Extract ComfyUI workflow data from PNG metadata."""
    img = Image.open(image_path)

    metadata = {}
    if hasattr(img, 'text'):
        for key, value in img.text.items():
            if key == 'workflow':
                metadata['workflow'] = json.loads(value)
            elif key == 'prompt':
                metadata['prompt'] = json.loads(value)
            else:
                metadata[key] = value

    return metadata

# Usage
data = extract_comfyui_metadata("generated_image.png")
workflow = data.get('workflow', {})
prompt_nodes = data.get('prompt', {})
print(json.dumps(prompt_nodes, indent=2))
```

### Extracting Specific Prompt Text

```python
def get_positive_prompt(metadata: dict) -> str:
    """Extract positive prompt text from ComfyUI metadata."""
    prompt = metadata.get('prompt', {})

    for node_id, node_data in prompt.items():
        class_type = node_data.get('class_type', '')
        inputs = node_data.get('inputs', {})

        # Look for CLIPTextEncode nodes (positive prompt)
        if class_type == 'CLIPTextEncode' and 'text' in inputs:
            if isinstance(inputs['text'], str):
                return inputs['text']

    return ""

# Usage
metadata = extract_comfyui_metadata("my_image.png")
positive_prompt = get_positive_prompt(metadata)
print(f"Positive prompt: {positive_prompt}")
```

### The .deut Standard
The `.deut` standard proposes a portable metadata format for AI images that works across different generation tools (not just ComfyUI):

```json
{
  "deut_version": "1.0",
  "generator": "ComfyUI",
  "model": "sdxl-base-1.0",
  "positive_prompt": "a beautiful landscape at sunset",
  "negative_prompt": "blurry, low quality",
  "seed": 42,
  "steps": 20,
  "cfg_scale": 7.5,
  "sampler": "euler_ancestral",
  "width": 1024,
  "height": 1024,
  "timestamp": "2026-02-25T10:30:00Z"
}
```

### Free PNG Parser Tool
The author provides a free online tool for parsing ComfyUI PNG files and a Python library:

```bash
pip install deut-parser
```

```python
from deut_parser import parse_image

# Works with ComfyUI, Automatic1111, InvokeAI
result = parse_image("my_generated_image.png")
print(result.positive_prompt)
print(result.model)
print(result.seed)
```

### Use Cases
- Reproduce generations from shared images
- Build prompt libraries from generated content
- Enable image search by prompt metadata
- Audit AI-generated content in workflows
- Share complete generation parameters with collaborators
