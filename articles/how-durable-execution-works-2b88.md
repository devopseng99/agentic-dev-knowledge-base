---
title: "How Durable Execution Works"
url: "https://dev.to/temporalio/how-durable-execution-works-2b88"
author: "Loren"
category: "multi-cloud-durable"
---

# How Durable Execution Works
**Author:** Loren
**Published:** May 23, 2023

## Overview
Part 2 of "Building Reliable Distributed Systems in Node.js." Explains how Temporal provides durable execution through its three core components (Client, Server, Worker), Event History mechanism, and replay-based recovery.

## Key Concepts

A Temporal application consists of three parts: the Client (initiates workflows), the Server (maintains state and event history), and the Worker (executes code).

```typescript
import { NativeConnection, Worker } from '@temporalio/worker'
import * as activities from 'activities'

async function run() {
  const connection = await NativeConnection.connect(getConnectionOptions())
  const worker = await Worker.create({
    workflowsPath: require.resolve('../../../packages/workflows/'),
    activities,
    connection,
    namespace,
    taskQueue,
  })
  await worker.run()
}
```

The Event History is the foundation -- a complete, immutable log enabling deterministic replay. When a Worker loses execution context (crash, restart), it fetches Event History from Server, creates a new isolate, and re-runs the function. When hitting a previously completed activity, the Worker sees ActivityTaskCompleted in history and immediately resolves the Promise instead of re-executing.

Workflows support timers:

```typescript
const notPickedUpInTime = !(await condition(() => state === 'Picked up', '1 min'))
```

And signal handlers for external events:

```typescript
setHandler(pickedUpSignal, () => {
  if (state === 'Paid') {
    state = 'Picked up'
  }
})
```

Failures are transparent to the application developer -- you write your Workflow and Activity code, and Temporal handles reliably executing it.
