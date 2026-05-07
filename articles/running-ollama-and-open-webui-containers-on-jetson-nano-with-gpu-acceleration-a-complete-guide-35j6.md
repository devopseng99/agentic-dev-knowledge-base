---
title: "Running Ollama and Open WebUI containers on NVIDIA Jetson device with GPU Acceleration: A Complete Guide"
url: "https://dev.to/ajeetraina/running-ollama-and-open-webui-containers-on-jetson-nano-with-gpu-acceleration-a-complete-guide-35j6"
author: "Ajeet Singh Raina"
category: "jetson-robotics"
---
# Running Ollama and Open WebUI containers on NVIDIA Jetson device with GPU Acceleration: A Complete Guide
**Author:** Ajeet Singh Raina  **Published:** 2024-11-30

## Overview
Guide demonstrating how to set up Ollama and Open WebUI on NVIDIA Jetson devices for locally running Large Language Models with GPU acceleration, emphasizing privacy and offline operation capabilities.

## Key Concepts
- NVIDIA Jetson device specifications and capabilities
- L4T (Linux for Tegra) version verification and compatibility
- Docker containerization for LLM deployment
- GPU acceleration optimization
- Model selection (TinyLlama, LLaMA3.2)
- Hardware constraints on Jetson Nano (4GB memory limitations)
- Quantization techniques for memory efficiency
- API endpoint access and documentation

```bash
# Verify L4T Version
head -n 1 /etc/nv_tegra_release

# Update System
sudo apt update && sudo apt upgrade

# Install JetPack
sudo apt install jetpack

# Add User to Docker Group
sudo usermod -aG docker $USER && \
newgrp docker && \
sudo systemctl daemon-reload && \
sudo systemctl restart docker

# Install Jetson Examples
pip3 install jetson-examples

# Install Ollama
reComputer run ollama

# Source Profile
source ~/.profile

# Run TinyLlama Model
ollama run tinyllama
```

```python
# Python Factorial Script (from TinyLlama output)
def factorial(n):
    if n == 0 or n == 1:
        return 1
    else:
        return n * factorial(n - 1)

num = int(input("Enter a number: "))
print(f"The factorial of {num} is {factorial(num)}")
```

```bash
# Pull LLaMA Model
ollama pull llama3.2

# Run Open WebUI with GPU
sudo docker run -d -p 3000:8080 --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama

# Run Open WebUI CPU-Only
sudo docker run -d -p 3000:8080 -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
```

## GitHub Repos
- https://github.com/ollama/ollama/releases/tag/v0.4.2
- https://github.com/Seeed-Projects/jetson-examples
