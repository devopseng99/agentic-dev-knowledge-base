---
title: "Jetson Containers Quickstart on NVIDIA Jetson AGX Orin 64GB"
url: "https://dev.to/vonusma/jetson-containers-quickstart-on-nvidia-jetson-agx-orin-64gb-2ed9"
author: "Sergio Andres Usma"
category: "jetson-robotics"
---
# Jetson Containers Quickstart on NVIDIA Jetson AGX Orin 64GB
**Author:** Sergio Andres Usma  **Published:** 2026-04-05

## Overview
Consolidates NVIDIA's Jetson Containers Quickstart into practical operational guidance for running localized AI services on a Jetson AGX Orin 64GB system. Provides copy-paste Docker commands and n8n integration patterns for LLMs, speech processing, vision models, and development tools — enabling multi-container AI orchestration without external cloud dependencies.

## Key Concepts
- LLM Inference Engines: Ollama, llama.cpp, vLLM, SGLang, MLC, nanoLLM
- Speech Services: faster-whisper (STT), kokoro-tts (TTS), speaches (unified)
- Vision/Diffusion: Stable Diffusion WebUI, ComfyUI, VILA (vision-language models)
- Development Tools: L4T-ML, JupyterLab, AIM experiment tracker, Home Assistant Core
- n8n Orchestration: OpenAI-compatible API patterns, webhook voice pipelines
- Container Networking: LAN IP addressing for cross-container communication

```bash
# GPU Verification
docker run --runtime nvidia --rm \
  dustynv/cuda:12.8-samples-r36.4.0-cu128-24.04 \
  /usr/local/cuda/extras/demo_suite/deviceQuery

# Directory Setup
mkdir -p ~/.ollama ~/.cache/huggingface ~/sd-models \
  ~/comfyui-models ~/comfyui-output ~/ml-workspace \
  ~/notebooks ~/aim-data ~/ha-config

# Ollama Container Launch
docker run --runtime nvidia -it -d \
  --name ollama \
  --network host \
  -v ~/.ollama:/root/.ollama \
  dustynv/ollama:r36.4.0

# llama.cpp Server
docker run --runtime nvidia -it -d \
  --name llama-server \
  --network host \
  -v /models:/models \
  dustynv/llama_cpp:r36.4.0 \
  llama-server \
    --model /models/llama-3.1-8b-q4.gguf \
    --host 0.0.0.0 --port 8080 \
    --n-gpu-layers 999 --ctx-size 8192

# vLLM Server
docker run --runtime nvidia -it -d \
  --name vllm \
  --network host \
  --shm-size=8g \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  dustynv/vllm:r36.4.0 \
  python3 -m vllm.entrypoints.openai.api_server \
    --model meta-llama/Llama-3.2-3B-Instruct \
    --host 0.0.0.0 --port 8000

# faster-whisper STT Server
docker run --runtime nvidia -it -d \
  --name faster-whisper \
  --network host \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  dustynv/faster-whisper:r36.4.0 \
  python3 -m faster_whisper.server \
    --host 0.0.0.0 --port 8000

# kokoro-tts Launch
docker run --runtime nvidia -it -d \
  --name kokoro-tts \
  --network host \
  dustynv/kokoro-tts:r36.4.0

# Stable Diffusion WebUI
docker run --runtime nvidia -it -d \
  --name sd-webui \
  --network host \
  -v ~/sd-models:/workspace/stable-diffusion-webui/models \
  dustynv/stable-diffusion-webui:r36.4.0 \
  python3 launch.py --api --listen --port 7860

# L4T-ML JupyterLab
docker run --runtime nvidia -it -d \
  --name l4t-ml \
  --network host \
  --shm-size=8g \
  -v ~/ml-workspace:/workspace \
  dustynv/l4t-ml:r36.4.0 \
  jupyter lab --ip=0.0.0.0 --allow-root --no-browser

# Home Assistant
docker run -it -d \
  --name homeassistant \
  --network host \
  -v ~/ha-config:/config \
  dustynv/homeassistant-core:r36.4.0
```

```bash
# Ollama Chat API
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3.2:3b",
    "messages": [{"role":"user","content":"Hello from n8n!"}]
  }'

# TTS API Request
curl http://localhost:8880/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kokoro",
    "input": "Hello from your Jetson!",
    "voice": "af_bella",
    "response_format": "mp3"
  }' \
  --output speech.mp3

# Multimodal Vision API
curl http://localhost:9000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "VILA1.5-3b",
    "messages": [{
      "role": "user",
      "content": [
        {"type": "image_url", "image_url": {"url": "http://example.com/img.jpg"}},
        {"type": "text", "text": "What is in this image?"}
      ]
    }]
  }'
```
