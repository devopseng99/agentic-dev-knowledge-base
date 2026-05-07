---
title: "Anthropic Claude with Tools Using Python SDK"
url: https://dev.to/thomastaylor/anthropic-claude-with-tools-using-python-sdk-2fio
author: Thomas Taylor
category: anthropic-claude
---

# Anthropic Claude with Tools Using Python SDK

**Author:** Thomas Taylor
**Published:** April 21, 2024
**Originally published at:** how.wtf

## Overview

On April 4th, 2024, Anthropic released "official support for tool use through their API." This capability enables developers to define tools with parameters, descriptions, and schemas for Claude to process.

## Key Steps

### 1. Setup
Install the SDK and set your API key:
```bash
export ANTHROPIC_API_KEY="sk-......"
pip install anthropic
```

### 2. Define Tools
Create tool definitions using JSON schema. Example:
```python
tools = [
    {
        "name": "get_current_stock_price",
        "description": "Retrieves the current stock price for a ticker",
        "input_schema": {
            "type": "object",
            "properties": {
                "symbol": {
                    "type": "string",
                    "description": "Stock ticker symbol (e.g., AAPL)"
                }
            },
            "required": ["symbol"]
        }
    }
]
```

### 3. Instantiate Client
```python
import anthropic
client = anthropic.Anthropic()
```

### 4. Invoke Claude with Tools
```python
response = client.beta.tools.messages.create(
    model="claude-3-haiku-20240307",
    max_tokens=1024,
    tools=tools,
    messages=[{"role": "user", "content": "What is Apple's stock price?"}]
)
```

### 5. Process Tool Calls
Implement a router and loop to handle tool use responses:
```python
def process_tool(tool_name: str, input):
    match tool_name:
        case "get_current_stock_price":
            return get_current_stock_price(input["symbol"])
        case _:
            raise ValueError(f"Unknown tool: {tool_name}")
```

### 6. Return Results
Pass tool results back to Claude for final response generation using `tool_result` messages.

## Key Takeaway

The workflow involves: invoke -> extract tool use -> process locally -> return result -> receive final answer. The article provides a complete working example demonstrating this pattern with stock price retrieval.
