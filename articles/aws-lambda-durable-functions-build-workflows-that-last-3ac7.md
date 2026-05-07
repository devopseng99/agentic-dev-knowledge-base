---
title: "AWS Lambda Durable Functions: Build Workflows That Last"
url: "https://dev.to/aws/aws-lambda-durable-functions-build-workflows-that-last-3ac7"
author: "Eric D Johnson"
category: "multi-cloud-durable"
---

# AWS Lambda Durable Functions: Build Workflows That Last
**Author:** Eric D Johnson
**Published:** December 3, 2025

## Overview
Introduces AWS Lambda Durable Functions for building long-running workflows without managing infrastructure. Functions can pause and resume execution, with Lambda checkpointing state automatically. Supports execution up to 1 year with built-in retries, callback waiting, parallel execution, and nested workflows.

## Key Concepts

```javascript
import { DurableContext, withDurableExecution } from '@aws/durable-execution-sdk-js';

export const handler = withDurableExecution(
  async (event: any, context: DurableContext) => {
    const order = await context.step('create-order', async () => {
      return createOrder(event.items);
    });

    await context.wait({ seconds: 300 });

    await context.step('send-notification', async () => {
      return sendEmail(order.customerId, order.id);
    });

    return { orderId: order.id, status: 'completed' };
  }
);
```

Uses replay-based execution: initial invocation executes steps and checkpoints, waits cause pause and state saving, resume triggers reinvocation, replay returns cached results instantly. Operations are deterministic -- executing once with identical replay results.

Local testing:

```javascript
import { LocalDurableTestRunner } from '@aws/durable-execution-sdk-js-testing';
const runner = new LocalDurableTestRunner({ handlerFunction: handler });
const execution = await runner.run();
expect(execution.getStatus()).toBe('SUCCEEDED');
```
