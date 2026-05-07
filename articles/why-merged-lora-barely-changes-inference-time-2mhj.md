---
title: "Why Merged LoRA Barely Changes Inference Time"
url: "https://dev.to/natnael_alemseged/why-merged-lora-barely-changes-inference-time-2mhj"
author: "Natnael Alemseged"
category: "llm-research-evals"
---
# Why Merged LoRA Barely Changes Inference Time
**Author:** Natnael Alemseged  **Published:** May 5, 2026

## Overview
Technical explanation of why merging LoRA adapters into base model weights produces negligible inference latency changes, debunking the claim that merged LoRA is "mathematically free" and identifying what actually drives inference speedups.

## Key Concepts

### The Merge Operation
Unmerged: `y = W₀x + (α/r)BAx` (base weights plus separate adapter computation)
Merged: `W_merged = W₀ + (α/r)BA`, then `y = W_merged x`

The adapter computation folds into weights before inference runs, eliminating the separate forward pass through B and A matrices.

### Why Latency Stays Similar After Merge
The bottleneck during token generation (decode phase) is **memory bandwidth**, not computation. Since merged and base models have identical tensor shapes and dtypes, they require moving approximately the same amount of weight data through GPU memory per token.

### Benchmark Results (Colab T4)

| Condition | Latency |
|-----------|---------|
| Base model | 27.1 ms |
| Merged LoRA | 26.5 ms |
| Unmerged LoRA | 58.3 ms |

Merged LoRA (26.5ms) is within noise of the base model (27.1ms). Unmerged LoRA is 2.15x slower due to the active adapter computation path.

### Code: Loading Three Conditions

```python
from transformers import AutoModelForCausalLM
from peft import PeftModel
import torch

BASE_MODEL = "meta-llama/Llama-2-7b-hf"
ADAPTER_PATH = "./lora-adapter"

def load_base():
    return AutoModelForCausalLM.from_pretrained(
        BASE_MODEL, torch_dtype=torch.float16
    ).to("cuda")

def load_merged():
    m = PeftModel.from_pretrained(load_base(), ADAPTER_PATH)
    return m.merge_and_unload()  # Folds adapter into base weights

def load_unmerged():
    return PeftModel.from_pretrained(load_base(), ADAPTER_PATH)
```

### What Actually Drives Inference Speedups
1. **Quantization** — Reduces memory bandwidth per token (INT4 is 4x less data moved than FP16)
2. **Batching** — Improves GPU compute utilization
3. **Speculative decoding** — Reduces decode steps through draft-verify
4. **Smaller models** — Less data movement per token

### The Corrected Claim
"Merged LoRA does not materially change the inference graph or memory footprint per token" — not "merged LoRA is computationally free." The savings come from eliminating the unmerged adapter overhead, not from reducing base model inference cost.
