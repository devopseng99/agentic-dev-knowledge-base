---
title: "5 NLP tasks using Hugging Face pipeline"
url: "https://dev.to/amananandrai/5-nlp-tasks-using-hugging-face-pipeline-5b98"
author: "amananandrai"
category: "huggingface-llm-agents"
---
# 5 NLP tasks using Hugging Face pipeline
**Author:** amananandrai  **Published:** October 22, 2020

## Overview
This tutorial demonstrates how to leverage Hugging Face's transformer-based NLP library to accomplish five fundamental natural language processing tasks. The article emphasizes the accessibility of these powerful models through simple pipeline implementations, making advanced NLP capabilities available to developers without deep machine learning expertise.

## Key Concepts
- Hugging Face Transformers — community-driven repository with 30k+ GitHub stars offering pre-trained language models
- Pipeline Pattern — simplified abstraction layer for complex NLP tasks
- Transfer Learning — leveraging pre-trained models rather than building from scratch
- SQuAD Dataset — benchmark dataset used for question-answering task evaluation

## Code Examples

### 1. Sentiment Analysis
```python
from transformers import pipeline

nlp = pipeline("sentiment-analysis")
result = nlp("I love trekking and yoga.")[0]
print(f"label: {result['label']}, with score: {round(result['score'], 4)}")
```

### 2. Question Answering
```python
nlp = pipeline("question-answering")
context = r"""The property of being prime (or not) is called primality..."""
result = nlp(question="What is a simple method to verify primality?", context=context)
print(f"Answer: '{result['answer']}'")
```

### 3. Text Generation
```python
text_generator = pipeline("text-generation")
text = text_generator("A person must always work hard and",
                     max_length=50, do_sample=False)[0]
print(text['generated_text'])
```

### 4. Summarization
```python
summarizer = pipeline("summarization")
ARTICLE = """The Apollo program..."""
summary = summarizer(ARTICLE, max_length=130, min_length=30, do_sample=False)[0]
print(summary['summary_text'])
```

### 5. Translation
```python
translator = pipeline("translation_en_to_de")
print(translator("A great obstacle to happiness is to expect too much happiness.",
                max_length=40)[0]['translation_text'])
```
