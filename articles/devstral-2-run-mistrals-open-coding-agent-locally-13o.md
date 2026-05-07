---
title: "Devstral 2: Run Mistral's Open Coding Agent Locally"
url: "https://dev.to/jangwook_kim_e31e7291ad98/devstral-2-run-mistrals-open-coding-agent-locally-13o"
author: "Jangwook Kim"
category: "mistral-ai-agent"
---

# Devstral 2: Run Mistral's Open Coding Agent Locally

**Author:** Jangwook Kim
**Published:** May 2, 2026

## Overview
Devstral 2 (72.2% SWE-bench Verified) is an open-weights coding agent that matches Claude Sonnet 4.5's general performance territory while running fully on-premise. Devstral Small 2 (68.0%) fits on a single RTX 4090 or Mac with 32GB RAM under Apache 2.0 license. Guide covers specs, benchmarks, local setup via Ollama, and IDE/OpenHands integration.

## Key Concepts

### The Two Models

| Feature | Devstral 2 | Devstral Small 2 |
|---------|-----------|-----------------|
| Parameters | 123B | 24B |
| Context window | 256K tokens | 256K tokens |
| SWE-bench Verified | 72.2% | 68.0% |
| License | Modified MIT | Apache 2.0 |
| API input price | $0.40/1M tokens | $0.10/1M tokens |
| API output price | $2.00/1M tokens | $0.30/1M tokens |
| Minimum VRAM (local) | ~80GB (multi-GPU) | 24GB (single RTX 4090) |

### Install Ollama and Pull Model

```bash
# macOS (Homebrew)
brew install ollama

# Linux
curl -fsSL https://ollama.com/install.sh | sh

# Pull Devstral Small 2
ollama pull devstral-small-2:24b

# Verify
ollama list
```

### Run First Coding Query

```bash
ollama run devstral-small-2:24b
```

### Serve as Local API Endpoint

```bash
ollama serve
# Listening on 0.0.0.0:11434
```

```bash
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "devstral-small-2:24b",
    "messages": [
      {
        "role": "user",
        "content": "Write a Python function that validates an email address using regex."
      }
    ]
  }'
```

### Continue IDE Configuration

```json
{
  "models": [
    {
      "title": "Devstral Small 2",
      "provider": "ollama",
      "model": "devstral-small-2:24b",
      "contextLength": 32768
    }
  ]
}
```

### OpenHands Integration

```bash
# With Mistral API
docker pull ghcr.io/all-hands-ai/openhands:latest

docker run -it --rm \
  -e LLM_API_KEY="your-mistral-api-key" \
  -e LLM_MODEL="devstral-2-123b-instruct-2512" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 3000:3000 \
  ghcr.io/all-hands-ai/openhands:latest
```

```bash
# With local Ollama
docker run -it --rm \
  -e LLM_API_BASE="http://host.docker.internal:11434/v1" \
  -e LLM_API_KEY="ollama" \
  -e LLM_MODEL="ollama/devstral-small-2:24b" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 3000:3000 \
  ghcr.io/all-hands-ai/openhands:latest
```

### Troubleshooting

```bash
# CUDA out of memory - reduce context length
ollama run devstral-small-2:24b --num-ctx 16384

# Check GPU utilization
ollama ps

# Verify Ollama is running
curl http://localhost:11434/api/version
```
