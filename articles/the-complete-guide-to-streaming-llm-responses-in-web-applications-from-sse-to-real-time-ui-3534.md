---
title: "The Complete Guide to Streaming LLM Responses in Web Applications"
url: "https://dev.to/pockit_tools/the-complete-guide-to-streaming-llm-responses-in-web-applications-from-sse-to-real-time-ui-3534"
author: "HK Lee"
category: "streaming"
---

# The Complete Guide to Streaming LLM Responses in Web Applications

**Author:** HK Lee
**Published:** December 27, 2025
**Original URL:** pockit.tools/blog/streaming-llm-responses-web-guide

---

## Overview

This comprehensive guide addresses implementing LLM response streaming -- the typewriter effect seen in ChatGPT and Claude -- across web applications. The guide covers protocols, backend implementations, frontend optimization, and production considerations.

## Key Concepts

### Why Streaming Matters

Streaming improves perceived responsiveness dramatically. According to the article, "Users perceive streaming interfaces as **40% faster** than buffered responses, even when total time is identical." Without streaming, users wait through entire generation cycles; with it, content appears within the Time-to-First-Token (TTFT) window.

### The Streaming Pipeline

```
LLM API -> Backend Server -> Transport Protocol -> Frontend Rendering
(Tokens)    (Chunks)        (SSE/WebSockets)   (DOM Updates)
```

---

## Part 1: Server-Sent Events (SSE)

### What is SSE?

SSE enables server-to-client data pushing over HTTP. Key characteristics:
- Unidirectional (server -> client)
- HTTP-based (works through proxies and CDNs)
- Auto-reconnecting with built-in retry mechanisms
- Text-based message format

### SSE Protocol Format

```
event: message
data: {"content": "Hello"}

event: message
data: {"content": " world"}

event: done
data: [DONE]
```

### Node.js/Express Backend Implementation

```javascript
import express from 'express';
import OpenAI from 'openai';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

app.post('/api/chat/stream', async (req, res) => {
  const { messages, model = 'gpt-4-turbo-preview' } = req.body;

  // Set SSE headers
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no'); // Disable nginx buffering

  res.flushHeaders();

  try {
    const stream = await openai.chat.completions.create({
      model,
      messages,
      stream: true,
      stream_options: { include_usage: true },
    });

    let totalTokens = 0;

    for await (const chunk of stream) {
      const content = chunk.choices[0]?.delta?.content;
      const finishReason = chunk.choices[0]?.finish_reason;

      if (chunk.usage) {
        totalTokens = chunk.usage.total_tokens;
      }

      if (content) {
        res.write(`data: ${JSON.stringify({
          type: 'content',
          content
        })}\n\n`);
      }

      if (finishReason) {
        res.write(`data: ${JSON.stringify({
          type: 'done',
          finishReason,
          usage: { totalTokens }
        })}\n\n`);
      }
    }
  } catch (error) {
    console.error('Stream error:', error);
    res.write(`data: ${JSON.stringify({
      type: 'error',
      message: error.message
    })}\n\n`);
  } finally {
    res.end();
  }
});

app.listen(3001, () => {
  console.log('Server running on http://localhost:3001');
});
```

### Critical Implementation Details

**Proxy Buffering:**
```javascript
res.setHeader('X-Accel-Buffering', 'no');  // Nginx
res.setHeader('Cache-Control', 'no-cache, no-transform'); // CDNs
```

**Connection Heartbeats:**
```javascript
const heartbeat = setInterval(() => {
  res.write(': heartbeat\n\n');
}, 15000);

req.on('close', () => {
  clearInterval(heartbeat);
});
```

**Backpressure Handling:**
```javascript
for await (const chunk of stream) {
  const content = chunk.choices[0]?.delta?.content;
  if (content) {
    const data = `data: ${JSON.stringify({ type: 'content', content })}\n\n`;
    const canContinue = res.write(data);
    if (!canContinue) {
      await new Promise(resolve => res.once('drain', resolve));
    }
  }
}
```

---

## Part 2: React Frontend Implementation

### Custom Hook: useStreamingChat

