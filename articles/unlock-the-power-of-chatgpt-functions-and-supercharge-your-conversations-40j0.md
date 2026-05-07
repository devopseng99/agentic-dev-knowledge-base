---
title: "Unlock the Power of ChatGPT Functions and Supercharge Your Conversations!"
url: "https://dev.to/lucgagan/unlock-the-power-of-chatgpt-functions-and-supercharge-your-conversations-40j0"
author: "Luc Gagan"
category: "function-calling-gpt"
---

# Unlock the Power of ChatGPT Functions and Supercharge Your Conversations!

**Author:** Luc Gagan
**Published:** June 26, 2023

## Overview
Introduces OpenAI's function calling feature available in gpt-3.5-turbo-0613 and gpt-4-0613 models. Functions are embedded in system prompts to guide the model toward outputting JSON objects with function arguments. The Chat Completions API doesn't execute the functions itself -- it generates the necessary JSON to facilitate function calls.

## Key Concepts
- Supercharged chatbots with external API interactions
- Natural language conversion to API calls
- Structured data extraction from unstructured text

## Code Examples

### Installation

```javascript
npm install completions
```

### Module Import and Chat Creation

```javascript
import { createChat, CancelledCompletionError } from "completions";

const chat = createChat({
  apiKey: OPENAI_API_KEY,
  model: "gpt-3.5-turbo-0613",
});
```

### Function Definition with Configuration

```javascript
const chat = createChat({
  apiKey: OPENAI_API_KEY,
  model: "gpt-3.5-turbo-0613",
  functions: [
    {
      name: "get_current_weather",
      description: "Get the current weather in a given location",
      parameters: {
        type: "object",
        properties: {
          location: {
            type: "string",
            description: "The city and state, e.g. San Francisco, CA",
          },
          unit: { type: "string", enum: ["celsius", "fahrenheit"] },
        },
        required: ["location"],
      },
      function: async ({ location }) => {
        return {
          location: "Albuquerque",
          temperature: "72",
          unit: "fahrenheit",
          forecast: ["sunny", "windy"],
        };
      },
    },
  ],
  functionCall: "auto",
});
```

### Sending Messages (Auto Function Call)

```javascript
const response = await chat.sendMessage("What is the weather in Albuquerque?");

console.log(response.content);
// Output: "The weather in Albuquerque is 72 degrees Fahrenheit, sunny with a light breeze."
```

### Sending Messages (Specific Function)

```javascript
const response = await chat.sendMessage("What is the weather in Albuquerque?", {
  functionCall: {
    name: "get_current_weather"
  },
});

console.log(response.content);
// Output: "The weather in Albuquerque is 72 degrees fahrenheit, sunny with a light breeze."
```
