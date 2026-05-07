---
title: "A2A (Agent to Agent): Core Concepts"
url: "https://dev.to/farhan_khan_41ec7ff11ac1d/a2a-agent-to-agent-core-concepts-2gp2"
author: "Farhan Khan"
category: "a2a-protocols"
---

# A2A (Agent to Agent): Core Concepts
**Author:** Farhan Khan
**Published:** August 29, 2025

## Overview
Core concepts of the A2A Protocol: Agent Cards, Discovery Directory, Task Submission, and typed Messages with Parts.

## Key Concepts

### Agent Cards
JSON documents at `/.well-known/agent.json` with fields: id, endpoints, capabilities, auth, modalities.

### Discovery Directory
Registry service functioning as DNS + service registry for the agent ecosystem. Query by capability, version, or metadata.

### Task Submission (Async-First)
POST tasks to peer's `task_submit` endpoint, receive acknowledgment with status/event links. Track progress via SSE until terminal status.

### Messages & Parts
Typed payloads (text, JSON, images, file references) allowing heterogeneous agents to parse what they understand.

### Pattern: Composable Agent Microservices
Similar to microservices: generate idempotent task IDs, POST task payloads with auth headers, subscribe to SSE streams, parse artifacts on completion.
