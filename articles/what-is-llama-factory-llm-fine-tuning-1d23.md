---
title: "What is LLaMA Factory? LLM Fine-Tuning"
url: "https://dev.to/voltagent/what-is-llama-factory-llm-fine-tuning-1d23"
author: "Necati Ozmen"
category: "llm-fine-tuning-agent"
---

# What is LLaMA Factory? LLM Fine-Tuning

**Author:** Necati Ozmen
**Published:** May 21, 2025

## Overview

Introduction to LLaMA-Factory, an open-source tool supporting fine-tuning of 100+ LLMs and vision-language models with multiple methods (SFT, PPO, DPO, KTO, ORPO, LoRA, QLoRA).

## Key Concepts

### Supported Features

- **Models:** LLaMA, Mistral, ChatGLM, Qwen, Gemma, DeepSeek, and more
- **Methods:** SFT, Continuous Pre-training, PPO, DPO, KTO, ORPO
- **Efficiency:** FlashAttention-2, Unsloth, GaLore, multiple quantization formats
- **Interfaces:** CLI and LLaMA Board web UI (Gradio)
- **Tasks:** Multi-turn dialogue, tool use, image/video/audio understanding

### Installation

```bash
git clone --depth 1 https://github.com/hiyouga/LLaMA-Factory.git
cd LLaMA-Factory
pip install -e ".[torch,metrics]"
```

### Running Fine-Tuning

```bash
# CLI method
llamafactory-cli train examples/train_lora/llama3_lora_sft.yaml

# Web UI method
llamafactory-cli webui

# Quick chat after tuning
llamafactory-cli chat path_to_your_finetuned_model_or_adapter_config.yaml
```

### Model Export

```bash
llamafactory-cli export your_config.yaml
```

### Experiment Tracking

Integrates with LlamaBoard, TensorBoard, Weights & Biases, MLflow, and SwanLab.

### Deployment

- OpenAI-style API
- vLLM and SGLang worker support
- Exported models compatible with Hugging Face Hub

**Research Paper:** "LlamaFactory: Unified Efficient Fine-Tuning of 100+ Language Models" (ACL 2024)
**Repository:** https://github.com/hiyouga/LLaMA-Factory
