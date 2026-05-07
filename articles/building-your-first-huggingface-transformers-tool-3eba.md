---
title: "Building Your First HuggingFace Transformers Tool"
url: "https://dev.to/aws/building-your-first-huggingface-transformers-tool-3eba"
author: "Banjo Obayomi"
category: "huggingface-llm-agents"
---
# Building Your First HuggingFace Transformers Tool
**Author:** Banjo Obayomi  **Published:** May 16, 2023

## Overview
This tutorial demonstrates how to create a custom AI tool using the HuggingFace Transformers library. The example project builds a "Cat Image Fetcher" tool that retrieves random cat images from an online API and integrates it with an AI agent system using HfAgent and StarCoder.

## Key Concepts
- Tool Architecture — Creating classes that inherit from the Transformers `Tool` superclass
- Required Attributes — name, description, inputs, outputs, and `__call__` method
- Agent Integration — Using custom tools with `HfAgent` for multi-tool workflows
- Hub Distribution — Publishing tools to HuggingFace Model Hub

## Installation
```bash
pip install requests Pillow transformers
```

## Code Examples

### Basic Image Fetching
```python
import requests
from PIL import Image

image = Image.open(requests.get('https://cataas.com/cat', stream=True).raw)
```

### Tool Class Definition
```python
from transformers import Tool

class CatImageFetcher(Tool):
    name = "cat_fetcher"
    description = ("This is a tool that fetches an actual image of a cat online. It takes no input, and returns the image of a cat.")
    inputs = []
    outputs = ["image"]

    def __call__(self):
        return Image.open(requests.get('https://cataas.com/cat', stream=True).raw).resize((256, 256))
```

### Agent Setup
```python
from transformers.tools import HfAgent

agent = HfAgent("https://api-inference.huggingface.co/models/bigcode/starcoder", additional_tools=[tool])
agent.run("Fetch an image of a cat online and caption it for me")
```

### Publishing to Hub
```python
tool.push_to_hub("YOUR-TOOL")
```
