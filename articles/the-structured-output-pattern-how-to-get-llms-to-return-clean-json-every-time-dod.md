---
title: "The Structured Output Pattern: How to Get LLMs to Return Clean JSON Every Time"
url: "https://dev.to/clawgenesis/the-structured-output-pattern-how-to-get-llms-to-return-clean-json-every-time-dod"
author: "Jamie Cole"
category: "llm-structured-output"
---

# The Structured Output Pattern: How to Get LLMs to Return Clean JSON Every Time

**Author:** Jamie Cole
**Published:** March 23, 2026

## Overview
Addresses the challenge of obtaining reliable JSON output from language models. Naive approaches succeed only approximately 60% of the time. The four-step solution brings success rate to 97%.

## Key Concepts

### The Four-Step Solution

1. **System Prompt Constraint** - Include "respond ONLY with valid JSON"
2. **Few-Shot Example** - Demonstrate desired output format explicitly
3. **JSON Mode Parameter** - OpenAI: `response_format={"type": "json_object"}`; Anthropic: `response_format={"type": "json_schema", ...}`
4. **Validation + Retry Loop**

## Code Examples

### Validation + Retry Loop (Python)

```python
def get_structured(prompt, schema):
    raw = llm_call(prompt)
    try:
        data = json.loads(raw)
        validate(data, schema)
        return data
    except (json.JSONDecodeError, ValidationError):
        return llm_call(prompt, strict=True)
```

### Results
- JSON parse success rate: 60% -> 97%
- Additional response time: ~200ms
- Production incidents from malformed output: eliminated
