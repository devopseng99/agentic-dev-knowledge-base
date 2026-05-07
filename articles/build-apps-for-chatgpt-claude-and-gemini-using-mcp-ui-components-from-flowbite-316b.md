---
title: "Build Apps for ChatGPT, Claude, and Gemini Using MCP UI Components from Flowbite"
url: "https://dev.to/themesberg/build-apps-for-chatgpt-claude-and-gemini-using-mcp-ui-components-from-flowbite-316b"
author: "Zoltan Szogvenyi"
category: "a2a-protocols"
---

# MCP UI Components from Flowbite
**Author:** Zoltan Szogvenyi
**Published:** February 6, 2026

## Overview
Creating MCP applications with Flowbite UI components via Skybridge framework, compatible with ChatGPT, Claude, and Gemini.

## Key Concepts

```javascript
export const basicTextWidget = {
  name: "basic-text",
  toolConfig: {
    description: "Show a text message based on a question.",
    inputSchema: {
      question: z.string().describe("The user's question."),
    },
  },
  handler: async () => {
    return {
      structuredContent: { answer: "Hello, world!" },
      content: [],
      isError: false,
    };
  },
};
```

Clone MCP UI Starter repo, `npm install`, `npm run dev --use-forwarded-host` on port 3000.
