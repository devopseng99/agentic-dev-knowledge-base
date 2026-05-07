---
title: "LLM Structured Output in 2026: Stop Parsing JSON with Regex and Do It Right"
url: "https://dev.to/pockit_tools/llm-structured-output-in-2026-stop-parsing-json-with-regex-and-do-it-right-34pk"
author: "HK Lee"
category: "llm-structured-output"
---

# LLM Structured Output in 2026: Stop Parsing JSON with Regex and Do It Right

**Author:** HK Lee
**Published:** February 12, 2026

## Overview
Comprehensive guide to structured output across all major LLM providers. LLMs are text generators; your application needs data structures. The gap between these two things is where bugs live.

## Key Concepts

### Three Levels of Output Control
1. **Prompt Engineering** - 80-95% success, no type guarantees
2. **Function Calling/Tool Use** - 95-99% reliable, schema is hint only
3. **Native Structured Output** - 100% schema-valid via constrained decoding (finite state machines)

## Code Examples

### OpenAI (Python)

```python
from openai import OpenAI
from pydantic import BaseModel

class SentimentAnalysis(BaseModel):
    sentiment: str
    confidence: float
    key_phrases: list[str]
    reasoning: str

response = client.beta.chat.completions.parse(
    model="gpt-5-mini",
    messages=[...],
    response_format=SentimentAnalysis,
)
result = response.choices[0].message.parsed
```

### OpenAI (TypeScript)

```typescript
import OpenAI from 'openai';
import { z } from 'zod';
import { zodResponseFormat } from 'openai/helpers/zod';

const SentimentSchema = z.object({
    sentiment: z.enum(['positive', 'negative', 'neutral', 'mixed']),
    confidence: z.number().min(0).max(1),
    entities: z.array(z.object({...})),
    summary: z.string(),
    topics: z.array(z.string()).min(1).max(5),
});

const response = await client.beta.chat.completions.parse({
    model: 'gpt-5-mini',
    messages: [...],
    response_format: zodResponseFormat(SentimentSchema, 'sentiment_analysis'),
});
```

### Anthropic Claude (Python)

```python
import anthropic
from pydantic import BaseModel

class ExtractedData(BaseModel):
    name: str
    email: str
    company: str
    role: str
    urgency: str

response = client.messages.create(
    model="claude-sonnet-4-20260514",
    max_tokens=1024,
    tools=[{
        "name": "extract_contact",
        "description": "Extract contact information from the email.",
        "input_schema": ExtractedData.model_json_schema(),
    }],
    tool_choice={"type": "tool", "name": "extract_contact"},
    messages=[{...}],
)

tool_result = next(
    block for block in response.content
    if block.type == "tool_use"
)
data = ExtractedData(**tool_result.input)
```

### Google Gemini (Python)

```python
import google.generativeai as genai
from pydantic import BaseModel
from enum import Enum

class Priority(str, Enum):
    low = "low"
    medium = "medium"
    high = "high"
    critical = "critical"

class TaskExtraction(BaseModel):
    title: str
    assignee: str
    priority: Priority
    deadline: str | None
    tags: list[str]

model = genai.GenerativeModel(
    "gemini-2.5-flash",
    generation_config=genai.GenerationConfig(
        response_mime_type="application/json",
        response_schema=TaskExtraction,
    ),
)

response = model.generate_content(
    "Extract the task: 'John needs to fix the login bug...'"
)
result = TaskExtraction(**json.loads(response.text))
```

### Validation Sandwich Pattern (Python)

```python
from pydantic import BaseModel, Field, field_validator

class ProductReview(BaseModel):
    rating: int = Field(ge=1, le=5)
    title: str = Field(min_length=1)

    @field_validator('rating')
    @classmethod
    def validate_rating(cls, v):
        if v not in [1, 2, 3, 4, 5]:
            raise ValueError('Rating must be 1-5')
        return v
```
