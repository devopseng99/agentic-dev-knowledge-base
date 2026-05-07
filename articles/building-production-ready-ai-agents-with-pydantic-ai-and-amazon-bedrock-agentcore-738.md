---
title: "Building Production-Ready AI Agents with Pydantic AI and Amazon Bedrock AgentCore"
url: "https://dev.to/aws/building-production-ready-ai-agents-with-pydantic-ai-and-amazon-bedrock-agentcore-738"
author: "Danilo Poccia"
category: "ai-agents"
---

# Building Production-Ready AI Agents with Pydantic AI and Amazon Bedrock AgentCore

**Author:** Danilo Poccia
**Published:** September 15, 2025
**Tags:** #ai #bedrock #aws #agentcore

## Overview

This article is part 4 of a 6-part series on constructing production-grade AI agents across multiple frameworks. The piece demonstrates implementing type-safe agents using Pydantic AI and deploying them via Amazon Bedrock AgentCore.

## Key Concepts

### Why Pydantic AI?

Pydantic AI brings validation capabilities from Python's most popular data validation library to agent development. The framework emphasizes:

- **Type safety** with automatic validation
- **Minimalist architecture** focused on structured outputs
- **Clear data contracts** preventing unpredictable LLM behaviors
- **Built-in error handling** for type mismatches

## Development Setup

```bash
git clone https://github.com/danilop/agentcore-multi-framework-examples.git
cd agentcore-pydantic-ai
uv sync
source .venv/bin/activate
```

**Key dependencies:**
- `pydantic-ai-slim[bedrock]` - Core framework with Bedrock integration
- `bedrock-agentcore` - SDK for AgentCore services
- `bedrock-agentcore-starter-toolkit` - CLI deployment tools

## Architecture: Three-Level Memory System

The implementation combines three memory layers:

1. **Session Message History** - Pydantic AI maintains conversation flow within current sessions
2. **Conversation History** - AgentCore retrieves previous interactions via `get_last_k_turns()`
3. **Semantic Memory** - Searches across stored memories using `retrieve_memories()`

## Code Implementation

### Message History Management

```python
from pydantic_ai import Agent

session_message_history = {}  # Dict[session_id, List[ModelMessage]]

@app.entrypoint
def invoke(payload: Dict[str, Any], context: Optional[RequestContext] = None) -> str:
    session_id = context.session_id if context and context.session_id else payload.get("session_id", DEFAULT_SESSION_ID)

    if session_id not in session_message_history:
        session_message_history[session_id] = []

    current_message_history = session_message_history[session_id]
```

### Memory Context Integration

```python
memory_context = memory_manager.get_memory_context(
    user_input=prompt or "",
    actor_id=actor_id,
    session_id=session_id
)

enhanced_prompt = prompt or "Hello"
if memory_context:
    enhanced_prompt = f"{memory_context}\n\nUser: {enhanced_prompt}"
```

### Agent Execution

```python
agent = Agent(MODEL, instructions='Be concise, reply with one sentence.')
result = agent.run_sync(enhanced_prompt, message_history=current_message_history)

# Store new messages in memory
new_messages = result.all_messages()[len(current_message_history):]
if new_messages:
    store_pydantic_messages_in_memory(new_messages, memory_manager, actor_id, session_id)

# Update session history (keep last 30 messages)
session_message_history[session_id] = result.all_messages()[-NUM_MESSAGES:]

return result.output
```

### AgentCore Runtime Integration

```python
from bedrock_agentcore import BedrockAgentCoreApp
from bedrock_agentcore.runtime.context import RequestContext

app = BedrockAgentCoreApp()

@app.entrypoint
def invoke(payload: Dict[str, Any], context: Optional[RequestContext] = None) -> str:
    # Process request with memory and agent execution
    # Return string response
    return result.output

if __name__ == "__main__":
    app.run()
```

### Message Conversion for Storage

```python
def convert_pydantic_messages_for_storage(messages: List[Any]) -> List[tuple]:
    """Convert Pydantic AI ModelMessage objects to storage format."""
    messages_to_store = []

    for msg in messages:
        if hasattr(msg, 'parts') and msg.parts:
            for part in msg.parts:
                if hasattr(part, 'content'):
                    content = part.content

                    if hasattr(msg, 'kind'):
                        if msg.kind == 'request':
                            role = 'USER' if part.part_kind == 'user-prompt' else 'SYSTEM'
                        elif msg.kind == 'response':
                            role = 'ASSISTANT'

                    messages_to_store.append((content, role))

    return messages_to_store
```

## Testing & Deployment

### Local Testing

```bash
agentcore configure -n pydanticaiagent -e main.py
agentcore launch --local
agentcore invoke --local '{ "prompt": "What did I say about fruit?" }'
```

### Production Deployment

```bash
agentcore launch
agentcore status
agentcore invoke '{ "prompt": "What did I say about fruit?" }'
aws logs tail /aws/bedrock-agentcore/runtimes/<AGENT_ID-ENDPOINT_ID> --follow
```

### Cleanup

```bash
agentcore destroy
aws bedrock-agentcore-control delete-memory --memory-id <MEMORY_ID>
```

## Key Takeaways

- **Simplicity with power**: "There's no magic, no hidden complexity--just clean Python code with predictable behavior"
- **Shared architecture**: Memory created by Pydantic AI agents remains accessible to agents built with other frameworks
- **Infrastructure abstraction**: AgentCore Runtime handles scaling, session management, and error handling transparently
- **Message history limits**: Capping at 30 messages prevents unbounded growth and manages token usage
- **Type-safe validation**: Pydantic models automatically validate and structure agent outputs

## Next Steps

The series continues with LlamaIndex, exploring advanced retrieval capabilities and knowledge management for document-heavy applications.
