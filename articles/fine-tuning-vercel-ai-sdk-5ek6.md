---
title: "Fine-Tuning Vercel AI SDK"
url: "https://dev.to/bealecs/fine-tuning-vercel-ai-sdk-5ek6"
author: "Clifton Beale"
category: "agent-sdks"
---

# Fine-Tuning Vercel AI SDK
**Author:** Clifton Beale
**Published:** September 27, 2023

## Overview
Practical guide on integrating user preferences into a Vercel AI SDK chatbot for a meal planning app, demonstrating how to pass additional context through the useChat hook body parameter.

## Key Concepts

### Sending Preferences via useChat
```javascript
if (session && preferences.length > 0) {
  // Send preferences with chat message
}
```

### Server-Side Destructuring
```javascript
const { messages, preferences } = await req.json();
```

### System Prompt Customization
```javascript
const systemMessage = `Consider user preferences: ${preferences.join(', ')}`;
```
