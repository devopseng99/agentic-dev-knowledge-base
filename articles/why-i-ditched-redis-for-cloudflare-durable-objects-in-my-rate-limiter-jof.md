---
title: "Why I Ditched Redis for Cloudflare Durable Objects in My Rate Limiter"
url: "https://dev.to/horushe/why-i-ditched-redis-for-cloudflare-durable-objects-in-my-rate-limiter-jof"
author: "horus he"
category: "cloudflare-durable-objects"
---

# Why I Ditched Redis for Cloudflare Durable Objects in My Rate Limiter
**Author:** horus he
**Published:** August 30, 2025

## Overview
Replacing Redis-based rate limiting with Cloudflare Durable Objects for an AI image generator. Results: under 5ms latency (vs 80-150ms Redis), 30% cost reduction, 10x more requests.

## Key Concepts

### ThrottlerDO Implementation

```typescript
import { DurableObject } from "cloudflare:workers";

export class ThrottlerDO extends DurableObject {
  limitCycleExecutionTimes = 10;
  limitCycleTimeMs = 10 * 60 * 1000;

  async tryApply(options?: TryApplyOptions): Promise<ThrottlerResponse> {
    let state = await this.ctx.storage.get('throttle_state') as ThrottleState | null;
    if (!state) {
      state = { limitTimes: 0, limitEndTimeMs: 0, executedTimesCurrentCycle: 0, currentCycle: 0 };
    }
    const currentMs = Date.now();
    if (state.limitEndTimeMs > 0 && currentMs > state.limitEndTimeMs) {
      state.limitEndTimeMs = 0;
      state.executedTimesCurrentCycle = 0;
    }
    let granted = false;
    if (state.executedTimesCurrentCycle < this.limitCycleExecutionTimes) {
      state.executedTimesCurrentCycle++;
      granted = true;
    } else {
      state.limitTimes++;
    }
    if (state.limitEndTimeMs === 0) {
      state.limitEndTimeMs = currentMs + this.limitCycleTimeMs;
      state.currentCycle++;
    }
    await this.ctx.storage.put('throttle_state', state);
    return { granted, state };
  }
}
```

### Integration

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const userId = request.headers.get('user-id') || 'anonymous';
    const id = env.THROTTLER.idFromName(userId);
    const throttler = env.THROTTLER.get(id);
    const result = await throttler.tryApply({
      limitCycleExecutionTimes: 5, limitCycleTimeMs: 60 * 1000,
    });
    if (!result.granted) {
      return new Response('Rate limit exceeded', { status: 429, headers: { 'Retry-After': '60' } });
    }
    return processRequest(request);
  }
};
```
