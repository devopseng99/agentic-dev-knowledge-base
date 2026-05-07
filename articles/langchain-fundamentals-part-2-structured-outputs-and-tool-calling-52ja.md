---
title: "LangChain Fundamentals Part 2: Structured Outputs and Tool Calling"
url: "https://dev.to/youngtee100/langchain-fundamentals-part-2-structured-outputs-and-tool-calling-52ja"
author: "Godspower Anthony-Ikpe"
category: "tool calling LLM"
---

# LangChain Fundamentals Part 2: Structured Outputs and Tool Calling

**Author:** Godspower Anthony-Ikpe
**Published:** May 1, 2026

## Overview

Introduces two critical LangChain concepts for production AI applications: structured outputs using Pydantic models, and tool calling enabling LLMs to invoke Python functions at runtime.

## Key Concepts

### Structured Outputs with Pydantic

```python
from langchain_anthropic import ChatAnthropic
from langchain_core.pydantic_v1 import BaseModel, Field
from typing import List

class CodeReview(BaseModel):
    issues: List[str] = Field(description="List of code issues found")
    severity: str = Field(description="low, medium, or high")
    refactored_snippet: str = Field(description="Improved version of the code")

llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")
structured_llm = llm.with_structured_output(CodeReview)

result = structured_llm.invoke("Review this code: for i in range(len(items)): print(items[i])")
print(result.issues)
print(result.severity)
```

Key insight: "The Pydantic field descriptions are not just documentation -- the LLM reads them to understand what each field should contain."

### Tool Calling with @tool Decorator

```python
from langchain_core.tools import tool

@tool
def get_contact(email: str) -> dict:
    """Fetch a CRM contact by email address.

    Use this when the user wants to look up, retrieve, or find
    information about a specific contact using their email.
    """
    return db.query("SELECT * FROM contacts WHERE email = ?", email)

llm = ChatAnthropic(model="claude-3-5-sonnet-20241022")
llm_with_tools = llm.bind_tools([get_contact])

response = llm_with_tools.invoke(
    "Look up admin@example.com and tell me if they've shown interest in the product"
)
print(response)
```

Critical guidance: "Write good docstrings -- they are not optional documentation, they are instructions the model actually reads."

These concepts are foundational for automated pipelines, conversational agents, and multi-step workflows.
