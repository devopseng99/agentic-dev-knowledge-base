---
title: "Using Hugging Face Models in Google Colab: A Beginner's Guide"
url: "https://dev.to/ajmal_hasan/using-hugging-face-models-in-google-colab-a-beginners-35ll"
author: "Ajmal Hasan"
category: "huggingface-llm-agents"
---
# Using Hugging Face Models in Google Colab: A Beginner's Guide
**Author:** Ajmal Hasan  **Published:** November 13, 2024

## Overview
This instructional guide walks beginners through implementing Hugging Face transformer models within Google Colab notebooks. It covers environment setup with GPU acceleration, library installation, model selection from the Hugging Face Hub, and practical implementation of various NLP tasks using the pipeline abstraction.

## Key Concepts
- GPU acceleration setup in Colab for efficient model execution
- Hugging Face `transformers` library and pipeline functionality
- Model discovery and selection via the Hugging Face Hub
- Multiple task types: sentiment analysis, text generation, translation, question-answering

## Code Examples

### Installation
```python
!pip install transformers
!pip install datasets
!pip install tokenizers
```

### GPU Verification
```bash
!nvidia-smi
```

### Sentiment Analysis Pipeline
```python
from transformers import pipeline

classifier = pipeline("sentiment-analysis")
result = classifier("I love using Hugging Face models in Colab!")
print(result)
```

### Explicit Model Specification
```python
classifier = pipeline("sentiment-analysis",
    model="distilbert-base-uncased-finetuned-sst-2-english")
```

### Text Generation
```python
generator = pipeline("text-generation", model="gpt2")
result = generator("Once upon a time,")
print(result)
```

### Translation
```python
translator = pipeline("translation_en_to_fr")
result = translator("I love coding in Python!")
print(result)
```

### Question Answering
```python
question_answerer = pipeline("question-answering")
result = question_answerer({
    "question": "What is the capital of France?",
    "context": "Paris is the capital of France."
})
print(result)
```
