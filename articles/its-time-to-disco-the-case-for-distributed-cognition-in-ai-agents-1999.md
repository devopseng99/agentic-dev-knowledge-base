---
title: "It's Time to DisCo: The Case for Distributed Cognition in AI Agents"
url: "https://dev.to/amit_bhadoria_9d67cd7ea32/its-time-to-disco-the-case-for-distributed-cognition-in-ai-agents-1999"
author: "Amit Bhadoria"
category: "multi-cloud-durable"
---

# It's Time to DisCo: The Case for Distributed Cognition in AI Agents
**Author:** Amit Bhadoria
**Published:** December 18, 2025

## Overview
Argues that the ReAct Loop (single-threaded cognition) is fundamentally unscalable for the enterprise. Proposes DisCo (Distributed Cognition) as an architectural pattern decoupling Cognition from Control, with four pillars: Registry, Event Service, Tracker, and Memory.

## Key Concepts

The single-loop trap:

```python
while not goal_achieved:
    observation = env.observe()
    thought = llm.think(observation)
    action = llm.act(thought)
    env.step(action)
```

Two walls: the Human-in-the-Loop problem (agent halts waiting for approval, potentially for days) and Framework Bloat (the hard problem is orchestrating state across 50 agents in parallel, not prompting).

DisCo architecture: agents are long-lived services (not scripts), communication is asynchronous via Intent/Outcome publishing, state lives in a persistent Tracker (not Python memory).

Four pillars: Registry (service discovery for dynamic capability lookup), Event Service (choreography over orchestration using NATS/Kafka/Pub-Sub), Tracker (distributed state machine solving HITL by persisting state across approval waits), Memory (episodic and semantic memory as a managed service).

Reference implementation: Soorma (open-source) -- framework-agnostic, works with LangChain, CrewAI, raw OpenAI, or rule-based scripts.
