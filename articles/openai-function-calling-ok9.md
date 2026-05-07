---
title: "OpenAI Function Calling"
url: https://dev.to/stonediggity/openai-function-calling-ok9
author: Liam Stone
category: function-calling
---

# OpenAI Function Calling

**Author:** Liam Stone
**Published:** July 7, 2023

---

## Overview

Function calling is a feature of GPT-4 and GPT-3.5 Turbo that enables these models to "understand and generate JSON objects for specific function calls based on user queries." The model doesn't execute functions but provides the necessary information for you to call them in your code.

## Why It Matters

This capability unlocks several practical applications:

- Building chatbots that query external APIs (weather services, databases)
- Converting natural language into API calls
- Extracting structured data from unstructured text

## Implementation Process

The workflow involves four key steps:

1. Call the model with user queries and function definitions
2. Check whether the model generates JSON for a function call
3. Parse the JSON and execute your function with those arguments
4. Send the function response back to the model for summarization

## Python Example

```python
import openai
import json

def get_current_weather(location, unit="fahrenheit"):
    weather_info = {
        "location": location,
        "temperature": "72",
        "unit": unit,
        "forecast": ["sunny", "windy"],
    }
    return json.dumps(weather_info)

def run_conversation():
    messages = [{"role": "user", "content": "What's the weather like in Boston?"}]
    functions = [
        {
            "name": "get_current_weather",
            "description": "Get the current weather in a given location",
            "parameters": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "The city and state, e.g. San Francisco, CA",
                    },
                    "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]},
                },
                "required": ["location"],
            },
        }
    ]

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo-0613",
        messages=messages,
        functions=functions,
        function_call="auto",
    )
    response_message = response["choices"][0]["message"]

    if response_message.get("function_call"):
        available_functions = {"get_current_weather": get_current_weather}
        function_name = response_message["function_call"]["name"]
        function_to_call = available_functions[function_name]
        function_args = json.loads(response_message["function_call"]["arguments"])
        function_response = function_to_call(
            location=function_args.get("location"),
            unit=function_args.get("unit"),
        )

        messages.append(response_message)
        messages.append(
            {"role": "function", "name": function_name, "content": function_response}
        )
        second_response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo-0613",
            messages=messages,
        )
        return second_response

print(run_conversation())
```

## Handling Hallucinations

Models may generate calls to functions not provided. Mitigation involves using system messages to "remind the model to only use the functions it has been provided with."

## Key Takeaway

Function calling is "a powerful tool that can help you build more advanced and interactive chatbots or data extraction methods," opening expansive possibilities for AI-driven applications.
