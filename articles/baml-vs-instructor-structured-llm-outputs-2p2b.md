---
title: "BAML vs Instructor: Structured LLM Outputs"
url: "https://dev.to/rosgluk/baml-vs-instructor-structured-llm-outputs-2p2b"
author: "Rost"
category: "llm-structured-output"
---

# BAML vs Instructor: Structured LLM Outputs

**Author:** Rost
**Published:** December 28, 2025

## Overview
Compares two Python frameworks for obtaining structured, type-safe outputs from LLMs: BAML (domain-specific language with code generation) and Instructor (Pydantic-native with decorators).

## Code Examples

### BAML Approach

```baml
class Person {
  name string
  age int
  occupation string
  skills string[]
}

function ExtractPerson(text: string) -> Person {
  client GPT4
  prompt #"Extract person information..."#
}
```

Generated Python usage:

```python
from baml_client import b
from baml_client.types import Person

result: Person = b.ExtractPerson(text)
```

### Instructor Approach (Python)

```python
from pydantic import BaseModel, Field
from instructor import from_openai
from openai import OpenAI

class Person(BaseModel):
    name: str = Field(description="Full name")
    age: int = Field(ge=0, le=120)
    occupation: str
    skills: list[str]

client = from_openai(OpenAI())
result = client.chat.completions.create(
    model="gpt-4",
    response_model=Person,
    messages=[{"role": "user", "content": f"Extract: {text}"}]
)
```

## Selection Guide
- **Choose BAML for:** Multi-language projects, team collaboration, contract-first development, strong typing
- **Choose Instructor for:** Python-only projects, rapid prototyping, existing Pydantic integration, minimal deployment complexity
