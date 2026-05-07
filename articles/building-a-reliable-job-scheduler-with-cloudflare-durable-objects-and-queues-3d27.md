---
title: "Building a Reliable Job Scheduler with Cloudflare Durable Objects and Queues"
url: "https://dev.to/shaikhalamin/building-a-reliable-job-scheduler-with-cloudflare-durable-objects-and-queues-3d27"
author: "Shaikh Al Amin"
category: "cloudflare-durable-objects"
---

# Building a Reliable Job Scheduler with Cloudflare Durable Objects and Queues
**Author:** Shaikh Al Amin
**Published:** March 7, 2026

## Overview
Complete job scheduler using Durable Objects (persistent timers), Cloudflare Queues (message delivery), and KV Storage (queryable index). Each schedule gets its own isolated DO instance.

## Key Concepts

### Schedule Types

```typescript
function generateDailyCron(hour: number, minute: number): string {
  return `${minute} ${hour} * * *`
}
```

### One Durable Object Per Schedule

```typescript
app.post("/schedules", async (c) => {
  const config = await c.req.json()
  const doId = c.env.SCHEDULER_DO.idFromName(config.id)
  const stub = c.env.SCHEDULER_DO.get(doId)
  const res = await stub.fetch(new Request("https://do/init", {
    method: "POST", body: JSON.stringify(config),
  }))
})
```

### Alarm-Based Execution

```typescript
async alarm() {
  const schedule = await this.state.storage.get("schedule")
  if (!schedule || !schedule.isActive) return
  const queue = this.getTargetQueue(schedule.targetQueue)
  await queue.send(schedule.jobPayload)
  if (schedule.scheduleType === "once") {
    schedule.isActive = false
    await this.state.storage.put("schedule", schedule)
    return
  }
  const nextRun = this.calculateNextRun(schedule)
  await this.state.storage.setAlarm(nextRun.getTime())
}
```

### Jitter for Load Distribution
30-50 second random offset prevents thousands of schedules from firing simultaneously.

### Three Storage Layers
- PostgreSQL: User-facing records with ownership
- DO Storage: Live schedule state (payload, cron, retry count)
- KV Storage: Read-only index with next run times
