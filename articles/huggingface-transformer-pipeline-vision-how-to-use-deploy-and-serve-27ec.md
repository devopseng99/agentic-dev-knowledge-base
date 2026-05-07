---
title: "HuggingFace Transformer Pipeline - Vision: How to Use, Deploy and Serve"
url: "https://dev.to/wjiuhe/huggingface-transformer-pipeline-vision-how-to-use-deploy-and-serve-27ec"
author: "wjiuhe"
category: "huggingface-llm-agents"
---
# HuggingFace Transformer Pipeline - Vision: How to Use, Deploy and Serve
**Author:** wjiuhe  **Published:** April 17, 2022

## Overview
This tutorial demonstrates how to leverage Hugging Face's vision classification pipeline and deploy it as a REST API using Pinferencia. The article covers model usage, batch processing, and practical deployment with an interactive web UI served at localhost:8000.

## Key Concepts
- Hugging Face Pipelines — pre-trained models for vision tasks with automatic model downloading
- Image Classification — identifying objects in images with confidence scores
- Batch Processing — processing multiple images simultaneously
- Pinferencia Deployment — lightweight framework for serving ML models via REST API
- Interactive UI — web-based interface for model testing

## Code Examples

### Basic Image Classification
```python
from transformers import pipeline

vision_classifier = pipeline(task="image-classification")

vision_classifier(
    images="https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/pipeline-cat-chonk.jpeg"
)
```

### Batch Processing
```python
image = "https://cdn.pixabay.com/photo/2018/08/12/16/59/parrot-3601194_1280.jpg"
vision_classifier(
    images=[image, image]
)
```

### Pinferencia Deployment Setup (app.py)
```python
from transformers import pipeline
from pinferencia import Server

vision_classifier = pipeline(task="image-classification")

def predict(data):
    return vision_classifier(images=data)

service = Server()
service.register(
    model_name="vision",
    model=predict,
)
```

### REST API Request (cURL)
```bash
curl --location --request POST 'http://127.0.0.1:8000/v1/models/vision/predict' \
--header 'Content-Type: application/json' \
--data-raw '{
    "data": "https://cdn.pixabay.com/photo/2018/08/12/16/59/parrot-3601194_1280.jpg"
}'
```

### API Request (Python)
```python
import requests

response = requests.post(
    url="http://localhost:8000/v1/models/vision/predict",
    json={
        "data": "https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/pipeline-cat-chonk.jpeg"
    },
)
print("Prediction:", response.json()["data"])
```

### Installation
```bash
pip install "pinferencia[uvicorn]"
```
