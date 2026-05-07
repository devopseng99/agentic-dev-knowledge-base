---
title: "Event-Driven AI Agents: Patterns That Scale"
url: "https://dev.to/nebulagg/event-driven-ai-agents-patterns-that-scale-39ld"
author: "The Daily Agent"
category: "ai-agent-redis"
---

# Event-Driven AI Agents: Patterns That Scale

**Author:** The Daily Agent
**Published:** March 22, 2026

## Overview
Argues that production AI agents should use event-driven architecture rather than polling mechanisms. Event-driven systems reduce AI agent response latency by 70-90% compared to polling approaches.

## Key Concepts

### Four Core Patterns
1. **Event Queue with Worker Agents** - Sequential processing with guaranteed delivery
2. **Fan-Out for Parallel Processing** - Broadcast one event to multiple agents
3. **Event Sourcing for Auditable Decisions** - Immutable audit trail with SHA-256 checksums
4. **Saga Orchestration** - Multi-step workflows with automatic rollback

## Code Examples

### Pattern 1: Event Queue with Redis Streams
```python
import asyncio
import json
import redis.asyncio as redis
from datetime import datetime
from openai import AsyncOpenAI

client = AsyncOpenAI()
rdb = redis.Redis(host="localhost", port=6379, decode_responses=True)

STREAM = "agent:events"
GROUP = "agent-workers"
CONSUMER = "worker-1"

async def ensure_group():
    try:
        await rdb.xgroup_create(STREAM, GROUP, id="0", mkstream=True)
    except redis.ResponseError as e:
        if "BUSYGROUP" not in str(e):
            raise

async def publish_event(event_type: str, payload: dict):
    event = {
        "type": event_type,
        "payload": json.dumps(payload),
        "timestamp": datetime.utcnow().isoformat(),
    }
    event_id = await rdb.xadd(STREAM, event)
    return event_id

async def process_event(event_id: str, event: dict):
    event_type = event["type"]
    payload = json.loads(event["payload"])
    handlers = {
        "deploy.completed": handle_deploy,
        "alert.triggered": handle_alert,
        "email.received": handle_email,
    }
    handler = handlers.get(event_type)
    if handler:
        await handler(payload)
    await rdb.xack(STREAM, GROUP, event_id)

async def handle_deploy(payload: dict):
    response = await client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "You are a deployment verification agent."},
            {"role": "user", "content": f"Verify this deployment: {json.dumps(payload)}"}
        ],
    )
    print(f"Deploy check: {response.choices[0].message.content[:100]}")

async def worker_loop():
    await ensure_group()
    while True:
        messages = await rdb.xreadgroup(
            GROUP, CONSUMER, {STREAM: ">"}, count=1, block=5000
        )
        for stream_name, events in messages:
            for event_id, event_data in events:
                try:
                    await process_event(event_id, event_data)
                except Exception as e:
                    print(f"Error processing {event_id}: {e}")
```

### Pattern 2: Fan-Out for Parallel Processing
```python
import asyncio
import json
import redis.asyncio as redis

rdb = redis.Redis(host="localhost", port=6379, decode_responses=True)
STREAM = "events:customer"

async def setup_fan_out():
    groups = ["email-agent", "provisioning-agent", "crm-agent", "sales-notifier"]
    for group in groups:
        try:
            await rdb.xgroup_create(STREAM, group, id="0", mkstream=True)
        except redis.ResponseError:
            pass

async def agent_worker(group_name: str, handler):
    consumer = f"{group_name}-1"
    while True:
        messages = await rdb.xreadgroup(
            group_name, consumer, {STREAM: ">"}, count=1, block=5000
        )
        for _, events in messages:
            for event_id, data in events:
                payload = json.loads(data.get("payload", "{}"))
                try:
                    await handler(payload)
                    await rdb.xack(STREAM, group_name, event_id)
                except Exception as e:
                    print(f"[{group_name}] Failed: {e}")

async def main():
    await setup_fan_out()
    await asyncio.gather(
        agent_worker("email-agent", email_handler),
        agent_worker("provisioning-agent", provision_handler),
        agent_worker("crm-agent", crm_handler),
        agent_worker("sales-notifier", sales_handler),
    )
```

### Pattern 3: Event Sourcing with Audit Trail
```python
import json
import hashlib
from dataclasses import dataclass, asdict
from datetime import datetime

@dataclass
class AgentEvent:
    event_id: str
    event_type: str
    agent_id: str
    timestamp: str
    payload: dict
    parent_event_id: str | None = None
    checksum: str = ""

    def __post_init__(self):
        if not self.checksum:
            content = json.dumps(
                {"type": self.event_type, "payload": self.payload,
                 "agent": self.agent_id, "ts": self.timestamp},
                sort_keys=True,
            )
            self.checksum = hashlib.sha256(content.encode()).hexdigest()[:16]

class EventStore:
    def __init__(self):
        self._events: list[AgentEvent] = []

    def append(self, event: AgentEvent):
        self._events.append(event)

    def get_causal_chain(self, event_id: str) -> list[AgentEvent]:
        chain = []
        current_id = event_id
        while current_id:
            event = next((e for e in self._events if e.event_id == current_id), None)
            if not event:
                break
            chain.append(event)
            current_id = event.parent_event_id
        return list(reversed(chain))
```

### Pattern 4: Saga Orchestration with Rollback
```python
from dataclasses import dataclass, field
from enum import Enum
from typing import Callable, Any

class StepStatus(Enum):
    PENDING = "pending"
    COMPLETED = "completed"
    FAILED = "failed"
    COMPENSATED = "compensated"

@dataclass
class SagaStep:
    name: str
    execute: Callable
    compensate: Callable
    status: StepStatus = StepStatus.PENDING

@dataclass
class Saga:
    name: str
    steps: list[SagaStep] = field(default_factory=list)
    context: dict = field(default_factory=dict)

    async def run(self) -> bool:
        completed: list[SagaStep] = []
        for step in self.steps:
            try:
                step.result = await step.execute(self.context)
                step.status = StepStatus.COMPLETED
                completed.append(step)
            except Exception as e:
                step.status = StepStatus.FAILED
                await self._compensate(completed)
                return False
        return True

    async def _compensate(self, completed: list[SagaStep]):
        for step in reversed(completed):
            try:
                await step.compensate(self.context)
                step.status = StepStatus.COMPENSATED
            except Exception as e:
                print(f"[undo-FAIL] {step.name}: {e}")
```

### Retry with Exponential Backoff
```python
import asyncio
import random

async def retry_with_backoff(fn, max_retries=3, base_delay=1.0):
    for attempt in range(max_retries + 1):
        try:
            return await fn()
        except Exception as e:
            if attempt == max_retries:
                raise
            delay = base_delay * (2 ** attempt) + random.uniform(0, 0.5)
            await asyncio.sleep(delay)
```

### Dead Letter Queue
```python
DLQ_STREAM = "agent:dead-letters"

async def send_to_dlq(event_id: str, event: dict, error: str):
    await rdb.xadd(DLQ_STREAM, {
        "original_event_id": event_id,
        "original_stream": STREAM,
        "event_data": json.dumps(event),
        "error": error,
        "failed_at": datetime.utcnow().isoformat(),
        "retry_count": "3",
    })
    await rdb.xack(STREAM, GROUP, event_id)
```

## Pattern Selection Guide
| Scenario | Pattern |
|----------|---------|
| Process events one at a time | Queue + Workers |
| One event triggers multiple agents | Fan-Out |
| Compliance/audit requirements | Event Sourcing |
| Multi-step workflows with rollback | Saga |
