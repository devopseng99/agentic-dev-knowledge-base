---
title: "How to Rate Limit Your AI API Routes in Next.js"
url: "https://dev.to/whoffagents/how-to-rate-limit-your-ai-api-routes-in-nextjs-2d3"
author: "Atlas Whoff"
category: "ai-agent-rate-limiting"
---

# How to Rate Limit Your AI API Routes in Next.js

**Author:** Atlas Whoff
**Published:** April 7, 2026

## Overview
Without rate limiting, a single abusive user can exhaust your entire Claude/OpenAI budget in minutes. Production-ready implementation using Upstash Redis with sliding windows, tiered subscription plans, and daily token budgets.

## Code Examples

### Setup

```bash
npm install @upstash/ratelimit @upstash/redis
```

### Basic Rate Limiter

```typescript
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

export const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, "60 s"),
  analytics: true,
});

export const strictRatelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(3, "60 s"),
  analytics: true,
});
```

### AI Route with Rate Limiting

```typescript
import { NextRequest, NextResponse } from "next/server";
import { auth } from "@/auth";
import { ratelimit } from "@/lib/ratelimit";
import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY! });

export async function POST(req: NextRequest) {
  const session = await auth();
  if (!session?.user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const identifier = `chat:${session.user.id}`;
  const { success, limit, remaining, reset } = await ratelimit.limit(identifier);

  if (!success) {
    return NextResponse.json(
      { error: "Rate limit exceeded", limit, remaining: 0, reset: new Date(reset).toISOString() },
      {
        status: 429,
        headers: {
          "X-RateLimit-Limit": limit.toString(),
          "X-RateLimit-Remaining": "0",
          "Retry-After": Math.ceil((reset - Date.now()) / 1000).toString(),
        },
      }
    );
  }

  const { messages } = await req.json();
  const stream = await anthropic.messages.stream({
    model: "claude-sonnet-4-6",
    max_tokens: 1024,
    messages,
  });

  const readable = new ReadableStream({
    async start(controller) {
      for await (const chunk of stream) {
        if (chunk.type === "content_block_delta" && chunk.delta.type === "text_delta") {
          controller.enqueue(new TextEncoder().encode(chunk.delta.text));
        }
      }
      controller.close();
    },
  });

  return new Response(readable, {
    headers: {
      "Content-Type": "text/plain; charset=utf-8",
      "X-RateLimit-Limit": limit.toString(),
      "X-RateLimit-Remaining": remaining.toString(),
    },
  });
}
```

### Tiered Limits by Plan

```typescript
const freeLimiter = new Ratelimit({
  redis,
  limiter: Ratelimit.slidingWindow(5, "60 s"),
});

const paidLimiter = new Ratelimit({
  redis,
  limiter: Ratelimit.slidingWindow(30, "60 s"),
});

export async function getRatelimiter(userId: string, hasPaid: boolean) {
  const limiter = hasPaid ? paidLimiter : freeLimiter;
  return limiter.limit(`chat:${userId}`);
}
```

### Daily Token Budget

```typescript
const DAILY_TOKEN_BUDGET = {
  free: 50_000,   // ~$0.15/day per free user
  paid: 500_000,  // ~$1.50/day per paid user
};

export async function checkTokenBudget(
  userId: string, hasPaid: boolean, estimatedTokens: number
): Promise<boolean> {
  const key = `tokens:${userId}:${new Date().toISOString().split("T")[0]}`;
  const budget = hasPaid ? DAILY_TOKEN_BUDGET.paid : DAILY_TOKEN_BUDGET.free;
  const used = await redis.incrby(key, estimatedTokens);
  if (used === estimatedTokens) {
    await redis.expire(key, 90000);
  }
  return used <= budget;
}
```
