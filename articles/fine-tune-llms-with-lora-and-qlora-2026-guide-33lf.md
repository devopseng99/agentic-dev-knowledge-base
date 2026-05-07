---
title: "Fine-Tune LLMs with LoRA and QLoRA: 2026 Guide"
url: "https://dev.to/jangwook_kim_e31e7291ad98/fine-tune-llms-with-lora-and-qlora-2026-guide-33lf"
author: "Jangwook Kim"
category: "llm-fine-tuning-agent"
---

# Fine-Tune LLMs with LoRA and QLoRA: 2026 Guide

**Author:** Jangwook Kim
**Published:** April 17, 2026

## Overview

A comprehensive guide to LoRA and QLoRA fine-tuning techniques, covering hardware requirements, dataset preparation, toolchain comparison (Unsloth, Axolotl, LlamaFactory, TRL), hyperparameter tuning, evaluation, and common mistakes.

## Key Concepts

### How LoRA Works

Decomposes weight updates into low-rank matrices: `W = W0 + (alpha/r) x B x A`

Result: training fewer than 0.6% of parameters while recovering 90-95% of full fine-tuning quality.

### QLoRA

Adds 4-bit quantization using NF4 format, reducing 7B model from ~14 GB to 5-6 GB. Achieves 80-90% of full fine-tuning performance.

### Hardware Requirements

| Model Size | Full FT | LoRA (16-bit) | QLoRA (4-bit) | Consumer GPU |
|---|---|---|---|---|
| 7B-8B | ~112 GB | ~16 GB | ~8 GB | RTX 4070 Ti 12GB |
| 13B | ~200 GB | ~28 GB | ~14 GB | RTX 4090 24GB |
| 70B | ~1 TB+ | ~140 GB | ~46 GB | A100 80GB |

### Dataset Format (ChatML JSONL)

```json
{"messages": [
  {"role": "system", "content": "You are a precise SQL query generator."},
  {"role": "user", "content": "Get all users who signed up last month."},
  {"role": "assistant", "content": "SELECT * FROM users WHERE created_at >= DATE_TRUNC('month', NOW() - INTERVAL '1 month') AND created_at < DATE_TRUNC('month', NOW());"}
]}
```

"Quality beats quantity. 200 hand-curated examples typically outperform 2,000 scraped and noisy ones."

### Unsloth -- Speed Focus

```python
from unsloth import FastLanguageModel
import torch

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Meta-Llama-3.1-8B-Instruct",
    max_seq_length=2048,
    dtype=None,
    load_in_4bit=True,
)

model = FastLanguageModel.get_peft_model(
    model,
    r=16,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj",
                    "gate_proj", "up_proj", "down_proj"],
    lora_alpha=16,
    lora_dropout=0,
    bias="none",
    use_gradient_checkpointing="unsloth",
    random_state=42,
)
```

### Axolotl -- YAML-First

```yaml
base_model: meta-llama/Llama-3.1-8B-Instruct
model_type: LlamaForCausalLM
tokenizer_type: AutoTokenizer
load_in_4bit: true
adapter: lora
lora_r: 16
lora_alpha: 16
lora_dropout: 0.05
lora_target_modules:
  - q_proj
  - v_proj
datasets:
  - path: data/train.jsonl
    type: chat_template
val_set_size: 0.1
sequence_len: 2048
micro_batch_size: 2
num_epochs: 3
learning_rate: 2e-4
output_dir: ./outputs/llama-3-1-8b-lora
```

```bash
axolotl train axolotl_config.yaml
```

### Evaluation with lm-eval

```bash
pip install lm-eval

lm_eval --model hf \
    --model_args pretrained=./outputs/my-fine-tuned-model \
    --tasks mmlu \
    --device cuda:0 \
    --batch_size 4
```

### Common Mistakes

1. Wrong chat template silently breaks adapters
2. Forgetting loss masking -- model learns to predict its own questions
3. Overfitting on small datasets -- use 1-2 epochs on <500 examples
4. Catastrophic forgetting -- monitor MMLU, reduce LR if dropping >2-3 points
5. No random seed -- always set `random_state=42`

### Key Takeaways

- LoRA: 0.1-1% trainable params, 90-95% quality of full FT
- QLoRA: adds 4-bit quantization, ~75% VRAM reduction, 80-90% quality
- Default settings: r=16, alpha=16, all-linear modules, DoRA enabled
- Quality data beats quantity; 500 clean > 5,000 noisy
- Toolchain: Unsloth (speed), Axolotl (YAML), TRL (advanced objectives)

"A $300 GPU, 500 curated examples, and an afternoon are enough to specialize a frontier model on your domain."
