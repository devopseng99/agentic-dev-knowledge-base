---
title: "Hugging Face 101: A Tutorial for Absolute Beginners!"
url: "https://dev.to/pavanbelagatti/hugging-face-101-a-tutorial-for-absolute-beginners-3b0l"
author: "Pavan Belagatti"
category: "huggingface-llm-agents"
---
# Hugging Face 101: A Tutorial for Absolute Beginners!
**Author:** Pavan Belagatti  **Published:** September 12, 2023

## Overview
A beginner-friendly guide to sentiment analysis using Hugging Face's transformers library. The tutorial demonstrates how to leverage pre-trained NLP models for text analysis within a SingleStore Notebook environment, walking through installation, model loading, tokenization, inference, and result interpretation.

## Key Concepts
- Hugging Face — community platform (founded 2016) specializing in NLP and AI
- Transformers Library — open-source NLP library supporting BERT, GPT-2, T5 for text classification, QA, translation
- Sentiment Analysis — NLP technique determining emotional tone in text
- Tokenization — converting text into processable units for model input
- Pre-trained Models — machine learning models already trained on large datasets

## Code Examples

### Installation
```bash
!pip install transformers
!pip install torch
```

### Library Imports
```python
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch
```

### Model Loading
```python
tokenizer = AutoTokenizer.from_pretrained("distilbert-base-uncased-finetuned-sst-2-english")
model = AutoModelForSequenceClassification.from_pretrained("distilbert-base-uncased-finetuned-sst-2-english")
```

### Text Preprocessing
```python
text = "I love programming!"
tokens = tokenizer(text, padding=True, truncation=True, return_tensors="pt")
```

### Model Inference
```python
with torch.no_grad():
    outputs = model(**tokens)
    logits = outputs.logits
    probabilities = torch.softmax(logits, dim=1)
```

### Results Interpretation
```python
label_ids = torch.argmax(probabilities, dim=1)
labels = ['Negative', 'Positive']
label = labels[label_ids]
print(f"The sentiment is: {label}")
```