```typescript
import { useState, useCallback, useRef } from 'react';

interface Message {
  role: 'user' | 'assistant';
  content: string;
}

interface StreamState {
  isStreaming: boolean;
  error: string | null;
  usage: { totalTokens: number } | null;
}

export function useStreamingChat() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [streamState, setStreamState] = useState<StreamState>({
    isStreaming: false,
    error: null,
    usage: null,
  });

  const abortControllerRef = useRef<AbortController | null>(null);

  const sendMessage = useCallback(async (userMessage: string) => {
    abortControllerRef.current?.abort();
    abortControllerRef.current = new AbortController();

    const newMessages: Message[] = [
      ...messages,
      { role: 'user', content: userMessage },
    ];

    setMessages([...newMessages, { role: 'assistant', content: '' }]);
    setStreamState({ isStreaming: true, error: null, usage: null });

    try {
      const response = await fetch('/api/chat/stream', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ messages: newMessages }),
        signal: abortControllerRef.current.signal,
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      const reader = response.body?.getReader();
      if (!reader) throw new Error('No response body');

      const decoder = new TextDecoder();
      let buffer = '';
      let assistantContent = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });

        const lines = buffer.split('\n\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          if (!line.startsWith('data: ')) continue;

          const jsonStr = line.slice(6);
          if (jsonStr === '[DONE]') continue;

          try {
            const data = JSON.parse(jsonStr);

            if (data.type === 'content') {
              assistantContent += data.content;
              setMessages(prev => {
                const updated = [...prev];
                updated[updated.length - 1] = {
                  role: 'assistant',
                  content: assistantContent,
                };
                return updated;
              });
            } else if (data.type === 'done') {
              setStreamState(prev => ({
                ...prev,
                usage: data.usage,
              }));
            } else if (data.type === 'error') {
              throw new Error(data.message);
            }
          } catch (parseError) {
            console.warn('Failed to parse SSE message:', line);
          }
        }
      }
    } catch (error) {
      if ((error as Error).name === 'AbortError') {
        return;
      }

      setStreamState(prev => ({
        ...prev,
        error: (error as Error).message,
      }));

      setMessages(prev => prev.slice(0, -1));
    } finally {
      setStreamState(prev => ({ ...prev, isStreaming: false }));
    }
  }, [messages]);

  const cancelStream = useCallback(() => {
    abortControllerRef.current?.abort();
    setStreamState(prev => ({ ...prev, isStreaming: false }));
  }, []);

  const clearMessages = useCallback(() => {
    setMessages([]);
    setStreamState({ isStreaming: false, error: null, usage: null });
  }, []);

  return {
    messages,
    streamState,
    sendMessage,
    cancelStream,
    clearMessages,
  };
}
```

### Optimized Message Rendering

```typescript
import { memo, useMemo } from 'react';
import { marked } from 'marked';
import DOMPurify from 'dompurify';

interface MessageContentProps {
  content: string;
  isStreaming: boolean;
}

export const MessageContent = memo(function MessageContent({
  content,
  isStreaming,
}: MessageContentProps) {
  const renderedContent = useMemo(() => {
    if (isStreaming) {
      return content.split('\n').map((line, i) => (
        <span key={i}>
          {line}
          {i < content.split('\n').length - 1 && <br />}
        </span>
      ));
    }

    const html = marked(content, { breaks: true, gfm: true });
    const sanitized = DOMPurify.sanitize(html);
    return <div dangerouslySetInnerHTML={{ __html: sanitized }} />;
  }, [content, isStreaming]);

  return (
    <div className="message-content">
      {renderedContent}
      {isStreaming && <span className="cursor-blink">|</span>}
    </div>
  );
});
```

---

## Part 3: Alternative Approaches

### WebSockets for Bidirectional Communication

```typescript
class StreamingWebSocket {
  private ws: WebSocket;
  private messageHandlers = new Map<string, (data: any) => void>();

  constructor(url: string) {
    this.ws = new WebSocket(url);

    this.ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      const handler = this.messageHandlers.get(data.streamId);
      if (handler) handler(data);
    };
  }

  async streamChat(
    messages: Message[],
    onChunk: (content: string) => void
  ): Promise<{ streamId: string; cancel: () => void }> {
    const streamId = crypto.randomUUID();

    this.messageHandlers.set(streamId, (data) => {
      if (data.type === 'content') {
        onChunk(data.content);
      }
    });

    this.ws.send(JSON.stringify({
      type: 'start_stream',
      streamId,
      messages,
    }));

    return {
      streamId,
      cancel: () => {
        this.ws.send(JSON.stringify({ type: 'cancel', streamId }));
        this.messageHandlers.delete(streamId);
      },
    };
  }
}
```

### Vercel AI SDK

