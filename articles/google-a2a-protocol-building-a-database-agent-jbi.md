---
title: "Google A2A Protocol: Building a Database Agent"
url: "https://dev.to/vishalmysore/google-a2a-protocol-building-a-database-agent-jbi"
author: "vishalmysore"
category: "cloud-agents"
---

# Google A2A Protocol: Building a Database Agent
**Author:** vishalmysore
**Published:** May 1, 2025

## Overview
Building an intelligent database agent using Google's A2A Protocol with Spring Java. Uses annotation-driven development (`@Agent`, `@Action`) to expose database operations as agent capabilities with auto-generated agent.json manifests and JSON-RPC request handling.

## Key Concepts

### Architecture Components
- **DerbyService**: `@Agent` and `@Action` annotations define capabilities declaratively
- **A2ADatabaseCardController**: Extends `RealTimeAgentCardController` for auto-generated `agent.json` manifest
- **DatabaseRpcController**: Extends `JsonRpcController` for JSON-RPC (tasks/send, tasks/get, tasks/cancel)
- **DBTaskController**: Extends `DyanamicTaskContoller` with custom callbacks for real-time status updates

### Task State Management
Supports granular states: SUBMITTED, WORKING, INPUT_REQUIRED, COMPLETED, CANCELED, FAILED, UNKNOWN

### Key Design
Decouples business logic from interaction logic. Annotation processing at runtime creates executable tasks triggered via natural language or API calls. Minimal boilerplate with full traceability through task state transitions.
