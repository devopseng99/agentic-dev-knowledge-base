---
title: "Vercel AI SDK Complete Guide: Building Production-Ready AI Chat Apps with Next.js"
url: "https://dev.to/pockit_tools/vercel-ai-sdk-complete-guide-building-production-ready-ai-chat-apps-with-nextjs-4cp6"
author: "HK Lee"
category: "ai-sdks"
---

# Vercel AI SDK Complete Guide: Building Production-Ready AI Chat Apps with Next.js

**Author:** HK Lee
**Published:** January 7, 2026
**Last Modified:** January 9, 2026

## Overview

This comprehensive guide covers building AI-powered chat applications using the Vercel AI SDK with Next.js. The guide targets developers who have struggled with "streaming complexity, token management, and state synchronization" when integrating large language models.

> **Version Note:** This guide covers Vercel AI SDK v6.0+ (late 2025 release).

## Why Vercel AI SDK?

### The Streaming Problem

Traditional LLM API calls force users to wait 5-10 seconds for complete responses. Streaming solves this by sending tokens as generated, but implementation in React involves:

- Managing `ReadableStream` from APIs
- Parsing SSE (Server-Sent Events) or newline-delimited JSON
- Updating React state without re-render waterfalls
- Handling abort signals for cancellation
- Managing loading, error, and completion states
- Synchronizing client and server state

The Vercel AI SDK abstracts these complexities into simple, declarative hooks.

### Provider Agnostic Architecture

The SDK provides unified interfaces across providers:

```typescript
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';
import { google } from '@ai-sdk/google';

// Same function signature, different providers
const result = await generateText({
  model: openai('gpt-4-turbo'),
  // or: model: anthropic('claude-3-opus'),
  // or: model: google('gemini-pro'),
  prompt: 'Explain quantum computing',
});
```

Switch providers with a single line change--no refactoring required.

## Core Architecture

### Three Main Packages

**AI SDK Core (`ai`)**
- `generateText()` - Generate text with full result
- `streamText()` - Stream text generation
- `generateObject()` - Generate structured JSON
- `streamObject()` - Stream structured JSON
- `embed()` - Generate embeddings
- `embedMany()` - Batch embeddings

**AI SDK UI (`@ai-sdk/react`)**
- `useChat()` - Full chat interface management
- `useCompletion()` - Single-turn text completion
- `useObject()` - Streaming structured data
- `useAssistant()` - OpenAI Assistants API integration

**Provider Packages**
- `@ai-sdk/openai` - OpenAI, Azure OpenAI
- `@ai-sdk/anthropic` - Claude models
- `@ai-sdk/google` - Gemini models
- `@ai-sdk/mistral` - Mistral AI
- `@ai-sdk/amazon-bedrock` - AWS Bedrock

## Project Setup

### Installation

```bash
npx create-next-app@latest ai-chat-app --typescript --tailwind --app
cd ai-chat-app

# Install AI SDK packages
npm install ai @ai-sdk/openai @ai-sdk/anthropic

# Optional: UI components
npm install @radix-ui/react-scroll-area lucide-react
```

### Environment Configuration

```env
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

### Project Structure

```
src/
├── app/
│   ├── api/
│   │   └── chat/
│   │       └── route.ts
│   ├── page.tsx
│   └── layout.tsx
├── components/
│   ├── chat/
│   │   ├── ChatContainer.tsx
│   │   ├── MessageList.tsx
│   │   ├── MessageBubble.tsx
│   │   └── ChatInput.tsx
│   └── ui/
│       └── Button.tsx
├── lib/
│   ├── ai/
│   │   ├── models.ts
│   │   └── prompts.ts
│   └── utils.ts
└── types/
    └── chat.ts
```

## Server-Side Implementation

### Basic Chat Route

```typescript
// src/app/api/chat/route.ts
import { openai } from '@ai-sdk/openai';
import { streamText } from 'ai';

export const runtime = 'edge';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: openai('gpt-4-turbo'),
    messages,
    system: `You are a helpful AI assistant. Be concise and clear.`,
  });

  return result.toDataStreamResponse();
}
```

### Production-Ready Implementation

```typescript
// src/app/api/chat/route.ts
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';
import { streamText, convertToModelMessages } from 'ai';
import { z } from 'zod';

export const runtime = 'edge';
export const maxDuration = 30;

// Request validation schema
const chatRequestSchema = z.object({
  messages: z.array(z.object({
    role: z.enum(['user', 'assistant', 'system']),
    content: z.string(),
  })),
  model: z.enum(['gpt-4-turbo', 'claude-3-opus']).default('gpt-4-turbo'),
  temperature: z.number().min(0).max(2).default(0.7),
});

