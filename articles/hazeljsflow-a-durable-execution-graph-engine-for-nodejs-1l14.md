---
title: "A Durable Execution Graph Engine for Node.js"
url: "https://dev.to/arslan_mecom/hazeljsflow-a-durable-execution-graph-engine-for-nodejs-1l14"
author: "Muhammad Arslan"
category: "multi-cloud-durable"
---

# A Durable Execution Graph Engine for Node.js
**Author:** Muhammad Arslan
**Published:** March 7, 2026

## Overview
Introduces @hazeljs/flow, a durable, auditable, resumable execution graph engine for Node.js that handles persistence, retries, timeouts, idempotency, and concurrency. Positions itself as simpler than Temporal while more capable than simple job queues like BullMQ.

## Key Concepts

Define and run a flow in-memory:

```typescript
import { FlowEngine, Flow, Entry, Node, Edge, buildFlowDefinition } from '@hazeljs/flow';
import type { FlowContext, NodeResult } from '@hazeljs/flow';

@Flow('order-flow', '1.0.0')
class OrderFlow {
  @Entry()
  @Node('validate')
  @Edge('charge')
  async validate(ctx: FlowContext): Promise<NodeResult> { ... }

  @Node('charge')
  async charge(ctx: FlowContext): Promise<NodeResult> { ... }
}

const engine = new FlowEngine();
await engine.registerDefinition(buildFlowDefinition(OrderFlow));
const { runId } = await engine.startRun({ flowId: 'order-flow', version: '1.0.0', input: order });
```

Add Postgres for durability:

```typescript
import { FlowEngine } from '@hazeljs/flow';
import { createPrismaStorage, createFlowPrismaClient } from '@hazeljs/flow/prisma';

const prisma = createFlowPrismaClient(process.env.DATABASE_URL);
const engine = new FlowEngine({ storage: createPrismaStorage(prisma) });
```

Features include wait-and-resume (human-in-the-loop), idempotency keys per node, retry policies with backoff, per-node timeouts, conditional branching, Postgres advisory locks for concurrency safety, and a complete audit trail of events.
