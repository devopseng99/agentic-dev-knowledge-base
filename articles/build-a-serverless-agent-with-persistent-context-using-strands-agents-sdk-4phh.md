---
title: "Build a serverless agent with persistent context using Strands Agents SDK"
url: "https://dev.to/aws-builders/build-a-serverless-agent-with-persistent-context-using-strands-agents-sdk-4phh"
author: "Davide De Sio"
category: "serverless-agents"
---

# Build a serverless agent with persistent context using Strands Agents SDK

**Author:** Davide De Sio
**Published:** June 16, 2025

## Overview
Implementing persistent user context across stateless AWS Lambda invocations using Strands Agents SDK with the `mem0_memory` tool for store, retrieve, and list operations.

## Code Examples

### Lambda Handler

```python
def memory(event: Dict[str, Any], _context) -> Any:
    user_id = event.get("user_id")
    action = event.get("action", "chat")
    content = event.get("content")

    if not user_id:
        return {"error": "Missing 'user_id' in payload."}

    memory_agent = Agent(
        system_prompt=SYSTEM_PROMPT,
        tools=[mem0_memory],
    )

    try:
        if action == "store":
            memory_agent.tool.mem0_memory(action="store", content=content, user_id=user_id)
        elif action == "retrieve":
            memory_agent.tool.mem0_memory(action="retrieve", content=content, user_id=user_id)
        elif action == "list":
            memory_agent.tool.mem0_memory(action="list", user_id=user_id)
        elif action == "chat":
            memory_agent(f"USER_ID:{user_id} - {content}")
        return {"result": "done"}
    except Exception as e:
        return {"error": str(e)}
```

### Serverless Framework Config

```yaml
service: serverless-memory-strands-agent
frameworkVersion: '3'
useDotenv: true
plugins:
  - serverless-python-requirements
provider:
  name: aws
  runtime: python3.12
  environment:
    MEM0_API_KEY: ${env:MEM0_API_KEY}
functions:
  memory:
    handler: src/agent/memory/handler.memory
    url: true
```

### Testing

```bash
sls invoke local -f memory --data \
  '{"content": "I like apples and grapefruit","action":"store","user_id":"1"}'

sls invoke local -f memory --data \
  '{"content":"What fruit do i like?","action":"chat","user_id":"1"}'
```

## Backend Options
1. **OpenSearch** - recommended for production AWS
2. **FAISS** - default local development (requires `faiss-cpu`)
3. **mem0.ai** - API-based platform

## Security Note
In production, `user_id` should be injected from trusted sources like AWS Cognito, not client payloads.
