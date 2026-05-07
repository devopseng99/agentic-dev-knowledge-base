---
title: "Amazon Bedrock for Beginners: From First Prompt to AI Agent (Full Tutorial)"
url: "https://dev.to/aws/amazon-bedrock-for-beginners-from-first-prompt-to-ai-agent-full-tutorial-12ln"
author: "Morgan Willis"
category: "bedrock-agent-aws"
---

# Amazon Bedrock for Beginners: From First Prompt to AI Agent (Full Tutorial)

**Author:** Morgan Willis
**Published:** April 14, 2026

## Overview

Comprehensive tutorial progressing from basic Bedrock API calls to creating agents with tool use. Covers the Converse API, multi-turn conversations, token economics, and the full tool-use workflow.

## Key Concepts

### Basic API Call

```python
import boto3
import json

def use_converse_api():
    bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-east-1')
    model_id = "us.amazon.nova-lite-v1:0"

    system_prompt = [{"text": "You are a helpful technical assistant who explains concepts clearly and concisely."}]
    user_message = "What is serverless computing?"

    response = bedrock_runtime.converse(
        modelId=model_id,
        system=system_prompt,
        messages=[{"role": "user", "content": [{"text": user_message}]}],
        inferenceConfig={"temperature": 0.7, "maxTokens": 2000}
    )

    output_text = response['output']['message']['content'][0]['text']
    print(output_text)

    usage = response.get('usage', {})
    print(f"Input tokens: {usage.get('inputTokens', 'N/A')}")
    print(f"Output tokens: {usage.get('outputTokens', 'N/A')}")
```

### Multi-Turn Conversations

Models are stateless by design. Each API call is independent and the model does not remember previous requests. Conversation history must be explicitly managed.

```python
import boto3

def multi_turn_conversation():
    bedrock_runtime = boto3.client('bedrock-runtime', region_name='us-east-1')
    model_id = "us.amazon.nova-lite-v1:0"
    system_prompt = [{"text": "You are a helpful cooking assistant. Provide concise recipe suggestions."}]
    conversation_history = []

    # Turn 1
    conversation_history.append({"role": "user", "content": [{"text": "Suggest a quick dinner recipe with chicken."}]})
    response_1 = bedrock_runtime.converse(
        modelId=model_id, system=system_prompt, messages=conversation_history,
        inferenceConfig={"temperature": 0.7, "maxTokens": 200}
    )
    assistant_message_1 = response_1['output']['message']['content'][0]['text']
    conversation_history.append({"role": "assistant", "content": [{"text": assistant_message_1}]})

    # Turn 2
    conversation_history.append({"role": "user", "content": [{"text": "Can you make it vegetarian instead?"}]})
    response_2 = bedrock_runtime.converse(
        modelId=model_id, system=system_prompt, messages=conversation_history,
        inferenceConfig={"temperature": 0.7, "maxTokens": 200}
    )
```

### Tool Use (Function Calling)

```python
import json
import boto3

def get_weather(location, unit="fahrenheit"):
    weather_data = {
        "location": location,
        "temperature": 58 if unit == "fahrenheit" else 14,
        "unit": unit,
        "condition": "Partly cloudy",
        "humidity": "72%",
        "wind": "8 mph NW",
    }
    return weather_data

TOOL_CONFIG = {
    "tools": [{
        "toolSpec": {
            "name": "get_weather",
            "description": "Get the current weather for a given location.",
            "inputSchema": {
                "json": {
                    "type": "object",
                    "properties": {
                        "location": {"type": "string", "description": "The city and state, e.g. 'San Francisco, CA'"},
                        "unit": {"type": "string", "enum": ["fahrenheit", "celsius"]}
                    },
                    "required": ["location"]
                }
            }
        }
    }]
}

TOOL_FUNCTIONS = {"get_weather": get_weather}

def run_tool(tool_name, tool_input):
    func = TOOL_FUNCTIONS.get(tool_name)
    if func is None:
        return {"error": f"Unknown tool: {tool_name}"}
    return func(**tool_input)

def tool_use_demo():
    bedrock = boto3.client('bedrock-runtime', region_name='us-east-1')
    model_id = "us.amazon.nova-lite-v1:0"
    messages = [{"role": "user", "content": [{"text": "What's the weather like in Seattle right now?"}]}]

    response = bedrock.converse(
        modelId=model_id, messages=messages, toolConfig=TOOL_CONFIG,
        inferenceConfig={"temperature": 0.0, "maxTokens": 300}
    )

    stop_reason = response["stopReason"]
    assistant_message = response["output"]["message"]

    if stop_reason == "tool_use":
        tool_use_block = None
        for block in assistant_message["content"]:
            if "toolUse" in block:
                tool_use_block = block["toolUse"]
                break

        result = run_tool(tool_use_block["name"], tool_use_block["input"])

        messages.append(assistant_message)
        messages.append({
            "role": "user",
            "content": [{"toolResult": {"toolUseId": tool_use_block["toolUseId"], "content": [{"json": result}]}}]
        })

        final_response = bedrock.converse(
            modelId=model_id, messages=messages, toolConfig=TOOL_CONFIG,
            inferenceConfig={"temperature": 0.0, "maxTokens": 300}
        )
        print(final_response["output"]["message"]["content"][0]["text"])
```

### Cost Estimate

Approximately $3.00 per month for 1,000 queries, with most services within AWS free tiers.
