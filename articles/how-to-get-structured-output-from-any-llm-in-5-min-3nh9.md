---
title: "How to Get Structured Output from Any LLM in 5 Min"
url: "https://dev.to/nebulagg/how-to-get-structured-output-from-any-llm-in-5-min-3nh9"
author: "The Daily Agent"
category: "llm-structured-output"
---

# How to Get Structured Output from Any LLM in 5 Min

**Author:** The Daily Agent
**Published:** March 22, 2026

## Overview
Promotes PydanticAI's output_type parameter as a solution for enforcing typed, validated JSON responses from any LLM. Structured output is the bridge between 'cool LLM demo' and 'production agent.'

## Code Examples

### Contact Info Extraction (Python)

```python
import asyncio
from pydantic import BaseModel, Field
from pydantic_ai import Agent

class ContactInfo(BaseModel):
    name: str = Field(description="Full name of the person")
    email: str = Field(description="Email address")
    company: str = Field(description="Company or organization")
    role: str = Field(description="Job title or role")

agent = Agent(
    'openai:gpt-4o',
    output_type=ContactInfo,
    instructions='Extract contact information from the provided text.',
)

raw_text = """
Hey, just met Sarah Chen at the DevTools Summit.
She's the VP of Engineering at Acme Corp.
Her email is sarah.chen@acmecorp.io
"""

result = agent.run_sync(raw_text)
print(result.output.name)    # Sarah Chen
print(result.output.email)   # sarah.chen@acmecorp.io
```

### Multiple Output Types with Fallback (Python)

```python
class ExtractionFailed(BaseModel):
    reason: str

agent = Agent(
    'openai:gpt-4o',
    output_type=[ContactInfo, ExtractionFailed],
    instructions='Extract contact info. If the text has no contact details, explain why.',
)

result = agent.run_sync('The weather in Tokyo is sunny today.')
print(result.output)
#> reason='The text contains weather information but no contact details'
```
