---
title: "Vercel AI SDK useChat in Production: Streaming, Errors, and the Patterns Nobody Writes About"
url: https://dev.to/whoffagents/vercel-ai-sdk-usechat-in-production-streaming-errors-and-the-patterns-nobody-writes-about-4ecf
author: Atlas Whoff
category: vercel-ai-sdk
---

# Vercel AI SDK useChat in Production: Streaming, Errors, and the Patterns Nobody Writes About

**Author:** Atlas Whoff
**Date Published:** April 12, 2026
**Tags:** #nextjs #ai #webdev #typescript

---

## Article Summary

This article addresses the gap between the simplified examples in the Vercel AI SDK documentation and what's actually required for production implementations of the `useChat` hook. The author shares real-world challenges encountered while shipping two production applications.

---

## Key Problems & Solutions

### Problem 1: Streaming Interruptions and Partial Messages

When users close tabs or lose connectivity mid-stream, incomplete messages remain in state with no indication of failure.

**Solution:** Use `onFinish` callbacks to persist only complete messages, and provide a `stop` button for long-running generations.

```typescript
const { messages, isLoading, stop } = useChat({
  onError: (error) => {
    console.error('Stream error:', error);
  },
  onFinish: (message) => {
    saveMessageToDatabase(message);
  },
});

<button onClick={stop} disabled={!isLoading}>
  Stop generating
</button>
```

### Problem 2: Message Persistence Across Sessions

Default `useChat` behavior is stateless--refreshing loses conversation history.

**Solution:** Load prior messages from database and use `initialMessages` option.

```typescript
async function loadChatHistory(chatId: string) {
  const rows = await db
    .select()
    .from(messages)
    .where(eq(messages.chatId, chatId))
    .orderBy(messages.createdAt);

  return rows.map(r => ({
    id: r.id,
    role: r.role as 'user' | 'assistant',
    content: r.content,
  }));
}

const { messages } = useChat({
  initialMessages: await loadChatHistory(chatId),
  onFinish: async (message) => {
    await saveMessage({ chatId, ...message });
  },
});
```

### Problem 3: API Route Receives Full History Every Request

Each new message sends the entire conversation history, creating performance and cost inefficiencies.

**Solutions:**

**Truncation (simplest):**
```typescript
export async function POST(req: Request) {
  const { messages } = await req.json();
  const MAX_CONTEXT = 20;
  const contextMessages = messages.slice(-MAX_CONTEXT);

  const result = await streamText({
    model: anthropic('claude-sonnet-4-6'),
    system: 'You are a helpful assistant.',
    messages: contextMessages,
  });

  return result.toDataStreamResponse();
}
```

**Summarization (better for long conversations):**
```typescript
export async function POST(req: Request) {
  const { messages } = await req.json();
  let processedMessages = messages;

  if (messages.length > 30) {
    const toSummarize = messages.slice(0, -10);
    const recent = messages.slice(-10);

    const summary = await generateText({
      model: anthropic('claude-haiku-4-5-20251001'),
      messages: [
        ...toSummarize,
        { role: 'user', content: 'Summarize this conversation in 3-5 sentences.' }
      ],
    });

    processedMessages = [
      { role: 'user', content: `[Previous conversation summary]: ${summary.text}` },
      { role: 'assistant', content: 'Understood.' },
      ...recent,
    ];
  }

  const result = await streamText({
    model: anthropic('claude-sonnet-4-6'),
    messages: processedMessages,
  });

  return result.toDataStreamResponse();
}
```

### Problem 4: Tool Calls and UI State

Default behavior shows nothing while tools execute, leaving users uncertain if the app is responsive.

**Solution:** Render tool invocation states explicitly.

```typescript
const { messages } = useChat({
  api: '/api/chat',
});

{messages.map(m => {
  if (m.role === 'assistant' && m.toolInvocations) {
    return (
      <div key={m.id}>
        {m.toolInvocations.map(tool => (
          <div key={tool.toolCallId}>
            {tool.state === 'call' && (
              <div className="text-gray-500">Calling {tool.toolName}...</div>
            )}
            {tool.state === 'result' && (
              <div className="text-green-600">Done: {tool.toolName} complete</div>
            )}
          </div>
        ))}
        {m.content && <div>{m.content}</div>}
      </div>
    );
  }
  return <div key={m.id}>{m.role}: {m.content}</div>;
})}
```

### Problem 5: Cost Tracking Per User

Multi-user products need usage limits and billing tracking.

**Solution:** Use `onFinish` callback on `streamText` to capture token counts.

```typescript
export async function POST(req: Request) {
  const { messages, userId } = await req.json();

  const usage = await getUserUsage(userId);
  if (usage.tokensThisMonth > MONTHLY_LIMIT) {
    return Response.json(
      { error: 'Monthly limit reached. Upgrade to continue.' },
      { status: 429 }
    );
  }

  const result = await streamText({
    model: anthropic('claude-sonnet-4-6'),
    messages,
    onFinish: async ({ usage }) => {
      await incrementUserUsage(userId, {
        inputTokens: usage.promptTokens,
        outputTokens: usage.completionTokens,
      });
    },
  });

  return result.toDataStreamResponse();
}
```

### Problem 6: Error Handling in the Client

Default error behavior leaves broken UI with no recovery path.

**Solution:** Implement comprehensive error handling with user-facing feedback and retry capability.

```typescript
const { messages, error, reload, isLoading } = useChat({
  onError: (err) => {
    if (err.message.includes('429')) {
      toast.error('Rate limited. Try again in a moment.');
    } else if (err.message.includes('Monthly limit')) {
      toast.error('Usage limit reached. Upgrade your plan.');
      router.push('/pricing');
    } else {
      toast.error('Something went wrong. Try again.');
    }
  },
});

{error && (
  <div>
    <p>Failed to get a response.</p>
    <button onClick={reload}>Try again</button>
  </div>
)}
```

---

## Complete Production Setup

```typescript
const {
  messages,
  input,
  handleInputChange,
  handleSubmit,
  isLoading,
  error,
  stop,
  reload,
  setMessages,
} = useChat({
  api: '/api/chat',
  initialMessages: await loadChatHistory(chatId),
  body: { userId: session.user.id, chatId },
  onFinish: (message) => saveMessage({ chatId, message }),
  onError: handleChatError,
});
```

The `body` field passes additional context to the API route without adding it to the messages array.

---

## Key Takeaways

- Persist only complete messages using `onFinish` callbacks
- Load chat history via `initialMessages` for session continuity
- Implement context windowing to manage costs on long conversations
- Display tool invocation states to maintain UI responsiveness
- Track token usage in `onFinish` handlers for accurate billing
- Provide explicit error messages and retry mechanisms
- Pass metadata via the `body` option rather than in message arrays
