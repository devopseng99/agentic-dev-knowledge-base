---
title: "Fine-Tune SLMs in Colab for Free: A 4-Bit Approach with Meta Llama 3.2"
url: "https://dev.to/rishabdugar/fine-tune-slms-in-colab-for-free-a-4-bit-approach-with-meta-llama-32-495o"
author: "Rishab Dugar"
category: "huggingface-llm-agents"
---
# Fine-Tune SLMs in Colab for Free: A 4-Bit Approach with Meta Llama 3.2
**Author:** Rishab Dugar  **Published:** May 11, 2025

## Overview
This guide demonstrates efficient fine-tuning of small language models using Google Colab's free GPU resources. The tutorial focuses on Meta's Llama 3.2 model with 4-bit quantization and the Unsloth optimization framework, enabling practitioners to adapt LLMs for domain-specific tasks without expensive hardware.

## Key Concepts
- Quantization — reducing precision of weights (16-bit → 4-bit) to slash memory use
- LoRA — low-rank adaptation: trainable adapter layers inserted into frozen model architecture
- PEFT — Parameter-Efficient Fine-Tuning methodology
- Unsloth optimization — 2× speedup, 70% VRAM reduction vs. standard training
- SLM vs LLM — SLMs: specialized, fewer parameters, on-device deployment

## Memory Efficiency Metrics
- 7B parameters in FP16: ~28 GB RAM
- Same model in 4-bit: ~7 GB RAM
- Unsloth: 2× speedup, 70% VRAM reduction

## Code Examples

### Model Loading (4-bit Quantization)
```python
from unsloth import FastLanguageModel
import torch

max_seq_length = 2048
dtype = None
load_in_4bit = True
model_name = "unsloth/Llama-3.2-1B-Instruct"

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name=model_name,
    max_seq_length=max_seq_length,
    dtype=dtype,
    load_in_4bit=load_in_4bit,
)
```

### LoRA Configuration
```python
model = FastLanguageModel.get_peft_model(
    model,
    r=16,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "up_proj", "down_proj"],
    lora_alpha=16,
    lora_dropout=0,
    bias="none",
    use_gradient_checkpointing="unsloth",
    random_state=3407,
)
```

### Chat Template Application
```python
from unsloth.chat_templates import get_chat_template, standardize_sharegpt

ds = standardize_sharegpt(ds)

CHAT_TEMPLATE = "llama-3.1"
tokenizer = get_chat_template(tokenizer, chat_template=CHAT_TEMPLATE)

def format_prompts(examples):
    texts = [
        tokenizer.apply_chat_template(
            convo,
            tokenize=False,
            add_generation_prompt=False
        )
        for convo in examples["conversations"]
    ]
    return {"text": texts}

ds = ds.map(format_prompts, batched=True)
```

### SFT Training Configuration
```python
from trl import SFTTrainer
from transformers import TrainingArguments, DataCollatorForSeq2Seq
from unsloth import is_bfloat16_supported

trainer = SFTTrainer(
    model=model,
    tokenizer=tokenizer,
    train_dataset=ds,
    dataset_text_field="text",
    max_seq_length=max_seq_length,
    data_collator=DataCollatorForSeq2Seq(tokenizer=tokenizer),
    args=TrainingArguments(
        per_device_train_batch_size=2,
        gradient_accumulation_steps=4,
        warmup_steps=5,
        num_train_epochs=1,
        max_steps=100,
        learning_rate=2e-4,
        fp16=not is_bfloat16_supported(),
        bf16=is_bfloat16_supported(),
        logging_steps=1,
        optim="adamw_8bit",
        weight_decay=0.01,
        output_dir="outputs",
    ),
)

stats = trainer.train()
```

### Fast Inference Mode
```python
model = FastLanguageModel.for_inference(model)

inputs = tokenizer.apply_chat_template(
    [{"role": "user", "content": "<Your Question Here>"}],
    tokenize=True,
    add_generation_prompt=True,
    return_tensors="pt",
).to("cuda")

outputs = model.generate(input_ids=inputs, max_new_tokens=256)
print(tokenizer.batch_decode(outputs)[0])
```

### Model Persistence
```python
model.save_pretrained("/content/drive/MyDrive/my_llama3_model")
tokenizer.save_pretrained("/content/drive/MyDrive/my_llama3_model")
```
