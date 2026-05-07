---
title: "Extending Pydantic AI Agents with Chat History"
url: "https://dev.to/hamluk/extending-pydantic-ai-agents-with-chat-history-messages-and-chat-history-in-pydantic-ai-d4f"
author: "Lukas Hamm"
category: "agent-sdks"
---

# Extending Pydantic AI Agents with Chat History
**Author:** Lukas Hamm
**Published:** November 6, 2025

## Overview
Implementing conversation memory in PydanticAI agents using message_history, session wrappers, persistence, and token-optimizing history processors.

## Key Concepts

### Session Wrapper
```python
class AgentSession:
    def __init__(self, agent):
        self.agent = agent
        self.history = []

    def run(self, query: str, deps) -> str:
        result = self.agent.run_sync(query, deps=deps, message_history=self.history)
        self.history.extend(result.new_messages())
        return result.output
```

### History Processor for Token Optimization
```python
async def keep_recent_messages(ctx: RunContext[TaskDependency], messages: list[ModelMessage]) -> list[ModelMessage]:
    if ctx.deps.username != "sudo":
        return messages[-5:] if len(messages) > 5 else messages
    return messages
```
