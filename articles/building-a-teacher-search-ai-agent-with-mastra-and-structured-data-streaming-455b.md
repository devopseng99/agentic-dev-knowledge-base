---
title: "Building a Teacher Search AI Agent with Mastra and Structured Data Streaming"
url: "https://dev.to/meijin/building-a-teacher-search-ai-agent-with-mastra-and-structured-data-streaming-455b"
author: "meijin"
category: "agent-sdks"
---

# Building a Teacher Search AI Agent with Mastra and Structured Data Streaming
**Author:** meijin
**Published:** June 11, 2025

## Overview
Production case study of building a conversational teacher search AI agent for Manalink tutoring platform using Mastra framework with structured data streaming and cross-platform support.

## Key Concepts

### Partial JSON Streaming
```typescript
if (part.type === 'text') {
  const parsedMessage = parsePartialJson(part.text);
  if (['repaired-parse', 'successful-parse'].includes(parsedMessage.state)) {
    return {
      type: 'output',
      structuredData: parsedMessage.value as PartialSchema,
    };
  }
}
```

### Architecture
- Mastra framework for agent functionality
- Next.js with React Native cross-platform support
- Custom `useStructuredChat` hook extending Vercel AI SDK's `useChat`
- Embedding and RAG for similarity matching on unstructured criteria
- Progressive JSON rendering during streaming

### Lessons Learned
- 2 person-month total effort
- Iterative tool development outperforms upfront design
- Nginx needs `proxy_buffering off` for streaming
- Expo 52 required for React Native streaming support
