---
title: "Amazon Bedrock for Beginners From First Prompt to AI Agent (Full Tutorial)"
url: "https://dev.to/aws/amazon-bedrock-for-beginners-from-first-prompt-to-ai-agent-full-tutorial-12ln"
author: "Morgan Willis"
category: "multi-turn-conversation"
---

# Amazon Bedrock for Beginners: From First Prompt to AI Agent

**Author:** Morgan Willis
**Published:** April 14, 2026

## Overview
Hands-on tutorial introducing Amazon Bedrock's Converse API, multi-turn conversation management, and tool use (function calling). Demonstrates working directly with APIs before adopting higher-level frameworks.

## Key Concepts
- Converse API as the standard interface across all Bedrock models
- Models are stateless: full conversation history must be resent each call
- Tool use lets models request function execution without executing directly
- Temperature controls randomness (0.0 = deterministic)

## Code Examples

### First API Call (Python)

```python
import boto3

def use_converse_api():
    bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-east-1')
    model_id = "us.amazon.nova-lite-v1:0"

    system_prompt = [{"text": "You are a helpful technical assistant."}]

    response = bedrock_runtime.converse(
        modelId=model_id,
        system=system_prompt,
        messages=[{"role": "user", "content": [{"text": "What is serverless computing?"}]}],
        inferenceConfig={"temperature": 0.7, "maxTokens": 2000}
    )

    print(response['output']['message']['content'][0]['text'])
    usage = response.get('usage', {})
    print(f"Input tokens: {usage.get('inputTokens')}")
    print(f"Output tokens: {usage.get('outputTokens')}")
```

### Multi-Turn Conversation (Python)

```python
def multi_turn_conversation():
    bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-east-1')
    model_id = "us.amazon.nova-lite-v1:0"
    system_prompt = [{"text": "You are a helpful cooking assistant."}]
    conversation_history = []

    # Turn 1
    conversation_history.append({"role": "user", "content": [{"text": "Suggest a quick dinner with chicken."}]})
    response = bedrock_runtime.converse(
        modelId=model_id, system=system_prompt,
        messages=conversation_history,
        inferenceConfig={"temperature": 0.7, "maxTokens": 200}
    )
    msg = response['output']['message']['content'][0]['text']
    conversation_history.append({"role": "assistant", "content": [{"text": msg}]})

    # Turn 2 - references Turn 1
    conversation_history.append({"role": "user", "content": [{"text": "Make it vegetarian instead?"}]})
    response = bedrock_runtime.converse(
        modelId=model_id, system=system_prompt,
        messages=conversation_history,
        inferenceConfig={"temperature": 0.7, "maxTokens": 200}
    )
    print(response['output']['message']['content'][0]['text'])
```

### Tool Use / Function Calling (Python)

```python
import json, boto3

def get_weather(location, unit="fahrenheit"):
    return {"location": location, "temperature": 58 if unit == "fahrenheit" else 14, "condition": "Partly cloudy"}

TOOL_CONFIG = {"tools": [{"toolSpec": {
    "name": "get_weather",
    "description": "Get weather for a location.",
    "inputSchema": {"json": {
        "type": "object",
        "properties": {
            "location": {"type": "string"},
            "unit": {"type": "string", "enum": ["fahrenheit", "celsius"]},
        },
        "required": ["location"],
    }}
}}]}

def tool_use_demo():
    bedrock = boto3.client('bedrock-runtime', region_name='us-east-1')
    messages = [{"role": "user", "content": [{"text": "Weather in Seattle?"}]}]

    response = bedrock.converse(
        modelId="us.amazon.nova-lite-v1:0", messages=messages,
        toolConfig=TOOL_CONFIG, inferenceConfig={"temperature": 0.0, "maxTokens": 300},
    )

    if response["stopReason"] == "tool_use":
        tool_block = next(b["toolUse"] for b in response["output"]["message"]["content"] if "toolUse" in b)
        result = get_weather(**tool_block["input"])

        messages.append(response["output"]["message"])
        messages.append({"role": "user", "content": [
            {"toolResult": {"toolUseId": tool_block["toolUseId"], "content": [{"json": result}]}}
        ]})

        final = bedrock.converse(
            modelId="us.amazon.nova-lite-v1:0", messages=messages,
            toolConfig=TOOL_CONFIG, inferenceConfig={"temperature": 0.0, "maxTokens": 300},
        )
        print(final["output"]["message"]["content"][0]["text"])
```
