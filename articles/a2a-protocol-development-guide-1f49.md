---
title: "A2A Protocol Development Guide"
url: "https://dev.to/czmilo/a2a-protocol-development-guide-1f49"
author: "cz"
category: "a2a-protocols"
---

# A2A Protocol Development Guide
**Author:** cz
**Published:** April 11, 2025

## Overview
A comprehensive development guide for the A2A (Agent-to-Agent) JSON-RPC based communication framework, covering server implementation, client implementation, and a working Coder Demo.

## Key Concepts

### Message Structure

```typescript
interface JSONRPCMessage {
  jsonrpc?: "2.0";
  id?: number | string | null;
  method?: string;
  params?: unknown;
  result?: unknown;
  error?: JSONRPCError;
}
```

### Core Methods
- `tasks/send`: Send a task message to an agent
- `tasks/get`: Retrieve task status
- `tasks/cancel`: Cancel a running task
- `tasks/pushNotification/set`: Configure push notifications
- `tasks/sendSubscribe`: Send task message and subscribe

### Task States
submitted, working, input-required, completed, canceled, failed, unknown

### Server Implementation

```typescript
import {
  A2AServer,
  InMemoryTaskStore,
  TaskContext,
  TaskYieldUpdate,
} from "./index";

async function* myAgentLogic(
  context: TaskContext
): AsyncGenerator<TaskYieldUpdate> {
  console.log(`Handling task: ${context.task.id}`);
  yield {
    state: "working",
    message: { role: "agent", parts: [{ text: "Processing..." }] },
  };

  await new Promise((resolve) => setTimeout(resolve, 1000));

  if (context.isCancelled()) {
    console.log("Task cancelled!");
    yield { state: "canceled" };
    return;
  }

  yield {
    name: "result.txt",
    mimeType: "text/plain",
    parts: [{ text: `Task ${context.task.id} completed.` }],
  };

  yield {
    state: "completed",
    message: { role: "agent", parts: [{ text: "Done!" }] },
  };
}

const store = new InMemoryTaskStore();
const server = new A2AServer(myAgentLogic, { taskStore: store });
server.start();
```

### Client Implementation

```typescript
import { A2AClient, Task, TaskQueryParams, TaskSendParams } from "./client";
import { v4 as uuidv4 } from "uuid";

const client = new A2AClient("http://localhost:41241");

async function run() {
  try {
    const taskId = uuidv4();
    const sendParams: TaskSendParams = {
      id: taskId,
      message: { role: "user", parts: [{ text: "Hello, agent!" }] },
    };
    const taskResult: Task | null = await client.sendTask(sendParams);
    console.log("Send Task Result:", taskResult);
  } catch (error) {
    console.error("A2A Client Error:", error);
  }
}
run();
```

### Streaming Client

```typescript
import {
  A2AClient,
  TaskStatusUpdateEvent,
  TaskArtifactUpdateEvent,
  TaskSendParams,
} from "./client";
import { v4 as uuidv4 } from "uuid";

const client = new A2AClient("http://localhost:41241");

async function streamTask() {
  const streamingTaskId = uuidv4();
  const streamParams: TaskSendParams = {
    id: streamingTaskId,
    message: { role: "user", parts: [{ text: "Stream me some updates!" }] },
  };
  const stream = client.sendTaskSubscribe(streamParams);

  for await (const event of stream) {
    if ("status" in event) {
      const statusEvent = event as TaskStatusUpdateEvent;
      console.log(`Status Update: ${statusEvent.status.state}`);
      if (statusEvent.final) break;
    } else if ("artifact" in event) {
      const artifactEvent = event as TaskArtifactUpdateEvent;
      console.log(`Artifact Update: ${artifactEvent.artifact.name}`);
    }
  }
}
streamTask();
```

### Error Codes
- `-32700`: Parse error
- `-32600`: Invalid request
- `-32601`: Method not found
- `-32000`: Task not found
- `-32001`: Task not cancelable
- `-32002`: Push notification not supported
