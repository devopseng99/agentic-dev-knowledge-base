---
title: "Formatting LLM Responses: From Unstructured Text to Structured Outputs"
url: "https://dev.to/sreeni5018/formatting-llm-responses-from-unstructured-text-to-structured-outputs-3n85"
author: "Seenivasa Ramadurai"
category: "llm-structured-output"
---

# Formatting LLM Responses: From Unstructured Text to Structured Outputs

**Author:** Seenivasa Ramadurai
**Published:** January 10, 2025

## Overview
Demonstrates converting plain-text LLM outputs into structured formats using Pydantic with LangChain. Using Pydantic with LangChain simplifies the journey from unstructured text to structured data.

## Code Examples

### Pydantic with LangChain (Python)

```python
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv, find_dotenv
from pydantic import BaseModel

class GetUserDetails(BaseModel):
    '''Extract user contact details.'''
    name: str
    age: int
    address: str
    cars: list
    degree: str
    country_from: str

load_dotenv()
llm = ChatOpenAI(model="gpt-3.5-turbo-0125", temperature=0)
structured_llm = llm.with_structured_output(GetUserDetails)

response = structured_llm.invoke(
    "My Name is Sreeni, I live in Dallas, TX..."
)

print(response.model_dump())
```

Key applications include database automation and frontend application integration.
