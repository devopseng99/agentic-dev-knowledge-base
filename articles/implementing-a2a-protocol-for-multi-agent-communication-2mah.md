---
title: "Implementing A2A Protocol for Multi-Agent Communication"
url: "https://dev.to/rapidclaw/implementing-a2a-protocol-for-multi-agent-communication-2mah"
author: "Tijo Gaucher"
category: "a2a-protocols"
---

# Implementing A2A Protocol for Multi-Agent Communication
**Author:** Tijo Gaucher
**Published:** April 18, 2026

## Overview
Practical implementation of Google's A2A protocol across OpenClaw and Hermes agents on Rapid Claw. Covers the envelope format, publishing agents as A2A endpoints, and three production patterns.

## Key Concepts

A2A standardizes the message envelope between independent agents. MCP handles agent-to-tool communication; A2A handles agent-to-agent communication. They compose cleanly because an A2A peer is essentially a tool with an agent on the other end.

### The Envelope Format

```python
envelope = {
    "a2a_version": "1.0",
    "message_id": f"msg_{uuid4().hex}",
    "correlation_id": "conv_01HZKXR7...",
    "trace": {
        "trace_id": "4bf92f3577b34da6...",
        "span_id": "00f067aa0ba902b7",
    },
    "sender": {"agent_id": "planner-openclaw-prod-01", "framework": "openclaw"},
    "recipient": {"agent_id": "executor-hermes-prod-03", "framework": "hermes"},
    "intent": "task.delegate",
    "payload": {
        "task": "summarize_and_file",
        "inputs": {"url": "https://example.com/report.pdf"},
        "constraints": {"max_tokens": 4000, "deadline_ms": 30000}
    },
    "reply_to": "https://agents.rapidclaw.dev/a2a/planner/inbox",
    "expires_at": "2026-04-18T12:34:56Z"
}
```

Three fields do the heavy lifting: `correlation_id` threads multi-agent conversations, `trace` carries OpenTelemetry-compatible span context, and `intent` is the verb recipients dispatch on.

### Publishing an OpenClaw Agent as A2A Endpoint

```python
from fastapi import FastAPI, HTTPException
from openclaw import Agent, Task
from a2a import Envelope, verify_signature, sign

app = FastAPI()
planner = Agent.from_config("planner.yaml")

@app.post("/a2a/inbox")
async def inbox(envelope: Envelope):
    if not verify_signature(envelope, allowed=TRUSTED_SIGNERS):
        raise HTTPException(401, "signature verification failed")

    if envelope.intent == "task.delegate":
        task = Task(
            name=envelope.payload["task"],
            inputs=envelope.payload["inputs"],
            trace=envelope.trace,
        )
        result = await planner.run(task)

        reply = Envelope(
            intent="result.return",
            correlation_id=envelope.correlation_id,
            trace=envelope.trace,
            sender={"agent_id": AGENT_ID, "framework": "openclaw"},
            recipient=envelope.sender,
            payload={"status": "ok", "result": result.to_dict()},
        )
        return sign(reply, PRIVATE_KEY).dict()
```

### Discovery by Label

```python
executor = await lookup(
    intent="task.execute",
    labels={"framework": "hermes", "env": "prod"},
)
```

### Three Patterns Worth Implementing

1. **Request/reply**: Planner calls executor, waits for reply. Use for sub-tasks with clear deadlines.
2. **Fan-out/fan-in**: Dispatches same intent to pool of executors in parallel, correlates replies by correlation_id. For research-agent ensembles.
3. **Async with callback**: Fires task.delegate with reply_to URL and returns immediately. Callee POSTs result.return when done.

### Production Platform Requirements
Registry for discovery, identity and mTLS per agent, routing with network policy, observability stitching traces across agents, per-agent rate limits.
