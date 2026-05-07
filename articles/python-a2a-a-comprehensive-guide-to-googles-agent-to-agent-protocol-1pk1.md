---
title: "Python A2A: A Comprehensive Guide to Google's Agent-to-Agent Protocol"
url: https://dev.to/czmilo/python-a2a-a-comprehensive-guide-to-googles-agent-to-agent-protocol-1pk1
author: cz
category: a2a-protocol
---

# Python A2A: A Comprehensive Guide to Google's Agent-to-Agent Protocol

**Author:** cz
**Published:** April 15, 2025
**Last Modified:** April 22, 2025

---

## Overview

Python A2A implements Google's Agent-to-Agent (A2A) protocol to standardize communication between AI agents. The guide addresses fragmentation in AI services by providing a unified interface for agent communication, eliminating the need for custom translation layers.

## Key Concepts

1. **Message Structure** - Defined formats for text, function calls, and responses
2. **Conversation Threading** - Multi-turn context management
3. **Function Calling** - Standardized function exposure and invocation
4. **Error Handling** - Consistent error formats across agents

## Installation

```bash
pip install python-a2a
pip install "python-a2a[openai]"
pip install "python-a2a[anthropic]"
pip install "python-a2a[all]"
```

## Code Examples

### Basic Echo Agent

```python
from python_a2a import A2AServer, Message, TextContent, MessageRole, run_server

class EchoAgent(A2AServer):
    def handle_message(self, message):
        if message.content.type == "text":
            return Message(
                content=TextContent(text=f"Echo: {message.content.text}"),
                role=MessageRole.AGENT,
                parent_message_id=message.message_id,
                conversation_id=message.conversation_id
            )

if __name__ == "__main__":
    agent = EchoAgent()
    run_server(agent, host="0.0.0.0", port=5000)
```

### Calculator Agent with Function Calling

```python
import math
from python_a2a import (
    A2AServer, Message, TextContent, FunctionCallContent,
    FunctionResponseContent, MessageRole, run_server
)

class CalculatorAgent(A2AServer):
    def handle_message(self, message):
        if message.content.type == "text":
            return Message(
                content=TextContent(text="Calculator agent ready"),
                role=MessageRole.AGENT,
                parent_message_id=message.message_id,
                conversation_id=message.conversation_id
            )
        elif message.content.type == "function_call":
            function_name = message.content.name
            params = {p.name: p.value for p in message.content.parameters}

            if function_name == "calculate":
                operation = params.get("operation", "add")
                a = float(params.get("a", 0))
                b = float(params.get("b", 0))

                if operation == "add":
                    result = a + b
                elif operation == "subtract":
                    result = a - b
                elif operation == "multiply":
                    result = a * b
                elif operation == "divide":
                    if b == 0:
                        raise ValueError("Cannot divide by zero")
                    result = a / b

                return Message(
                    content=FunctionResponseContent(
                        name="calculate",
                        response={"result": result}
                    ),
                    role=MessageRole.AGENT,
                    parent_message_id=message.message_id,
                    conversation_id=message.conversation_id
                )
```

### LLM-Powered Agents

```python
import os
from python_a2a import OpenAIA2AServer, run_server

agent = OpenAIA2AServer(
    api_key=os.environ["OPENAI_API_KEY"],
    model="gpt-4",
    system_prompt="You are a helpful AI assistant."
)

if __name__ == "__main__":
    run_server(agent, host="0.0.0.0", port=5002)
```

```python
import os
from python_a2a import ClaudeA2AServer, run_server

agent = ClaudeA2AServer(
    api_key=os.environ["ANTHROPIC_API_KEY"],
    model="claude-3-opus-20240229",
    system_prompt="You are a helpful AI assistant."
)

if __name__ == "__main__":
    run_server(agent, host="0.0.0.0", port=5003)
```

### Multi-Agent Workflows

```python
from python_a2a import A2AClient, Message, TextContent, MessageRole, Conversation

def research_workflow(query):
    llm_client = A2AClient("http://localhost:5002/a2a")
    search_client = A2AClient("http://localhost:5003/a2a")
    summarize_client = A2AClient("http://localhost:5004/a2a")

    conversation = Conversation()
    conversation.create_text_message(
        text=f"Research question: {query}",
        role=MessageRole.USER
    )

    search_request = Message(
        content=TextContent(
            text=f"Based on: '{query}', generate 3 search queries"
        ),
        role=MessageRole.USER
    )
    search_queries_response = llm_client.send_message(search_request)
    conversation.add_message(search_queries_response)
```

### Conversation Management

```python
from python_a2a import Conversation, MessageRole, A2AClient

conversation = Conversation()

conversation.create_text_message(
    text="What's the weather like today?",
    role=MessageRole.USER
)

weather_agent = A2AClient("http://localhost:5001/a2a")
last_message = conversation.messages[-1]
response = weather_agent.send_message(last_message)

conversation.add_message(response)
```

### Error Handling

```python
from python_a2a import A2AClient, Message, TextContent, MessageRole

client = A2AClient("http://localhost:5001/a2a")

try:
    message = Message(
        content=TextContent(text="Hello"),
        role=MessageRole.USER
    )
    response = client.send_message(message)
except ConnectionError as e:
    print(f"Connection error: {e}")
except TimeoutError as e:
    print(f"Timeout error: {e}")
```

## Key Takeaways

- Python A2A solves agent interoperability by providing "a standardized way for AI agents to talk to each other, regardless of their underlying implementation"
- The protocol eliminates custom translation layers between different AI services
- Supports composition of specialized agents into modular, extensible systems
- Integrations available for OpenAI and Anthropic Claude models
- Standardized function calling enables agent-to-agent capabilities seamlessly
