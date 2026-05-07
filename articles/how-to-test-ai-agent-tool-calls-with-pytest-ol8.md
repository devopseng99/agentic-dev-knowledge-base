---
title: "How to Test AI Agent Tool Calls with Pytest"
url: "https://dev.to/nebulagg/how-to-test-ai-agent-tool-calls-with-pytest-ol8"
author: "The Daily Agent"
category: "ai-agent-unit-testing"
---

# How to Test AI Agent Tool Calls with Pytest

**Author:** The Daily Agent
**Published:** March 13, 2026

## Overview
How to mock the LLM layer and test AI agent tool routing deterministically with pure pytest using just 20 lines of test code. The key: don't test the LLM itself, mock it and test everything around it.

## Key Concepts

### Agent Implementation

```python
import json
from openai import OpenAI

TOOLS = {
    "search_docs": lambda query: f"Results for: {query}",
    "create_ticket": lambda title, priority="medium": f"Ticket created: {title} [{priority}]",
    "send_notification": lambda message, channel: f"Sent to {channel}: {message}",
}

def run_agent(user_message: str, client: OpenAI | None = None) -> str:
    client = client or OpenAI()
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": user_message}],
        tools=TOOL_SCHEMAS,
        tool_choice="auto",
    )
    message = response.choices[0].message
    if not message.tool_calls:
        return message.content or ""
    tool_call = message.tool_calls[0]
    func_name = tool_call.function.name
    func_args = json.loads(tool_call.function.arguments)
    if func_name not in TOOLS:
        return f"Unknown tool: {func_name}"
    return TOOLS[func_name](**func_args)
```

### Test Helpers

```python
def make_tool_call_response(tool_name: str, arguments: dict):
    mock_tool_call = MagicMock()
    mock_tool_call.function.name = tool_name
    mock_tool_call.function.arguments = json.dumps(arguments)
    mock_message = MagicMock()
    mock_message.tool_calls = [mock_tool_call]
    mock_message.content = None
    mock_response = MagicMock()
    mock_response.choices = [MagicMock(message=mock_message)]
    return mock_response
```

### Parametrized Tests

```python
@pytest.mark.parametrize("tool_name, args, expected", [
    ("search_docs", {"query": "API reference"}, "Results for: API reference"),
    ("create_ticket", {"title": "Bug"}, "Ticket created: Bug [medium]"),
    ("create_ticket", {"title": "Outage", "priority": "high"}, "Ticket created: Outage [high]"),
])
def test_agent_tool_routing(tool_name, args, expected):
    mock_client = MagicMock()
    mock_client.chat.completions.create.return_value = make_tool_call_response(tool_name, args)
    result = run_agent("test input", client=mock_client)
    assert result == expected
```

### What Gets Tested vs. What Doesn't
- **Tested:** Tool routing logic, argument parsing, error handling, return value formatting
- **Not Tested:** Whether LLM picks correct tools, prompt quality
- "The deterministic parts belong in unit tests. The non-deterministic parts belong in evals."

Full test suite runs in 0.03s with zero API calls.
