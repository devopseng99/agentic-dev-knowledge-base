---
title: "Function Calling: Integrate Your GPT Chatbot With Anything"
url: "https://dev.to/semaphore/function-calling-integrate-your-gpt-chatbot-with-anything-3l5d"
author: "Tomas Fernandez"
category: "function-calling-gpt"
---

# Function Calling: Integrate Your GPT Chatbot With Anything

**Author:** Tomas Fernandez
**Published:** August 9, 2023

## Overview
This article explains OpenAI's function calling feature for GPT models through building NewsGPT, a Python chatbot that fetches real-time news. Function calling allows chatbots to interact with external APIs and tools.

## Key Concepts

### What is Function Calling?
Function calling is available in GPT-4-0613 and GPT-3.5 Turbo-0613 models. Before function calling, two methods existed for extending GPT capabilities: fine-tuning (resource-intensive) and embeddings (token-costly). Function calling adds a third approach.

### How It Works
1. Sending user prompts with available functions
2. Model responds with text or function call requests
3. Execute requested functions and return results
4. Model generates coherent text responses

## Code Examples

### Python Imports and Constants

```python
import openai
import tiktoken
import json
import os
import requests

llm_model = "gpt-3.5-turbo-16k"
llm_max_tokens = 15500
llm_system_prompt = "You are an assistant that provides news and headlines to user requests. Always try to get the lastest breaking stories using the available function calls."
encoding_model_messages = "gpt-3.5-turbo-0613"
encoding_model_strings = "cl100k_base"
function_call_limit = 3
```

### Token Counting Function

```python
def num_tokens_from_messages(messages):
    """Returns the number of tokens used by a list of messages."""
    try:
        encoding = tiktoken.encoding_for_model(encoding_model_messages)
    except KeyError:
        encoding = tiktoken.get_encoding(encoding_model_strings)

    num_tokens = 0
    for message in messages:
        num_tokens += 4
        for key, value in message.items():
            num_tokens += len(encoding.encode(str(value)))
            if key == "name":
                num_tokens += -1
        num_tokens += 2
    return num_tokens
```

### NewsAPI Function

```python
def get_top_headlines(query: str = None, country: str = None, category: str = None):
    """Retrieve top headlines from newsapi.org (API key required)"""

    base_url = "https://newsapi.org/v2/top-headlines"
    headers = {
        "x-api-key": os.environ['NEWS_API_KEY']
    }
    params = { "category": "general" }
    if query is not None:
        params['q'] = query
    if country is not None:
        params['country'] = country
    if category is not None:
        params['category'] = category

    response = requests.get(base_url, params=params, headers=headers)
    data = response.json()

    if data['status'] == 'ok':
        print(f"Processing {data['totalResults']} articles from newsapi.org")
        return json.dumps(data['articles'])
    else:
        print("Request failed with message:", data['message'])
        return 'No articles found'
```

### Function Signature Definition

```python
signature_get_top_headlines = {
    "name":"get_top_headlines",
    "description":"Get top news headlines by country and/or category",
    "parameters":{
        "type":"object",
        "properties":{
            "query":{
                "type":"string",
                "description":"Freeform keywords or a phrase to search for."
            },
            "country":{
                "type":"string",
                "description":"The 2-letter ISO 3166-1 code of the country you want to get headlines for"
            },
            "category":{
                "type":"string",
                "description":"The category you want to get headlines for",
                "enum":[
                    "business",
                    "entertainment",
                    "general",
                    "health",
                    "science",
                    "sports",
                    "technology"
                ]
            }
        },
        "required":[]
    }
}
```

### Chat Completion Function

```python
def complete(messages, function_call: str = "auto"):
    """Fetch completion from OpenAI's GPT"""

    messages.append({"role": "system", "content": llm_system_prompt})

    while num_tokens_from_messages(messages) >= llm_max_tokens:
        messages.pop(0)

    print('Working...')
    res = openai.ChatCompletion.create(
        model=llm_model,
        messages=messages,
        functions=[signature_get_top_headlines],
        function_call=function_call
    )

    messages.pop(-1)
    response = res["choices"][0]["message"]
    messages.append(response)

    if response.get("function_call"):
        function_name = response["function_call"]["name"]
        if function_name == "get_top_headlines":
            args = json.loads(response["function_call"]["arguments"])
            headlines = get_top_headlines(
                query=args.get("query"),
                country=args.get("country"),
                category=args.get("category")
            )
            messages.append({ "role": "function", "name": "get_top_headline", "content": headlines})
```

### Main Chatbot Loop

```python
print("\nHi, I'm a NewsGPT, a breaking news AI assistant.")

messages = []
while True:
    prompt = input("\nWhat would you like to know? => ")
    messages.append({"role": "user", "content": prompt})
    complete(messages)

    call_count = 0
    while messages[-1]['role'] == "function":
        call_count = call_count + 1
        if call_count < function_call_limit:
            complete(messages)
        else:
            complete(messages, function_call="none")

    print("\n\n==Response==\n")
    print(messages[-1]["content"].strip())
    print("\n==End of response==")
```

### Environment Setup

```bash
export OPENAI_API_KEY=YOUR_API_KEY
export NEWS_API_KEY=YOUR_API_KEY
```
