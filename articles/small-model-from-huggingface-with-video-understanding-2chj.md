---
title: "Small Model from Huggingface with Video understanding"
url: "https://dev.to/amrs-tech/small-model-from-huggingface-with-video-understanding-2chj"
author: "Ahamed Musthafa R S"
category: "huggingface-llm-agents"
---
# Small Model from Huggingface with Video understanding
**Author:** Ahamed Musthafa R S  **Published:** February 27, 2025

## Overview
The article presents a practical tutorial on using HuggingFace's SmolVLM-2 model, which adds video comprehension capabilities to vision-language models. The author demonstrates implementation of the 500M parameter variant on Google Colab with a T4 GPU. SmolVLM-2 is available in 2.2B, 500M, and 256M parameter variants.

## Key Concepts
- SmolVLM-2 variants — 2.2B, 500M, and 256M parameter models
- Primary enhancement — video input understanding (previously image-only)
- Data type optimization — bfloat16 precision for efficient processing
- Deployment potential — mobile device compatibility

## Code Examples

### Installation Requirements
```bash
!pip install wheel decord pyav num2words
!pip install flash-attn --no-build-isolation
!pip install git+https://github.com/huggingface/transformers@v4.49.0-SmolVLM-2
```

### Model Loading
```python
from transformers import AutoProcessor, AutoModelForImageTextToText
import torch

model_path = "HuggingFaceTB/SmolVLM2-500M-Video-Instruct"
processor = AutoProcessor.from_pretrained(model_path)
model = AutoModelForImageTextToText.from_pretrained(
    model_path,
    torch_dtype=torch.bfloat16,
).to("cuda")
```

### Parameter Dtype Conversion
```python
for name, param in model.named_parameters():
    if param.dtype == torch.float32:
        param.data = param.data.to(torch.bfloat16)
```

### Message Formatting
```python
messages = [
    {
        "role": "user",
        "content": [
            {"type": "video", "path": vdo_pth},
            {"type": "text", "text": "Describe this video in detail"}
        ]
    },
]
```

### Input Processing
```python
inputs = processor.apply_chat_template(
    messages,
    add_generation_prompt=True,
    tokenize=True,
    return_dict=True,
    return_tensors="pt",
).to("cuda")
```

### Inference
```python
generated_ids = model.generate(**inputs, max_new_tokens=254)
generated_texts = processor.batch_decode(
    generated_ids,
    skip_special_tokens=True,
)
print('OUT: ', generated_texts[0])
```
