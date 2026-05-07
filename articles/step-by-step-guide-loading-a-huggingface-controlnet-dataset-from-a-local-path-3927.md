---
title: "Step-by-Step Guide: Loading a HuggingFace ControlNet Dataset from a Local Path"
url: "https://dev.to/dangattringer/step-by-step-guide-loading-a-huggingface-controlnet-dataset-from-a-local-path-3927"
author: "Daniel Gattringer"
category: "huggingface-llm-agents"
---
# Step-by-Step Guide: Loading a HuggingFace ControlNet Dataset from a Local Path
**Author:** Daniel Gattringer  **Published:** August 15, 2024

## Overview
This tutorial demonstrates how to load local image datasets for ControlNet training using HuggingFace's dataset tools. The guide covers dataset structuring, metadata file creation, and implementation of a custom loading script using the GeneratorBasedBuilder pattern.

## Key Concepts
- Dataset Structure — organizing conditioning images, target images, and captions
- Metadata Files — using JSONL format to link images with conditioning images and captions
- Loading Script — custom GeneratorBasedBuilder implementation for dataset handling
- Feature Definitions — specifying image and text data types for datasets

## Code Examples

### Python - Metadata File Creation
```python
import json
from pathlib import Path

def create_metadata(data_dir, output_file):
    metadata = []
    with open(f"{data_dir}/captions.jsonl", "r") as f:
        for line in f:
            data = json.loads(line)
            file_name = Path(data["image"]).name
            metadata.append({
                "image": data["image"],
                "conditioning_image": f"conditioning_images/{file_name}",
                "text": data["text"],
            })
    with open(f"{data_dir}/metadata.jsonl", "w") as f:
        for line in metadata:
            f.write(json.dumps(line) + "\n")
```

### Python - Loading Script Template
```python
import os
import json
import datasets
from pathlib import Path

class MyDataset(datasets.GeneratorBasedBuilder):
    def _info(self):
        pass

    def _split_generators(self, dl_manager):
        pass

    def _generate_examples(self, metadata_path, images_dir,
                          conditioning_images_dir):
        pass
```

### Python - Dataset Loading
```python
from datasets import load_dataset

ds = load_dataset("my_dataset")
# With custom code warning suppression:
ds = load_dataset("my_dataset", trust_remote_code=True)
```

### JSONL - Metadata Format
```jsonl
{"image": "images/00001.jpg", "conditioning_image": "conditioning_images/00001.jpg", "text": "Caption text"}
```
