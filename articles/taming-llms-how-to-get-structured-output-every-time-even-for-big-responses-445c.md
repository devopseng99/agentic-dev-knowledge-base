---
title: "Taming LLMs: How to Get Structured Output Every Time (Even for Big Responses)"
url: "https://dev.to/shrsv/taming-llms-how-to-get-structured-output-every-time-even-for-big-responses-445c"
author: "Shrijith Venkatramana"
category: "llm-structured-output"
---

# Taming LLMs: How to Get Structured Output Every Time (Even for Big Responses)

**Author:** Shrijith Venkatramana
**Published:** July 11, 2025

## Overview
Explores using Outlines, a Python library that guarantees structured LLM outputs through constrained decoding and Finite State Machines (FSMs). Outlines modifies the model's probability distribution, setting invalid tokens to zero probability.

## Code Examples

### JSON Schema with Pydantic (Python)

```python
import outlines
from transformers import AutoTokenizer, AutoModelForCausalLM
from pydantic import BaseModel

class Product(BaseModel):
    name: str
    price: float
    in_stock: bool

MODEL_NAME = "microsoft/Phi-3-mini-4k-instruct"
model = outlines.from_transformers(
    AutoModelForCausalLM.from_pretrained(MODEL_NAME, device_map="auto"),
    AutoTokenizer.from_pretrained(MODEL_NAME)
)

prompt = "Extract product details: 'Laptop, $999.99, available now'"
result = model(prompt, Product)
```

### Customer Support Ticket Parsing (Python)

```python
from typing import Literal

class SupportTicket(BaseModel):
    priority: Literal["Low", "Medium", "High"]
    category: str
    description: str

prompt = "Urgent: App crashes when I click 'Submit'. It's a payment issue."
ticket = model(prompt, SupportTicket)
```

### Regex-Based Extraction (Python)

```python
phone_regex = r"\(\d{3}\)\s\d{3}-\d{4}"
prompt = "Contact: (123) 456-7890"
phone = model(prompt, phone_regex)
```

### OpenAI Integration (Python)

```python
import outlines
from outlines.models import OpenAI
from typing import Literal

model = OpenAI(api_key="your-api-key", model_name="gpt-3.5-turbo")
sentiment = model("This movie was amazing!", Literal["Positive", "Negative", "Neutral"])
```
