---
title: "How to Use Strands Agents' Built-In Session Persistence"
url: "https://dev.to/aws/til-strands-agents-has-built-in-session-persistence-3nhl"
author: "Dennis Traub"
category: "multi-cloud-durable"
---

# How to Use Strands Agents' Built-In Session Persistence
**Author:** Dennis Traub
**Published:** February 17, 2026

## Overview
The Strands Agents SDK includes integrated persistence for conversation history. Pass a SessionManager to the Agent constructor and every message and state change is persisted automatically through lifecycle hooks -- no manual save/load calls needed.

## Key Concepts

```python
from strands import Agent
from strands.session.file_session_manager import FileSessionManager

SESSION_ID = "user-abc-123"
STORAGE_DIR = "./sessions"

agent1 = Agent(
    model="global.anthropic.claude-haiku-4-5-20251001-v1:0",
    agent_id="assistant",
    session_manager=FileSessionManager(
        session_id=SESSION_ID, storage_dir=STORAGE_DIR
    ),
)
agent1("What's the capital of France?")

# Second instance - same session_id, loads conversation from disk
agent2 = Agent(
    model="global.anthropic.claude-haiku-4-5-20251001-v1:0",
    agent_id="assistant",
    session_manager=FileSessionManager(
        session_id=SESSION_ID, storage_dir=STORAGE_DIR
    ),
)
agent2("What did I just ask you?")  # Correctly recalls previous question
```

Three things get persisted: conversation history (messages/), agent state (agent.json), and session metadata (session.json). Built-in backends: FileSessionManager (local dev), S3SessionManager (production/distributed), RepositorySessionManager (custom backend).
