---
title: "Fine-tuning LLMs locally: A step-by-step guide"
url: "https://dev.to/josmel/fine-tuning-llms-locally-a-step-by-step-guide-3p1n"
author: "Josmel Noel"
category: "llm-fine-tuning-agent"
---

# Fine-tuning LLMs locally: A step-by-step guide

**Author:** Josmel Noel
**Published:** April 9, 2025

## Overview

A step-by-step guide for fine-tuning LLMs locally using PyTorch and Hugging Face Transformers, covering data preparation, training loop definition, and execution.

## Key Concepts

### Prerequisites

- Basic Python programming
- NLP familiarity
- PyTorch or TensorFlow
- Hugging Face Transformers library
- Labeled training dataset

### Step 1: Preparing the Data

```python
from transformers import BertTokenizerFast

tokenizer = BertTokenizerFast.from_pretrained('bert-base-uncased')

def preprocess_function(examples):
    return {'input_ids': tokenizer.encode(examples['text'], add_special_tokens=True)}

train_dataset = dataset.map(preprocess_function, batched=True)
```

### Step 2: Defining the Training Loop

```python
import torch
from transformers import BertForSequenceClassification, Trainer, TrainingArguments

model = BertForSequenceClassification.from_pretrained('bert-base-uncased', num_labels=2)

training_args = TrainingArguments(
    output_dir='./results',
    num_train_epochs=3,
    per_device_train_batch_size=16,
    per_device_eval_batch_size=64,
    warmup_steps=500,
    weight_decay=0.01,
    logging_dir='./logs',
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=eval_dataset
)

trainer.train()
```

### Step 3: Running the Training

Execute with: `python train.py`

The training process logs progress and stores checkpoints for later model use.
