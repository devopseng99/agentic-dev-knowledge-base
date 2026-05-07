---
title: "Fine-Tuning LLMs on Your Own Data: A Step-by-Step Guide"
url: "https://dev.to/_85e8844dcca5f98bfa936/fine-tuning-llms-on-your-own-data-a-step-by-step-guide-409j"
author: "Peipei Zheng"
category: "llm-fine-tuning-agent"
---

# Fine-Tuning LLMs on Your Own Data: A Step-by-Step Guide

**Author:** Peipei Zheng
**Published:** March 1, 2026

## Overview

A practical guide covering fine-tuning with both OpenAI's API and Hugging Face locally, including data validation utilities.

## Key Concepts

### When to Fine-Tune vs. Prompt Engineer

Fine-tune when: consistent output formatting needed, few-shot insufficient, want shorter prompts, domain-specific knowledge. Avoid when: RAG suffices, fewer than 50 examples, base model performs adequately.

### Fine-Tuning with OpenAI

```python
import json

training_data = [
    {
        "messages": [
            {"role": "system", "content": "You are a code reviewer giving concise feedback."},
            {"role": "user", "content": "Review: def add(a,b): return a+b"},
            {"role": "assistant", "content": "1. Add type hints: `def add(a: int, b: int) -> int`\n2. Add docstring\n3. Consider input validation"}
        ]
    }
]

with open("training.jsonl", "w") as f:
    for item in training_data:
        f.write(json.dumps(item) + "\n")
```

```python
from openai import OpenAI
client = OpenAI()

file = client.files.create(file=open("training.jsonl", "rb"), purpose="fine-tune")

job = client.fine_tuning.jobs.create(
    training_file=file.id,
    model="gpt-4o-mini-2024-07-18",
    hyperparameters={"n_epochs": 3, "batch_size": 1, "learning_rate_multiplier": 1.8}
)
```

```python
response = client.chat.completions.create(
    model="ft:gpt-4o-mini-2024-07-18:your-org::abc123",
    messages=[
        {"role": "system", "content": "You are a code reviewer."},
        {"role": "user", "content": "Review: passwords = open('passwords.txt').read()"}
    ]
)
```

### Fine-Tuning with Hugging Face (Local with LoRA)

```python
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments
from trl import SFTTrainer
from peft import LoraConfig

model_name = "meta-llama/Llama-2-7b-hf"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name, load_in_4bit=True, device_map="auto")

lora_config = LoraConfig(r=16, lora_alpha=32, target_modules=["q_proj", "v_proj"], lora_dropout=0.05, task_type="CAUSAL_LM")

trainer = SFTTrainer(
    model=model, train_dataset=dataset, peft_config=lora_config,
    args=TrainingArguments(output_dir="./results", num_train_epochs=3, per_device_train_batch_size=4, learning_rate=2e-4),
    tokenizer=tokenizer, dataset_text_field="text", max_seq_length=512,
)
trainer.train()
trainer.save_model("./my-fine-tuned-model")
```

### Data Quality Validation

```python
def validate_training_data(filepath):
    issues = []
    with open(filepath) as f:
        for i, line in enumerate(f):
            try:
                data = json.loads(line)
                msgs = data["messages"]
                if len(msgs) < 2:
                    issues.append(f"Line {i}: Need at least 2 messages")
                if msgs[-1]["role"] != "assistant":
                    issues.append(f"Line {i}: Last message should be assistant")
            except (json.JSONDecodeError, KeyError) as e:
                issues.append(f"Line {i}: {e}")
    return issues
```

### Key Takeaways

1. Start with 50-100 high-quality examples
2. Quality exceeds quantity
3. Use LoRA for efficient local fine-tuning
4. OpenAI fine-tuning suits production environments
5. Always evaluate against a held-out test set
6. Fine-tuning combined with RAG is often optimal
