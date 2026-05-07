---
title: "A Beginner's guide to Instructor: Get Structured Outputs From LLMs"
url: "https://dev.to/srujana_maddula_3b6ab05ff/a-beginners-guide-to-instructor-get-structured-outputs-from-llms-3lco"
author: "Srujana Maddula"
category: "llm-structured-output"
---

# A Beginner's guide to Instructor: Get Structured Outputs From LLMs

**Author:** Srujana Maddula
**Published:** April 24, 2026

## Overview
Explains how to use the Instructor library for structured LLM outputs. The model returns unpredictable text -- it might skip fields, add extra text, or change the structure across calls. Instructor solves this with Pydantic-based schema enforcement.

## Code Examples

### Installation

```bash
pip install instructor
pip install "instructor[anthropic]"    # Anthropic
pip install "instructor[google-genai]"    # Google/Gemini
```

### Complete Implementation (Python)

```python
import instructor
from pydantic import BaseModel
from openai import OpenAI
from typing import Literal, Optional
from dotenv import load_dotenv

load_dotenv()

class SupportTicket(BaseModel):
    order_id: Optional[str] = None
    issue_type: Literal["delivery_issue", "technical_issue", "billing_issue", "product_issue", "others"]
    priority: Literal["high", "low", "medium"]
    requested_action: Literal["refund", "support", "replacement", "status_check", "others"]

client = instructor.from_openai(OpenAI())

result = client.chat.completions.create(
    model="gpt-4o-mini",
    response_model=SupportTicket,
    messages=[
        {
            "role": "user",
            "content": "It says my account is disabled. Can you unlock it?",
        }
    ],
)

print(result)
```

### How It Works
Define output as Pydantic model -> derive schema -> include in LLM request -> model generates schema-guided response -> validate and map to model -> retry on validation failure.
