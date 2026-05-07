---
title: "How to run any LLM model with Hugging-Face"
url: "https://dev.to/rswijesena/how-to-run-any-llm-model-with-hugging-face-4hg3"
author: "Roshan Sanjeewa Wijesena"
category: "huggingface-llm-agents"
---
# How to run any LLM model with Hugging-Face
**Author:** Roshan Sanjeewa Wijesena  **Published:** May 17, 2024

## Overview
This tutorial demonstrates how to leverage Hugging Face's repository of large language models. The guide walks developers through installing required libraries, obtaining API credentials, and executing a practical example using Google's FLAN-T5-Large model for text-to-text generation tasks via LangChain integration.

## Key Concepts
- Hugging Face Hub — centralized repository hosting thousands of open-source LLM models
- Model Selection — using pre-trained models like google/flan-t5-large
- LangChain Integration — chaining prompts with models for structured interactions
- API Authentication — token-based access management
- Temperature and Max Length Parameters — tuning model output behavior

## Code Examples

### Installation
```bash
!pip install huggingface_hub
!pip install transformers
!pip install accelerate
!pip install bitsandbytes
!pip install langchain
```

### Implementation
```python
from langchain import PromptTemplate, HuggingFaceHub, LLMChain
import os

os.environ["HUGGINGFACEHUB_API_TOKEN"] = "<HUGGINGFACEKEY>"

prompt = PromptTemplate(
    input_variables=["product"],
    template="What is the good name for a company that makes {product}",
)

chain = LLMChain(
    prompt=prompt,
    llm=HuggingFaceHub(
        repo_id="google/flan-t5-large",
        model_kwargs={"temperature": 0.1, "max_length": 64}
    )
)

chain.run("fruits")
```
