---
title: "Build a Browser Use Agent with DeepSeek: A Step-by-Step Guide"
url: "https://dev.to/nodeshiftcloud/build-a-browser-use-agent-with-deepseek-a-step-by-step-guide-2n59"
author: "Aditi Bindal"
category: "deepseek-ai-agent"
---

# Build a Browser Use Agent with DeepSeek: A Step-by-Step Guide

**Author:** Aditi Bindal
**Published:** January 30, 2025

## Overview
A comprehensive walkthrough for creating AI agents that autonomously navigate and interact with web content using DeepSeek's AI model combined with the Browser Use web UI.

## Key Concepts

### System Requirements
- Minimum 2 vCPUs, 8GB RAM, 50GB SSD
- Ubuntu 22.04 VM

### Docker Installation
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update

sudo apt install docker-ce docker-ce-cli containerd.io -y

docker --version

sudo systemctl start docker
sudo systemctl enable docker
```

### Browser Use Web UI Setup
```bash
git clone https://github.com/browser-use/web-ui.git
docker compose up --build
```

Access the application at `http://localhost:7788` or `http://<SERVER_IP>:7788`.

### DeepSeek Configuration

**Agent Settings:**
- Agent Type: Original or custom (with modified system prompts)
- Max Run Steps: Control iteration limits
- Max Actions per Step: Limit concurrent actions
- Use Vision: Enable visual processing capabilities

**Two Integration Methods:**
1. **Ollama Server:** Install DeepSeek-R1 locally, select "ollama" as provider
2. **API Key Method:** Select "deepseek" provider, choose "deepseek-reasoner" model, input API key

### Example: Information Gathering
Prompt: "Find the best study cafes in Berlin and provide a list of top ones"

Agent reasoning: "The Google search results page contains several links. The Yelp link provides a top 10 list, sufficient for the top 5 request."

Results:
1. 19grams Alex
2. Bonanza
3. Oslo Kaffebar
4. Cuccuma
5. Einstein Kaffee
