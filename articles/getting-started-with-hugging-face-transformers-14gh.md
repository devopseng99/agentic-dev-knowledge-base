---
title: "Getting Started With Hugging Face Transformers"
url: "https://dev.to/richard_abishai/getting-started-with-hugging-face-transformers-14gh"
author: "Richard Abishai"
category: "huggingface-llm-agents"
---
# Getting Started With Hugging Face Transformers
**Author:** Richard Abishai  **Published:** November 17, 2025

## Overview
This tutorial introduces developers to the Hugging Face Transformers library, focusing on practical implementation of pre-trained language models. The piece emphasizes accessibility of state-of-the-art AI tools and progresses from basic setup through inference to fine-tuning techniques.

## Key Concepts
- Pre-trained model utilization
- Tokenization and model loading
- Inference pipelines
- Task flexibility: sentiment analysis, text generation, question-answering, summarization, translation
- Fine-tuning for domain-specific applications

## Code Examples

### Installation
```bash
pip install transformers torch sentencepiece
```

### Model Loading
```python
from transformers import AutoTokenizer, AutoModelForSequenceClassification

model_name = "distilbert-base-uncased-finetuned-sst-2-english"

tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForSequenceClassification.from_pretrained(model_name)
```

### Sentiment Analysis Pipeline
```python
from transformers import pipeline

nlp = pipeline("sentiment-analysis", model=model, tokenizer=tokenizer)

result = nlp("I love how machines can actually learn!")
print(result)
# Output: [{'label': 'POSITIVE', 'score': 0.9997}]
```

### Text Generation
```python
from transformers import pipeline

gen = pipeline("text-generation", model="gpt2")
print(gen("Artificial intelligence is", max_length=30, num_return_sequences=1))
```

### Fine-Tuning Configuration
```python
from transformers import Trainer, TrainingArguments

training_args = TrainingArguments(
    output_dir="./results",
    evaluation_strategy="epoch",
    learning_rate=2e-5,
    per_device_train_batch_size=8,
    num_train_epochs=3,
    weight_decay=0.01
)
```
