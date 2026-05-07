---
title: "What LoRA Actually Adapts and Why Higher Rank Doesn't Always Buy What It Looks Like It Should"
url: "https://dev.to/eyorata/-what-lora-actually-adapts-and-why-higher-rank-doesnt-always-buy-what-it-looks-like-it-should-4bfp"
author: "Eyoel Nebiyu"
category: "llm-research-evals"
---
# What LoRA Actually Adapts and Why Higher Rank Doesn't Always Buy What It Looks Like It Should
**Author:** Eyoel Nebiyu  **Published:** May 7, 2026

## Overview
Deep dive into LoRA (Low-Rank Adaptation) mechanics, explaining why the intrinsic-rank hypothesis means higher rank allocations don't linearly improve results — and how to choose rank correctly.

## Key Concepts

### LoRA Mechanism
LoRA freezes base transformer weights and adds trainable corrections through low-rank decomposition:

```
W_adapted = W₀ + (α/r) · B · A
```

Where:
- `W₀` — frozen pretrained weights (d × d)
- `B` — trainable matrix (d × r)
- `A` — trainable matrix (r × d)
- `α/r` — scaling factor controlling effective learning rate per direction

### The Intrinsic-Rank Hypothesis
Task-specific weight updates occupy a low-dimensional subspace. The pretrained model already encodes general syntactic, lexical, and semantic structure. Fine-tuning needs only to shift a small parameter subspace.

### Why Higher Rank Doesn't Help

Empirical demonstration via SVD spectra across rank allocations:

```
r=2:  rel_err=0.5758  | 37.828  33.113  0.000  0.000...
r=4:  rel_err=0.0097  | 37.828  33.113  25.829  24.209...
r=16: rel_err=0.0069  | 37.828  33.113  25.829  24.209  0.145...
```

When allocated rank exceeds task intrinsic rank, excess parameters collapse toward zero — they don't contribute to adaptation.

### Rank Acts as Capacity Ceiling
Rank sets the maximum number of directions that can be adapted, not the quality of adaptation. If a task only needs 4 directions of adaptation, r=16 allocates 12 wasted parameters.

### The Alpha-Rank Relationship
The scaling factor `α/r` controls the effective learning rate per direction. Keeping this ratio constant prevents destabilization when raising rank — otherwise increasing rank without adjusting alpha destabilizes training.

```python
from transformers import AutoModelForCausalLM
from peft import LoraConfig, get_peft_model

# Keep alpha/rank ratio constant when changing rank
config_r4 = LoraConfig(r=4, lora_alpha=8)   # ratio = 2
config_r8 = LoraConfig(r=8, lora_alpha=16)  # ratio = 2 (stable)
config_r8_bad = LoraConfig(r=8, lora_alpha=8)  # ratio = 1 (destabilized)
```

### Practical Guidance
1. Start with r=4; measure task-specific singular value spectrum
2. Increase rank only if spectrum shows more than r significant directions
3. Always scale alpha proportionally with rank
4. For most standard fine-tuning tasks, r=4 to r=8 is optimal
