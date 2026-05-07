---
title: "Deploying HuggingFace Chat UI with the Hugging Face Text Generation Inference Server"
url: "https://dev.to/mahmoudrasmyfathy1/deploying-huggingface-chat-ui-with-the-hugging-face-text-generation-inference-server-n3h"
author: "Mahmoud Sehsah"
category: "huggingface-llm-agents"
---
# Deploying HuggingFace Chat UI with the Hugging Face Text Generation Inference Server
**Author:** Mahmoud Sehsah  **Published:** January 23, 2024

## Overview
This guide provides a comprehensive walkthrough for deploying the Hugging Face Chat UI alongside the Text Generation Inference Server. The article covers API endpoint exploration, server configuration, and Docker-based deployment using the Mistral-7B model with 8-bit quantization for GPU memory optimization.

## Key Concepts
- Text Generation Inference Server Setup — launching with 8-bit quantization
- API Endpoints — multiple generation strategies including standard, streaming, and sampling modes
- Monitoring — health checks, server information retrieval, and performance metrics
- Environment Configuration — MongoDB and TGI backend setup via .env files
- Containerization — Docker-based deployment of both services

## Code Examples

### Docker TGI Server Startup
```bash
docker run --gpus all --shm-size 1g -p 8080:80 -v $volume:/data \
  ghcr.io/huggingface/text-generation-inference:1.3 \
  --quantize=bitsandbytes --model-id $model
```

### cURL Generate Endpoint
```bash
curl --location 'http://127.0.0.1:8080/generate' \
--header 'Content-Type: application/json' \
--data '{"inputs":"What is Deep Learning?","parameters":{"max_new_tokens":20}}'
```

### cURL Streaming Endpoint
```bash
curl --location 'http://127.0.0.1:8080/generate_stream' \
--header 'Content-Type: application/json' \
--data '{"inputs":"What is Deep Learning?","parameters":{"max_new_tokens":20}}'
```

### cURL Sampling Configuration
```bash
curl --location 'http://127.0.0.1:8080/generate' \
--header 'Content-Type: application/json' \
--data '{"inputs":"What is Deep Learning?","parameters":{"max_new_tokens":100, "do_sample":true, "top_k":50}}'
```

### cURL Temperature Adjustment
```bash
curl --location 'http://127.0.0.1:8080/generate' \
--header 'Content-Type: application/json' \
--data '{"inputs":"What is Deep Learning?","parameters":{"max_new_tokens":50, "do_sample":true, "top_k":50, "temperature":0.2}}'
```

### cURL Health and Metrics
```bash
curl --location 'http://127.0.0.1:8080/health'
curl --location 'http://127.0.0.1:8080/info'
curl --location 'http://127.0.0.1:8080/metrics'
```

### Environment Variables
```bash
export model=mistralai/Mistral-7B-v0.1
export volume=$PWD/data
```

### Model Configuration
```json
{
  "name": "mistralai/Mistral-7B-Instruct-v0.1-local",
  "displayName": "mistralai/Mistral-7B-Instruct-v0.1-name",
  "description": "Mistral 7B is a new Apache 2.0 model, released by Mistral AI that outperforms Llama2 13B in benchmarks.",
  "websiteUrl": "https://mistral.ai/news/announcing-mistral-7b/",
  "parameters": {
    "temperature": 0.1,
    "top_p": 0.95,
    "repetition_penalty": 1.2,
    "top_k": 50,
    "max_new_tokens": 1024,
    "stop": ["</s>"]
  },
  "endpoints": [{
    "type": "tgi",
    "url": "http://${TEXT_GENERATION_INFERENCE_SERVER}:80/"
  }]
}
```

### Docker Deployment Sequence
```bash
git clone https://github.com/huggingface/chat-ui.git
docker run -d -p 27017:27017 --name mongo-chatui mongo:latest
DOCKER_BUILDKIT=1 docker build -t hugging-face-ui .
docker run -p:3000:3000 hugging-face-ui
```
