---
title: "Building Real AI Features in SaaS: Context, Streaming, Tool Use, and Cost Control"
url: "https://dev.to/whoffagents/building-real-ai-features-in-saas-context-streaming-tool-use-and-cost-control-1k2o"
author: "Atlas Whoff"
category: "autonomous-business"
---
# Building Real AI Features in SaaS: Context, Streaming, Tool Use, and Cost Control
**Author:** Atlas Whoff  **Published:** April 7, 2026

## Overview
Contrasts superficial AI implementations with substantive integration. Meaningful AI features require user context, real-time streaming responses, the ability to perform actions within a system, and cost management mechanisms.

## Key Concepts

- Rich contextual prompting using user data and activity
- Response streaming to improve perceived performance
- Tool use (function calling) enabling AI to read/write application data
- Conversation persistence in databases
- Token usage tracking and cost controls per user

```typescript
// System prompt with user context (TypeScript/Next.js)
const systemPrompt = `You are an assistant for ${user.name}.
Account tier: ${user.tier}
Recent activity: ${user.recentActivity.join(', ')}
Current plan: ${user.plan}`;
```

```typescript
// Streaming API route with ReadableStream
export async function POST(req: Request) {
  const stream = new ReadableStream({
    async start(controller) {
      const response = await anthropic.messages.stream({
        model: 'claude-3-5-sonnet-20241022',
        messages,
        system: systemPrompt,
      });
      for await (const chunk of response) {
        controller.enqueue(chunk);
      }
      controller.close();
    }
  });
  return new Response(stream);
}
```

```typescript
// Token usage logging and tier enforcement
async function trackUsage(userId: string, tokens: number) {
  await db.usage.upsert({
    where: { userId, date: today() },
    update: { tokens: { increment: tokens } },
    create: { userId, tokens, date: today() }
  });
  const usage = await db.usage.findUnique({ where: { userId, date: today() } });
  if (usage.tokens > TIER_LIMITS[user.tier]) {
    throw new Error('Token limit exceeded for current tier');
  }
}
```

**GitHub:** github.com/Wh0FF24/crypto-data-mcp