```typescript
import { useChat } from 'ai/react';

export function Chat() {
  const { messages, input, handleInputChange, handleSubmit, isLoading } = useChat({
    api: '/api/chat',
  });

  return (
    <div>
      {messages.map(m => (
        <div key={m.id}>{m.role}: {m.content}</div>
      ))}
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} />
        <button type="submit" disabled={isLoading}>Send</button>
      </form>
    </div>
  );
}
```

---

## Part 4: Production Considerations

### Error Recovery with Exponential Backoff

```typescript
async function* streamWithRetry(
  messages: Message[],
  maxRetries = 3
) {
  let attempt = 0;

  while (attempt < maxRetries) {
    try {
      yield* streamFromAPI(messages);
      return;
    } catch (error) {
      attempt++;

      if (attempt >= maxRetries) throw error;

      const delay = Math.pow(2, attempt - 1) * 1000;
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
}
```

### Rate Limiting with Token Bucket

```typescript
class RateLimiter {
  private tokens: number;
  private lastRefill: number;

  constructor(
    private maxTokens: number,
    private refillRate: number
  ) {
    this.tokens = maxTokens;
    this.lastRefill = Date.now();
  }

  async acquire(): Promise<boolean> {
    this.refill();

    if (this.tokens >= 1) {
      this.tokens -= 1;
      return true;
    }

    return false;
  }

  private refill() {
    const now = Date.now();
    const elapsed = (now - this.lastRefill) / 1000;
    this.tokens = Math.min(
      this.maxTokens,
      this.tokens + elapsed * this.refillRate
    );
    this.lastRefill = now;
  }
}
```

### Monitoring with Prometheus Metrics

```typescript
import { Counter, Histogram } from 'prom-client';

const streamDuration = new Histogram({
  name: 'llm_stream_duration_seconds',
  help: 'Duration of LLM streaming requests',
  buckets: [0.5, 1, 2, 5, 10, 30, 60],
});

const tokensGenerated = new Counter({
  name: 'llm_tokens_generated_total',
  help: 'Total tokens generated',
});

const streamErrors = new Counter({
  name: 'llm_stream_errors_total',
  help: 'Total streaming errors',
  labelNames: ['error_type'],
});
```

### Intelligent Model Selection

```typescript
function selectModel(prompt: string): string {
  const estimatedComplexity = analyzePromptComplexity(prompt);

  if (estimatedComplexity < 0.3) {
    return 'gpt-3.5-turbo';
  } else if (estimatedComplexity < 0.7) {
    return 'gpt-4-turbo-preview';
  } else {
    return 'gpt-4';
  }
}
```

---

## Part 5: Edge Cases

### Virtual Scrolling for Long Responses

```typescript
import { FixedSizeList as List } from 'react-window';

function VirtualizedMessage({ content }: { content: string }) {
  const lines = content.split('\n');

  return (
    <List
      height={400}
      itemCount={lines.length}
      itemSize={24}
      width="100%"
    >
      {({ index, style }) => (
        <div style={style}>{lines[index]}</div>
      )}
    </List>
  );
}
```

### Code Block Detection

```typescript
function isCompleteCodeBlock(content: string): boolean {
  const openBlocks = (content.match(/```/g) || []).length;
  return openBlocks % 2 === 0;
}

function MessageContent({ content, isStreaming }: Props) {
  const shouldHighlight = !isStreaming || isCompleteCodeBlock(content);

  const processed = shouldHighlight
    ? highlightCode(content)
    : escapeHtml(content);

  return <div dangerouslySetInnerHTML={{ __html: processed }} />;
}
```

### Mobile Optimization

```typescript
function getChunkingStrategy(): 'immediate' | 'batched' {
  if ('connection' in navigator) {
    const connection = (navigator as any).connection;

    if (connection.effectiveType === '2g' ||
        connection.effectiveType === 'slow-2g') {
      return 'batched';
    }
  }

  return 'immediate';
}
```

---

## Key Takeaways

1. **SSE is the default**: Simple, HTTP-based, works through proxies and CDNs
2. **Handle infrastructure challenges**: Proxy buffering, connection timeouts, and backpressure require explicit handling
3. **Optimize rendering**: Parse markdown only after streaming completes; avoid expensive DOM operations during updates
4. **Monitor critical metrics**: Track Time-to-First-Token, Tokens-Per-Second, and completion rates in production
5. **Plan for edge cases**: Long responses, code blocks, and mobile users need specialized handling

The article emphasizes that streaming implementation patterns are universally applicable across LLM providers (OpenAI, Anthropic, Ollama), making these techniques broadly valuable for AI-powered web applications.
