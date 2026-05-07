---
title: "How to Fine-Tune Models with PEFT"
url: "https://dev.to/thenomadevel/how-to-fine-tune-models-easily-with-peft-2pn7"
author: "Nomadev"
category: "huggingface-llm-agents"
---
# How to Fine-Tune Models with PEFT
**Author:** Nomadev  **Published:** January 11, 2025

## Overview
This tutorial provides practical guidance on using Parameter-Efficient Fine-Tuning (PEFT) with Low-Rank Adaptation (LoRA) to customize large language models. The author emphasizes that fine-tuning enables model adaptation for specific tasks without requiring extensive computational resources or modifying all model parameters. Uses SmolLM2-135M as the target model.

## Key Concepts
- PEFT — a clever method for adapting large models without touching all their parameters
- LoRA Mechanism — uses two small matrices (A and B) for task-specific updates
- Primary Advantage — reduces memory requirements while maintaining model effectiveness
- Target Use Cases — domain-specific chatbots, specialized tasks, resource-constrained environments

## Code Examples

### Install Dependencies
```bash
%pip install transformers datasets trl huggingface_hub
```

### Authentication
```python
from huggingface_hub import login
login()  # Enter your Hugging Face token when prompted
```

### Load Dataset
```python
from datasets import load_dataset
dataset = load_dataset(path="HuggingFaceTB/smoltalk",
                       name="everyday-conversations")
print(dataset["train"][0])
```

### Load Model and Tokenizer
```python
from transformers import AutoModelForCausalLM, AutoTokenizer
model_name = "HuggingFaceTB/SmolLM2-135M"
model = AutoModelForCausalLM.from_pretrained(model_name).to("cuda")
tokenizer = AutoTokenizer.from_pretrained(model_name)
```

### Configure LoRA
```python
from peft import LoraConfig
peft_config = LoraConfig(
    r=6,
    lora_alpha=8,
    lora_dropout=0.05,
    target_modules="all-linear",
    task_type="CAUSAL_LM",
)
```

### Training Configuration
```python
from trl import SFTConfig
args = SFTConfig(
    output_dir="Peft_wgts",
    num_train_epochs=1,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=2,
    gradient_checkpointing=True,
    learning_rate=2e-4,
    bf16=True,
)
```

### Initialize Training
```python
from trl import SFTTrainer
trainer = SFTTrainer(
    model=model,
    args=args,
    train_dataset=dataset["train"],
    peft_config=peft_config,
    tokenizer=tokenizer,
)
trainer.train()
```

### Merge and Save Model
```python
from peft import AutoPeftModelForCausalLM
model = AutoPeftModelForCausalLM.from_pretrained("./Peft_wgts/checkpoint-282")
merged_model = model.merge_and_unload()
merged_model.save_pretrained("./Peft_wgts_merged")
```

### Inference Pipeline
```python
from transformers import pipeline
pipe = pipeline("text-generation", model=merged_model,
                tokenizer=tokenizer, device=0)

prompts = [
    "What is the capital of Germany?",
    "Write a Python function to calculate factorial.",
]
for prompt in prompts:
    print(pipe(prompt))
```

### Push to Hub
```python
trainer.push_to_hub(repo_name="SmolLM-FineTuned",
                    tags=["peft", "tutorial"])
```
