---
title: "Retry Patterns That Work: Exponential Backoff, Jitter, and Dead Letter Queues"
url: "https://dev.to/young_gao/retry-patterns-that-actually-work-exponential-backoff-jitter-and-dead-letter-queues-75"
author: "Young Gao"
category: "agent-retry-backoff-pattern"
---

# Retry Patterns That Work: Exponential Backoff, Jitter, and Dead Letter Queues

**Author:** Young Gao
**Published:** March 21, 2026

## Overview
Part 6 of a 15-part Backend Architecture in TypeScript series. Covers exponential backoff with jitter to prevent thundering herd, error classification for retryable vs permanent failures, and dead letter queues for failed messages.

## Key Concepts

### Why Jitter Matters
Without jitter, 1000 clients all retry at the same exponential intervals, stampeding the server. Jitter randomizes retry time so clients spread out naturally.

### What NOT to Retry
- Retryable: 429 (rate limit), 503 (overloaded), timeout, connection refused
- Non-retryable: 400, 401, 404, 422 (permanent failures)

### Dead Letter Queue
Failed messages after max retries go to DLQ for later review, never silently dropped.

## Code Examples

### TypeScript Retry with Backoff and Jitter

```typescript
async function retry<T>(fn: () => Promise<T>, maxRetries = 5): Promise<T> {
  for (let i = 0; i < maxRetries; i++) {
    try { return await fn(); }
    catch (err) {
      if (i === maxRetries - 1) throw err;
      const delay = Math.min(1000 * Math.pow(2, i), 30000);
      const jitter = delay * (0.5 + Math.random() * 0.5);
      await new Promise(r => setTimeout(r, jitter));
    }
  }
}
```