// Model registry
const models = {
  'gpt-4-turbo': openai('gpt-4-turbo'),
  'claude-3-opus': anthropic('claude-3-opus-20240229'),
};

const SYSTEM_PROMPT = `You are an expert AI assistant specializing in software development.

Guidelines:
- Provide accurate, well-structured responses
- Include code examples when relevant
- Cite sources when making factual claims
- Admit uncertainty rather than guessing
- Keep responses concise but comprehensive`;

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { messages, model, temperature } = chatRequestSchema.parse(body);

    const clientIP = req.headers.get('x-forwarded-for') || 'unknown';

    const result = streamText({
      model: models[model],
      messages: await convertToModelMessages(messages),
      system: SYSTEM_PROMPT,
      temperature,
      maxTokens: 4096,
      abortSignal: req.signal,
      onFinish: async ({ text, usage }) => {
        console.log(`Completed: ${usage.totalTokens} tokens`);
      },
    });

    return result.toDataStreamResponse();
  } catch (error) {
    if (error instanceof z.ZodError) {
      return new Response(JSON.stringify({
        error: 'Invalid request',
        details: error.errors
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    console.error('Chat API Error:', error);
    return new Response(JSON.stringify({ error: 'Internal server error' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }
}
```

## Client-Side Implementation

### Basic useChat Hook

```typescript
// src/app/page.tsx
'use client';

import { useChat } from '@ai-sdk/react';

export default function ChatPage() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat();

  return (
    <div className="flex flex-col h-screen max-w-2xl mx-auto p-4">
      <div className="flex-1 overflow-y-auto space-y-4">
        {messages.map((message) => (
          <div
            key={message.id}
            className={`p-4 rounded-lg ${
              message.role === 'user'
                ? 'bg-blue-100 ml-auto max-w-[80%]'
                : 'bg-gray-100 mr-auto max-w-[80%]'
            }`}
          >
            <p className="whitespace-pre-wrap">{message.content}</p>
          </div>
        ))}
      </div>

      <form onSubmit={handleSubmit} className="flex gap-2 pt-4">
        <input
          value={input}
          onChange={handleInputChange}
          placeholder="Type your message..."
          className="flex-1 p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          disabled={isLoading}
        />
        <button
          type="submit"
          disabled={isLoading || !input.trim()}
          className="px-6 py-3 bg-blue-500 text-white rounded-lg hover:bg-blue-600 disabled:opacity-50"
        >
          {isLoading ? 'Sending...' : 'Send'}
        </button>
      </form>
    </div>
  );
}
```

### Advanced useChat Configuration

```typescript
'use client';

import { useChat, Message } from '@ai-sdk/react';
import { useState, useCallback, useRef, useEffect } from 'react';

export default function AdvancedChatPage() {
  const [selectedModel, setSelectedModel] = useState('gpt-4-turbo');
  const scrollRef = useRef<HTMLDivElement>(null);

  const {
    messages, input, setInput, handleInputChange, handleSubmit,
    isLoading, error, reload, stop, append, setMessages,
  } = useChat({
    api: '/api/chat',
    body: { model: selectedModel, temperature: 0.7 },
    initialMessages: [],
    generateId: () => crypto.randomUUID(),
    onResponse: (response) => {
      if (!response.ok) console.error('Response error:', response.status);
    },
    onFinish: (message) => {
      console.log('Message completed:', message.id);
    },
    onError: (error) => {
      console.error('Chat error:', error);
    },
  });

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [messages]);

  const sendQuickMessage = useCallback((content: string) => {
    append({ role: 'user', content });
  }, [append]);

  const clearChat = useCallback(() => {
    setMessages([]);
  }, [setMessages]);

  const retryLast = useCallback(() => {
    if (messages.length >= 2) reload();
  }, [messages, reload]);

  return (
    <div className="flex flex-col h-screen max-w-3xl mx-auto">
      {/* Header with model selector and clear button */}
      {/* Message list */}
      {/* Input form */}
    </div>
  );
}
```

## Key Features

**Streaming Management:** The SDK handles token streaming automatically, updating UI incrementally without blocking user interaction.

**Multi-Model Support:** Easily switch between OpenAI, Anthropic, Google, and other providers with identical code syntax.

**Error Handling:** Built-in validation, rate limiting hooks, and graceful error recovery with retry mechanisms.

**State Synchronization:** Client and server states remain synchronized through automatic message ID generation and history management.

**Production Features:** Edge runtime support, request validation with Zod, configurable timeouts, and comprehensive logging hooks.

## Summary

The Vercel AI SDK eliminates boilerplate around streaming, state management, and provider integration. By abstracting complex patterns into simple hooks, developers can focus on building user-facing features rather than infrastructure plumbing.
