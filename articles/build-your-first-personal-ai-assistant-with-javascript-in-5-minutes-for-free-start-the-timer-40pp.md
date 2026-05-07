---
title: "Build Your First Personal AI Assistant with JavaScript in 5 Minutes"
url: "https://dev.to/thestriver/build-your-first-personal-ai-assistant-with-javascript-in-5-minutes-for-free-start-the-timer-40pp"
author: "Dean"
category: "ai-assistant-api"
---

# Build Your First Personal AI Assistant with JavaScript in 5 Minutes

**Author:** Dean
**Published:** June 17, 2025

## Overview
Shows how JavaScript developers can build AI-powered applications using OpenAI SDK and OpenRouter as a free alternative API gateway.

## Code Examples

### OpenAI API with Search (JavaScript)

```javascript
import OpenAI from "openai";
const client = new OpenAI();

const completion = await client.chat.completions.create({
    model: "gpt-4o-search-preview",
    web_search_options: {},
    messages: [{
        "role": "user",
        "content": "Give me a quick summary of a trending good news story"
    }],
});

console.log(completion.choices[0].message.content);
```

### OpenRouter Free Models (JavaScript)

```javascript
import OpenAI from 'openai';

const openai = new OpenAI({
  baseURL: "https://openrouter.ai/api/v1",
  apiKey: "<OPENROUTER_API_KEY>"
});

async function main() {
  const completion = await openai.chat.completions.create({
    model: "meta-llama/llama-4-maverick:free",
    messages: [
      {
        role: "user",
        content: "Give me a quick summary of a trending good news story"
      }
    ],
  });

  console.log(completion.choices[0].message.content);
}

main();
```

OpenRouter is a unified API gateway that enables free access to hundreds of AI models with OpenAI-compatible SDKs.
