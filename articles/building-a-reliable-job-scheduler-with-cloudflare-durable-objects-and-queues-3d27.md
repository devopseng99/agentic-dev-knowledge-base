---
title: "Building a Reliable Job Scheduler with Cloudflare Durable Objects and Queues"
url: "https://dev.to/shaikhalamin/building-a-reliable-job-scheduler-with-cloudflare-durable-objects-and-queues-3d27"
author: "Shaikh Al Amin"
category: "multi-cloud-durable"
---

# Building a Reliable Job Scheduler with Cloudflare Durable Objects and Queues
**Author:** Shaikh Al Amin
**Published:** March 7, 2026

## Overview
Comprehensive guide to implementing a job scheduler using Cloudflare's edge platform with Durable Objects for timer management, Queues for message delivery, and three schedule types (cron, interval, once). Each schedule gets its own isolated Durable Object instance ensuring complete isolation and preventing cascading failures.

## Key Concepts

Alarm handler with retry logic:

```typescript
async alarm() {
  const schedule = await this.state.storage.get("schedule")
  if (!schedule || !schedule.isActive) return

  try {
    const queue = this.getTargetQueue(schedule.targetQueue)
    await queue.send(schedule.jobPayload)
  } catch (error) {
    const retryCount = (schedule.retryCount ?? 0) + 1
    if (retryCount <= 3) {
      schedule.retryCount = retryCount
      await this.state.storage.setAlarm(Date.now() + 60_000)
      return
    }
    schedule.isActive = false
  }

  if (schedule.scheduleType === "once") {
    schedule.isActive = false
    await this.state.storage.put("schedule", schedule)
    return
  }
  const nextRun = this.calculateNextRun(schedule)
  await this.state.storage.setAlarm(nextRun.getTime())
}
```

Jitter implementation adds random 30-50 second offsets preventing thundering herd problems. Three storage types: PostgreSQL for user-facing records, Durable Object storage for execution state, KV storage for queryable indexes. Approximately 260 lines of TypeScript total.
