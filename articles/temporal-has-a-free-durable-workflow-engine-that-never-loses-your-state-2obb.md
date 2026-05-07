---
title: "Temporal Has a Free Durable Workflow Engine That Never Loses Your State"
url: "https://dev.to/0012303/temporal-has-a-free-durable-workflow-engine-that-never-loses-your-state-2obb"
author: "Alex Spinov"
category: "multi-cloud-durable"
---

# Temporal Has a Free Durable Workflow Engine That Never Loses Your State
**Author:** Alex Spinov
**Published:** March 29, 2026

## Overview
Practical guide to Temporal's durable workflow engine with TypeScript examples. Demonstrates user onboarding workflow that survives crashes, restarts, and deployments, including durable sleep that persists across server restarts.

## Key Concepts

```typescript
import { proxyActivities, sleep } from '@temporalio/workflow';
import type * as activities from './activities';

const { sendEmail, chargePayment, provisionAccount } = proxyActivities<typeof activities>({
  startToCloseTimeout: '30 seconds',
  retry: { maximumAttempts: 3 }
});

export async function onboardUser(email: string, plan: string): Promise<void> {
  await sendEmail(email, 'Welcome!');
  const paymentId = await chargePayment(email, plan);
  await provisionAccount(email, plan);
  await sleep('3 days'); // Durable! Survives server restarts.
  await sendEmail(email, 'Here are some tips...');
  await sleep('7 days');
  await sendEmail(email, 'How\'s it going?');
}
```

Quick start: `docker compose up -d` then `npx @temporalio/create@latest my-app`. Workflows survive crashes, restarts, and deployments. Automatic retries with configurable policies. Built-in timers, versioning, and web UI visibility.
