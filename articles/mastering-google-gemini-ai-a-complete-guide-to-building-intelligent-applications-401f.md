---
title: "Building Intelligent Applications using Google's Gemini API"
url: "https://dev.to/vipascal99/mastering-google-gemini-ai-a-complete-guide-to-building-intelligent-applications-401f"
author: "Victor Pascal Dike"
category: "gemini-api-agent"
---

# Building Intelligent Applications using Google's Gemini API

**Author:** Victor Pascal Dike
**Published:** October 2, 2025

## Overview
Four essential patterns for building with Gemini AI: basic prompts, file processing (multimodal), tool integration with live web search, and conversation memory.

## Key Concepts

### Setup

```python
pip install google-genai python-dotenv tavily-python
```

### Pattern 1: Basic Prompts

```python
import os
from dotenv import load_dotenv
from google import genai
from google.genai import types

load_dotenv()
client = genai.Client()

response = client.models.generate_content(
    model="models/gemini-2.5-flash",
    contents="Help me create social media content for my brand Markita",
    config=types.GenerateContentConfig(
        system_instruction="You are a helpful assistant that creates social media content"
    )
)
print(response.text)
```

### Pattern 2: File Processing (Multimodal)

```python
uploaded_file = client.files.upload(file="cat.jpg")
response = client.models.generate_content(
    model="models/gemini-2.5-flash",
    contents=["What do you see in this image?", uploaded_file],
    config=types.GenerateContentConfig(
        system_instruction="You are a helpful assistant"
    )
)
print(response.text)
```

### Pattern 3: Tool Integration (Live Web Search via Tavily)

```python
from tavily import TavilyClient
from datetime import date

tavily_client = TavilyClient(api_key=os.environ.get("TAVILY_API_KEY"))

def tavily_search(query: str) -> str:
    """Performs a web search using the Tavily API."""
    try:
        response = tavily_client.search(query=query, search_depth="basic")
        return response['results']
    except Exception as e:
        return f"An error occurred: {e}"

def get_todays_date() -> str:
    """Returns today's date in YYYY-MM-DD format."""
    return date.today().isoformat()

response = client.models.generate_content(
    model="models/gemini-1.5-pro",
    contents="What are Apple's new products?",
    config=types.GenerateContentConfig(
        system_instruction="Use the provided tools to answer questions.",
        tools=[tavily_search, get_todays_date]
    )
)
print(response.text)
```

### Pattern 4: Conversation Memory

```python
history = []

def ask_model(user_input, uploaded_file=None):
    global history

    if uploaded_file:
        history.append(user_input)
        history.append(uploaded_file)
    else:
        history.append(user_input)

    response = client.models.generate_content(
        model="models/gemini-1.5-pro",
        contents=history,
        config=types.GenerateContentConfig(
            system_instruction="You are a helpful assistant that remembers context."
        )
    )

    history.append(response.text)
    return response.text

print(ask_model("Hi, I run a bakery. Can you help me create a marketing plan?"))
print(ask_model("Great. Can you make it specific for Instagram?"))

uploaded_file = client.files.upload(file="bakery_photo.jpg")
print(ask_model("Use this photo to suggest promotional ideas:", uploaded_file))
```
