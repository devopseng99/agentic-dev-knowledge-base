---
title: "Creating Coding AI Agents with Ollama"
url: "https://dev.to/potpie/creating-coding-ai-agents-with-ollama-36pk"
author: "Ayush Thakur"
category: "ai-agents-local-llm"
---

# Creating Coding AI Agents with Ollama

**Author:** Ayush Thakur
**Published:** February 27, 2025
**Tags:** #ai #webdev #programming #coding

---

## Overview

Potpie has launched a multi-LLM feature enabling developers to integrate multiple language models, including Ollama, for building AI agents. The feature leverages LiteLLM, "a lightweight framework that standardizes API calls across multiple AI providers."

---

## What is Ollama?

Ollama is a locally hosted LLM solution that packages large language models into self-contained bundles. Key advantages include:

- **Privacy & Security** – No external API calls; data stays local
- **Lower Latency** – Faster responses without network dependency
- **Cost Efficiency** – No API fees for frequent queries
- **Customizability** – Supports fine-tuning and model modifications

The platform uses optimized libraries like llama.cpp for efficient inference on CPUs and GPUs.

---

## Configuration Setup

Integrating an LLM requires four key parameters:

```plaintext
LLM_PROVIDER=ollama
LLM_API_KEY=ollama
LOW_REASONING_MODEL=ollama_chat/qwen2.5-coder:7b
HIGH_REASONING_MODEL=ollama_chat/qwen2.5-coder:7b
```

---

## Why Choose Ollama with Potpie?

Running Potpie locally with Ollama enables developers to:

- Experiment with open-source, fine-tuned, or custom models
- Eliminate inference costs through local hardware execution
- Enhance security by preventing external data transmission
- Reduce latency by eliminating network dependencies

---

## Supported LLM Models

Beyond Ollama, Potpie supports:

- **OpenAI's GPT** – Strong code generation capabilities
- **Google's Gemini** – Multimodal tasks with advanced reasoning
- **Anthropic's Claude** – Excels at code understanding
- **Meta's Llama** – Open-source with customization flexibility
- **DeepSeek** – Cost-efficient with strong reasoning abilities

---

## Getting Started

Access Potpie v0.1.1 via the [GitHub releases page](https://github.com/potpie-ai/potpie/releases/tag/v0.1.1) and follow the [Getting Started Guide](https://github.com/potpie-ai/potpie/blob/main/GETTING_STARTED.md) for installation and configuration.
