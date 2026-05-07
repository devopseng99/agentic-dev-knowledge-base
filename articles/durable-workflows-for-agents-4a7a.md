---
title: "Durable Workflows for Agents"
url: "https://dev.to/theodordiaconu/durable-workflows-for-agents-4a7a"
author: "Theodor Diaconu"
category: "multi-cloud-durable"
---

# Durable Workflows for Agents
**Author:** Theodor Diaconu
**Published:** March 25, 2026

## Overview
Argues that most agent workflow libraries optimize the easy parts (model calls, tool calls, retries) but fail to address the real problem: workflows lasting longer than a single HTTP request. Introduces Runner's durable workflow pattern for building agent systems that survive time, crashes, and restarts.

## Key Concepts

Real agent workflows span minutes, hours, or days waiting for human approval, webhooks, scheduled retries, or sub-workflows. Durable workflows solve this by persisting progress, surviving crashes, supporting safe cancellation, and scaling horizontally.

A durable workflow is a normal async function with checkpoints:

```javascript
const workflow = r
  .task("publishArticleWorkflow")
  .dependencies({ durable })
  .tags([
    tags.durableWorkflow.with({
      category: "content",
      signals: [Approved],
    }),
  ])
  .run(async (input: { articleId: string }, { durable }) => {
    const d = durable.use();

    await d.step("generate-draft", async () => {
      return { articleId: input.articleId };
    });

    await d.waitForSignal(Approved, { stepId: "wait-approval" });
    await d.sleep(60 * 60 * 1000, { stepId: "cooldown-before-publish" });

    await d.step("publish", async () => {
      return { ok: true };
    });
  })
  .build();
```

Production setup with Redis and RabbitMQ:

```javascript
const durable = resources.redisWorkflow.fork("content-durable");

const durableRegistration = durable.with({
  redis: { url: process.env.REDIS_URL! },
  queue: {
    url: process.env.RABBITMQ_URL!,
    consume: true,
    quorum: true,
  },
  polling: { enabled: true, interval: 1000, concurrency: 10 },
  recovery: { onStartup: true },
});
```

Key rule: put side effects inside `step()`. Code outside a durable step may run more than once. Completed steps return cached results; unfinished steps execute only once.
