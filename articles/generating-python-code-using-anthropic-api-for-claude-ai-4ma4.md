---
title: "Generating Python Code Using Anthropic API for Claude AI"
url: https://dev.to/engineerdan/generating-python-code-using-anthropic-api-for-claude-ai-4ma4
author: Dan Humphreys
category: anthropic-claude
---

# Generating Python Code Using Anthropic API for Claude AI

**Author:** Dan Humphreys
**Date Published:** October 21, 2024

## Overview

This article demonstrates how to leverage the Anthropic Claude API to generate, save, and execute Python functions programmatically. The workflow involves prompting Claude to write code, persisting it to a file, and running the generated function.

## Key Concepts

The approach uses three core functions:

1. **Code Generation** - Sends a structured prompt to Claude and retrieves the generated code
2. **File Writing** - Saves the API response as a Python module
3. **Function Execution** - Dynamically imports and runs the generated code

## Code Example

```python
import anthropic

client = anthropic.Anthropic()

def generate_code(prompt):
    return client.messages.create(
        model="claude-3-5-sonnet-20240620",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": prompt}
        ]
    ).content[0].text

def write_function(module_name, code):
    f = open(module_name + ".py", "w")
    f.write(code)
    f.close()

def run_function(module_name, function_name, a, b):
    module = __import__(module_name)
    print(getattr(module, function_name)(a, b))
```

## Practical Example

The article demonstrates generating an `is_even()` function that returns `True` if two integers sum to an even number:

**Generated Code:**
```python
def is_even(num1, num2):
    return (num1 + num2) % 2 == 0
```

**Output:**
```
False
True
```

## Setup Requirements

Install the SDK: `pip install anthropic`

Set the `ANTHROPIC_API_KEY` environment variable with your API credentials.

## Key Takeaway

"Generating and running a simple Python function using Anthropic Claude APIs" demonstrates practical AI-assisted development where natural language prompts translate into executable code.
