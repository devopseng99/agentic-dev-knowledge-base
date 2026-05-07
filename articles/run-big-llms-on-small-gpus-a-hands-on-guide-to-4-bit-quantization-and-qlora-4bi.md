---
title: "Run Big LLMs on Small GPUs: A Hands-On Guide to 4-bit Quantization and QLoRA"
url: "https://dev.to/aairom/run-big-llms-on-small-gpus-a-hands-on-guide-to-4-bit-quantization-and-qlora-4bi"
author: "Alain Airom"
category: "huggingface-llm-agents"
---
# Run Big LLMs on Small GPUs: A Hands-On Guide to 4-bit Quantization and QLoRA
**Author:** Alain Airom  **Published:** November 27, 2025

## Overview
This comprehensive guide demonstrates how to efficiently run large language models on consumer-grade hardware through 4-bit quantization and QLoRA (Quantized Low-Rank Adaptation) techniques. 4-bit quantization reduces the model's size by up to 75% compared to 16-bit precision, enabling deployment on modest hardware while minimizing computational overhead.

## Key Concepts
- 4-bit Quantization — reduces VRAM from ~14 GB to ~3.5 GB for 7B parameter models
- NF4 Format — maps high-precision weights to 16 distinct values using scaling factors
- QLoRA — freezes base model weights in 4-bit NF4 format; adds small trainable adapter matrices in BF16
- Achieves "99% of the performance of full fine-tuning" on single consumer GPUs
- Memory efficiency: base model ~3.5 GB + adapter weights ~50-150 MB

## Code Examples

### BitsAndBytesConfig for 4-bit Quantization
```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig

model_id = "meta-llama/Llama-2-7b-chat-hf"

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
    bnb_4bit_compute_dtype=torch.bfloat16,
)
```

### Model Loading with Quantization
```python
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    quantization_config=bnb_config,
    device_map="auto",
    torch_dtype=torch.bfloat16,
    trust_remote_code=True,
)
tokenizer = AutoTokenizer.from_pretrained(model_id)

print(f"Model size: {model.get_memory_footprint() / (1024**3):.2f} GB")
```

### Text Generation Inference
```python
prompt = "Explain the principle of 4-bit quantization in Large Language Models in one simple sentence."

messages = [
    {"role": "system", "content": "You are a concise and expert AI assistant."},
    {"role": "user", "content": prompt}
]

input_ids = tokenizer.apply_chat_template(
    messages,
    return_tensors="pt"
).to(model.device)

output = model.generate(
    input_ids,
    max_new_tokens=150,
    do_sample=True,
    temperature=0.7,
    top_k=50,
    pad_token_id=tokenizer.eos_token_id
)

response = tokenizer.decode(output[0], skip_special_tokens=True)
print(response)
```

### LoRA Configuration for QLoRA Fine-tuning
```python
from peft import LoraConfig, get_peft_model
from trl import SFTTrainer
from datasets import load_dataset

lora_config = LoraConfig(
    r=64,
    lora_alpha=16,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.1,
    bias="none",
    task_type="CAUSAL_LM",
)

model = get_peft_model(model, lora_config)
model.print_trainable_parameters()
```

### Training Arguments
```python
from transformers import TrainingArguments

training_args = TrainingArguments(
    output_dir="./qlora_results",
    num_train_epochs=1,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    optim="paged_adamw_8bit",
    logging_steps=10,
    save_strategy="epoch",
    learning_rate=2e-4,
    fp16=False,
    bf16=True,
)
```

### SFTTrainer Setup
```python
trainer = SFTTrainer(
    model=model,
    train_dataset=dataset,
    peft_config=lora_config,
    dataset_text_field="text",
    max_seq_length=512,
    tokenizer=tokenizer,
    args=training_args,
)

trainer.train()
trainer.model.save_pretrained("./final_qlora_adapters")
```

### Installation
```bash
pip install transformers accelerate bitsandbytes torch
pip install peft trl datasets
```
