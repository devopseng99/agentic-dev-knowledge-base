---
title: "A2A Protocol Implementation"
url: "https://dev.to/heetvekariya/a2a-protocol-implementation-5b2m"
author: "HeetVekariya"
category: "a2a-protocols"
---

# A2A Protocol Implementation
**Author:** HeetVekariya
**Published:** May 10, 2025

## Overview
A practical walkthrough of implementing the Agent2Agent (A2A) Protocol using Google's official SDK. Covers Hello World agents, LangGraph Currency Exchange agents, and a UI for testing A2A agents locally.

## Key Concepts

The A2A protocol enables two primary functions: Agent Discovery and Inter-Agent Communication. The implementation follows a client-server model where agents run on backend servers and become discoverable by A2A clients.

### Hello World Agent

```shell
cd a2a-python-sdk/examples/helloworld
uv run main.py
```

This deploys the agent card and serves requests on port 9999.

Agent Response (Single):
```json
{
  "id": "1793ca2bc70045a5a458b75f2dea2b5c",
  "jsonrpc": "2.0",
  "result": {
    "messageId": "873a4f05-1220-430c-984e-610cbe16d4b6",
    "parts": [{"text": "Hello World", "type": "text"}],
    "role": "agent"
  }
}
```

Agent Response (Streamed):
```json
{
  "id": "33565729ffb344f29c946523437a1ef1",
  "jsonrpc": "2.0",
  "result": {
    "final": false,
    "messageId": "ed73f6bf-0dee-45a9-b921-9d4341603941",
    "parts": [{"text": "Hello ", "type": "text"}],
    "role": "agent"
  }
}
{
  "id": "33565729ffb344f29c946523437a1ef1",
  "jsonrpc": "2.0",
  "result": {
    "final": true,
    "messageId": "e9fed38b-3a8e-45a2-9836-4781a7d7f2a1",
    "parts": [{"text": "World", "type": "text"}],
    "role": "agent"
  }
}
```

### Agent Discovery Flow

1. Client fetches metadata via `GET /.well-known/agent.json`
2. After discovering the agent and its capabilities, it sends queries
3. Two request types: single JSON output and streamed output

### LangGraph Currency Exchange Agent

```shell
cd a2a-python-sdk/examples/langgraph
echo "GOOGLE_API_KEY=your-api-key" > .env
uv run __main__.py
```

Starts the agent on default port 10000 with multi-turn conversation support.

### UI for Agent2Agent Protocol

Located at `A2A/demo/ui`, launches on port 12000 for testing agents locally before production:

```shell
cd demo/ui
echo "GOOGLE_API_KEY=your-api-key" > .env
uv run main.py
```

Register agents by inserting their listening URLs (e.g., `http://localhost:9999`) in the agents tab.
