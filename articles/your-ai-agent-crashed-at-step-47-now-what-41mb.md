---
title: "Your AI Agent Crashed at Step 47. Now What?"
url: "https://dev.to/george_belsky/your-ai-agent-crashed-at-step-47-now-what-41mb"
author: "George Belsky"
category: "multi-cloud-durable"
---

# Your AI Agent Crashed at Step 47. Now What?
**Author:** George Belsky
**Published:** March 27, 2026

## Overview
Addresses the critical problem of AI agents losing all state during multi-step crashes. Introduces the concept of the "Checkpoint Tax" -- unnecessary overhead code written solely for crash recovery -- and argues durability should be the default, not an afterthought.

## Key Concepts

Existing frameworks handle durability poorly: LangGraph requires explicit PostgreSQL configuration, CrewAI and Swarm offer no persistence, and raw Python demands manual checkpoint logic.

The AXME approach requires minimal code for durable agent execution:

```python
intent_id = client.send_intent({
    "intent_type": "intent.pipeline.process.v1",
    "to_agent": "agent://myorg/production/pipeline-agent",
    "payload": {...}
})
result = client.wait_for(intent_id)
```

Instead of opt-in persistence, durability should be built-in. Operations submitted to the platform guarantee completion regardless of crashes or restarts. The agent remains stateless while the platform maintains state in PostgreSQL.
