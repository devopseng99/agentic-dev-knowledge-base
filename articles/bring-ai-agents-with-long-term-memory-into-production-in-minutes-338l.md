---
title: "Bring AI Agents with Long-Term Memory into Production in Minutes"
url: "https://dev.to/aws/bring-ai-agents-with-long-term-memory-into-production-in-minutes-338l"
author: "Elizabeth Fuentes L"
category: "aws-agents"
---

# Bring AI Agents with Long-Term Memory into Production in Minutes
**Author:** Elizabeth Fuentes L
**Published:** October 22, 2025

## Overview
Tutorial on implementing cross-session memory for AI agents using Amazon Bedrock AgentCore. Solves "cross-session amnesia" where agents lose context across sessions. Combines two memory layers: AgentCore Runtime (short-term, 8 hours) and AgentCore Memory (long-term, cross-session). Covers configuration, implementation with Strands SDK, testing strategies (same-session and cross-session), and production deployment via `agentcore launch`.

## Key Concepts

### Memory Architecture
- **Runtime Memory:** Session-based, automatic, 8 hours or 15 min inactivity timeout
- **Long-term Memory:** Cross-session persistence, user-centric, intelligent retrieval
- **Asynchronous Extraction:** Background process, 1+ minutes for persistence

### Three Built-in Memory Strategies
1. **User Preferences:** Extracts choices, styles, preferences for personalization
2. **Semantic:** Identifies factual information about entities and events
3. **Session Summaries:** Condensed conversation summaries within sessions

### Configuration Components
- `AgentCoreMemoryConfig`: memory ID, session ID, actor ID, retrieval config
- `RetrievalConfig`: `top_k` (results count) + `relevance_score` (minimum threshold)
- `AgentCoreMemorySessionManager`: session lifecycle with memory integration

### Custom Headers for User ID
- Header: `X-Amzn-Bedrock-AgentCore-Runtime-Custom-Actor-Id`
- Enables user-specific memory namespacing
- Added via boto3 event handlers (normalized to lowercase)

## Code Examples

### Install Dependencies
```shell
git clone https://github.com/aws-samples/sample-getting-started-with-amazon-agentcore
cd 02-agentcore-memory
pip install -r requirements.txt
```

### Required Packages
```plaintext
bedrock-agentcore
strands-agents
strands-agents-tools
aws-opentelemetry-distro
```

### Memory Configuration and Agent Creation
```python
import os
from strands import Agent
from strands_tools import calculator
from bedrock_agentcore.runtime import BedrockAgentCoreApp
from bedrock_agentcore.memory.integrations.strands.config import AgentCoreMemoryConfig, RetrievalConfig
from bedrock_agentcore.memory.integrations.strands.session_manager import AgentCoreMemorySessionManager

app = BedrockAgentCoreApp()

MEMORY_ID = os.getenv("BEDROCK_AGENTCORE_MEMORY_ID")
REGION = os.getenv("AWS_REGION", "us-west-2")
MODEL_ID = os.getenv("MODEL_ID", "us.anthropic.claude-3-7-sonnet-20250219-v1:0")
CUSTOM_HEADER_NAME = 'x-amzn-bedrock-agentcore-runtime-custom-actor-id'

_agent = None

def get_or_create_agent(actor_id: str, session_id: str) -> Agent:
    global _agent

    if _agent is None:
        memory_config = AgentCoreMemoryConfig(
            memory_id=MEMORY_ID,
            session_id=session_id,
            actor_id=actor_id,
            retrieval_config={
                f"/users/{actor_id}/facts": RetrievalConfig(top_k=3, relevance_score=0.5),
                f"/users/{actor_id}/preferences": RetrievalConfig(top_k=3, relevance_score=0.5)
            }
        )

        _agent = Agent(
            model=MODEL_ID,
            session_manager=AgentCoreMemorySessionManager(memory_config, REGION),
            system_prompt="You are a helpful assistant with memory. Remember user preferences and facts across conversations.",
            tools=[calculator]
        )

    return _agent
```

### AgentCore Entry Point
```python
from bedrock_agentcore import BedrockAgentCoreApp, RequestContext

@app.entrypoint
def invoke(payload, context: RequestContext):
    if not MEMORY_ID:
        return {"error": "Memory not configured..."}

    actor_id = 'default-user'
    if context and hasattr(context, 'request_headers') and context.request_headers:
        actor_id = context.request_headers.get(
            'x-amzn-bedrock-agentcore-runtime-custom-actor-id',
            'default-user'
        )

    session_id = context.session_id if context else 'default-session'
    agent = get_or_create_agent(actor_id, session_id)

    prompt = payload.get("prompt", "Hello!")
    result = agent(prompt)

    return {"response": result.message.get('content', [{}])[0].get('text', str(result))}
```

### Short-term Memory Test (Same Session)
```python
import json, uuid, boto3

def test_short_memory(agent_arn, region=None):
    if not region:
        region = agent_arn.split(':')[3]

    client = boto3.client('bedrock-agentcore', region_name=region)
    session_id = str(uuid.uuid4())

    # Message 1 - establish context
    payload1 = json.dumps({"prompt": "My name is Alice and I like chocolate ice cream"}).encode()
    response1 = client.invoke_agent_runtime(
        agentRuntimeArn=agent_arn,
        runtimeSessionId=session_id,
        payload=payload1,
        qualifier="DEFAULT"
    )
    content1 = []
    for chunk in response1.get("response", []):
        content1.append(chunk.decode('utf-8'))
    result1 = json.loads(''.join(content1))

    # Message 2 - test recall (same session)
    payload2 = json.dumps({"prompt": "What is my name and what do I like?"}).encode()
    response2 = client.invoke_agent_runtime(
        agentRuntimeArn=agent_arn,
        runtimeSessionId=session_id,
        payload=payload2,
        qualifier="DEFAULT"
    )
```

### Long-term Memory Test (Cross-Session)
```python
import json, uuid, boto3, time

def test_long_memory(agent_arn, region=None):
    if not region:
        region = agent_arn.split(':')[3]

    client = boto3.client('bedrock-agentcore', region_name=region)
    event_system = client.meta.events

    session_1 = str(uuid.uuid4())
    session_2 = str(uuid.uuid4())
    user_1 = f"user-{str(uuid.uuid4())[:8]}"

    EVENT_NAME = 'before-sign.bedrock-agentcore.InvokeAgentRuntime'
    CUSTOM_HEADER_NAME = 'X-Amzn-Bedrock-AgentCore-Runtime-Custom-Actor-Id'

    def add_custom_runtime_header(request, **kwargs):
        request.headers.add_header(CUSTOM_HEADER_NAME, user_1)

    handler = event_system.register_first(EVENT_NAME, add_custom_runtime_header)

    # Session 1: Store user information
    # ... invoke with session_1

    # Wait for async memory extraction
    time.sleep(10)

    # Session 2: Test recall with different session, same user
    # ... invoke with session_2

    event_system.unregister(EVENT_NAME, handler)
```

### Deploy
```shell
agentcore configure -e my_agent_memory.py
agentcore launch
```

### Run Tests
```shell
python test_short_memory.py "AGENT_ARN"
python test_long_memory.py "AGENT_ARN"
```
