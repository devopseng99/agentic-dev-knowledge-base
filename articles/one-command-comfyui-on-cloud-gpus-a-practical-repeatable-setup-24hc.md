---
title: "One-command ComfyUI on Cloud GPUs: A Practical, Repeatable Setup"
url: "https://dev.to/promptingpixels/one-command-comfyui-on-cloud-gpus-a-practical-repeatable-setup-24hc"
author: "Prompting Pixels"
category: "ai-image-video-generation"
---
# One-command ComfyUI on Cloud GPUs: A Practical, Repeatable Setup
**Author:** Prompting Pixels  **Published:** 2025-11-30

## Overview
Deployment automation tool for ComfyUI on cloud GPU instances (Vast.ai, RunPod) that generates single-line shell commands to install ComfyUI, download models, and install custom nodes.

## Key Concepts

### Problem Statement
Manual ComfyUI deployment requires: manually pulling Git repos, downloading models from various sources, guessing folder locations, installing custom nodes with uncertain dependencies, and repeated service restarts.

### Solution
A web generator at `deploy.promptingpixels.com` generates single-line shell commands.

### Implementation Steps

**1. Launch GPU Instance**
Select either Vast.ai or RunPod and access a terminal.

**2. Generate Script**
The web generator allows:
- Select cloud provider
- Search and add models from Hugging Face or Civitai
- Choose custom nodes (e.g., Impact Pack)
- Optionally pin ComfyUI versions

**3. Execute One-Liner**

```bash
export HF_TOKEN=hf_your_read_token_here
export CIVITAI_TOKEN=your_civitai_token_here
bash <(wget -qO- https://deploy.promptingpixels.com//api/script/[ID])
```

**4. Verify Installation**

```bash
git -C "$COMFYUI_ROOT" rev-parse --short HEAD
ls -1 "$COMFYUI_ROOT/models/checkpoints" | head
ls -1 "$COMFYUI_ROOT/custom_nodes" | sort | head -n 20
```

### Advanced Features

```bash
# Advanced customization
git -C "$COMFYUI_ROOT" checkout <commit-or-tag>
pip install xformers==0.0.23 safetensors==0.4.3
nvidia-smi || echo "No GPU found"
```

### Provider-Specific Paths
- **Vast.ai:** `/workspace/ComfyUI`
- **RunPod:** `/workspace/runpod-slim/ComfyUI`

### Key Environment Variables

```bash
export HF_TOKEN=hf_xxx
export CIVITAI_TOKEN=xxx
export COMFYUI_ROOT=/workspace/ComfyUI
```

### Troubleshooting Guide
Common issues:
- 403 errors: HuggingFace token required for gated models
- Slow downloads: instance egress limitations
- Missing nodes after installation: ComfyUI restart required
- CUDA version mismatches: check PyTorch version compatibility
- Case-sensitive folder naming: `checkpoints`, `loras`, `vae` (lowercase)

### Developer Best Practices
- Use presets for workflow-specific environments
- Pin versions for team collaboration
- Wrap terminal sessions in `tmux` or `screen` for reliability
- Cache model folders on persistent volumes

Generator URL: https://deploy.promptingpixels.com/
