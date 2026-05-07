---
title: "Level Up Your Chatbots with OpenAI Function Calling"
url: "https://dev.to/stonediggity/level-up-your-chatbots-with-openai-function-calling-1a8b"
author: "Liam Stone"
category: "function-calling-gpt"
---

# Level Up Your Chatbots with OpenAI Function Calling

**Author:** Liam Stone
**Published:** July 10, 2023

## Overview
Demonstrates practical application of OpenAI's function calling feature through a travel booking chatbot example. Function calling enables endless options for parsing unstructured chat text into structured API calls.

## Key Concepts
Function calling eliminates the need for traditional forms and rigid decision trees, allowing chatbots to dynamically convert unstructured chat into structured data suitable for API calls.

## Code Examples

### Function Definition (JavaScript/Node.js)

```javascript
const functions = [
  {
    name: 'book_travel',
    description: 'Book travel',
    parameters: {
      type: 'object',
      properties: {
        destination: {type: 'string', description: 'Your travel destination.'},
        departure: {type: 'string', description: 'From where are you traveling'},
        number_people: {type: 'string', description: 'How many people are traveling'},
        travel_mode: {type: 'string', description: 'What mode of travel will it be.'}
      }
    }
  }
];
```

### API Response Example (JSON)

```json
{
  "id": "chatcmpl-7R3vsPC6JndweAQZXvCIvSWnaXDMP",
  "object": "chat.completion",
  "created": 1686684328,
  "model": "gpt-3.5-turbo-0613",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "function_call": {
          "name": "book_travel",
          "arguments": "{\n  \"destination\": \"Amsterdam\",\n  \"departure\": \"Bonn\",\n  \"number_people\": \"6\",\n  \"travel_mode\": \"airline\"\n}"
        }
      },
      "finish_reason": "function_call"
    }
  ],
  "usage": {
    "prompt_tokens": 122,
    "completion_tokens": 42,
    "total_tokens": 164
  }
}
```
