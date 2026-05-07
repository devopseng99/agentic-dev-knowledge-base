---
title: "Building Voice AI Agents with the OpenAI Agents SDK"
url: https://dev.to/cloudx/building-voice-ai-agents-with-the-openai-agents-sdk-2aog
author: Roman Piacquadio
category: ai-agents-voice
---

# Building Voice AI Agents with the OpenAI Agents SDK

**Author:** Roman Piacquadio
**Published:** May 5, 2025
**Series:** Working with Voice AI Agents (Part 2 of 4)

## Overview

This article explores OpenAI's approach to constructing voice agents using their Agents SDK, comparing it with the WebRTC/LiveKit methodology presented in the preceding article of the series.

## Key Concepts

### OpenAI's Agent Platform Primitives

OpenAI presents composable building blocks for agent construction:

- **Models:** GPT-4o and variants for reasoning and multimodal capabilities
- **Tools:** Function calling and external integrations
- **Knowledge & Memory:** Vector stores and embeddings
- **Audio & Speech:** Voice understanding and generation
- **Guardrails:** Safety and control mechanisms
- **Orchestration:** SDK, tracing, and evaluation tools

### Two Voice Agent Architectures

1. **Speech-to-Speech (Realtime API):** Direct audio processing via `gpt-4o-realtime-preview`, minimizing latency
2. **Chained (Agents SDK + Voice):** Traditional STT -> LLM -> TTS pipeline with greater transparency and control

*The article focuses on the chained architecture.*

## Core SDK Components

The `openai-agents` SDK includes:

- **Agent:** LLM with instructions, tools, and handoff capabilities
- **Runner:** Executes agent logic and manages tool execution
- **@function_tool:** Decorator exposing Python functions to agents
- **VoicePipeline:** Handles STT and TTS integration
- **Handoffs:** Enables agent-to-agent delegation

## Architecture Flow

```
Microphone -> VoicePipeline (STT) -> Agent Workflow
(Runner + Agent + Tools + Handoffs) -> VoicePipeline (TTS) -> Speaker
```

## Code Example Structure

### Tool Definition
```python
@function_tool
def get_weather(city: str) -> str:
    """Get the weather for a given city."""
    choices = ["sunny", "cloudy", "rainy", "snowy"]
    return f"The weather in {city} is {random.choice(choices)}."
```

### Agent Configuration
```python
agent = Agent(
    name="Assistant",
    instructions=prompt_with_handoff_instructions(
        "Be polite and concise. Hand off to spanish_agent for Spanish requests."
    ),
    model="gpt-4.1",
    handoffs=[spanish_agent],
    tools=[get_weather],
)
```

### Workflow Implementation
```python
class MyWorkflow(VoiceWorkflowBase):
    async def run(self, transcription: str) -> AsyncIterator[str]:
        self._input_history.append({"role": "user", "content": transcription})
        result = Runner.run_streamed(self._current_agent, self._input_history)
        async for chunk in VoiceWorkflowHelper.stream_text_from(result):
            yield chunk
        self._input_history = result.to_input_list()
        self._current_agent = result.last_agent
```

## Comparison: OpenAI SDK vs. LiveKit Agents

| Feature | OpenAI SDK | LiveKit |
|---------|-----------|---------|
| **Latency** | Higher (chained API calls) | Lower (WebRTC optimized) |
| **Setup Complexity** | Lower | Higher (requires LiveKit server) |
| **STT/TTS Flexibility** | Limited to OpenAI | Plugin-based (multiple providers) |
| **Interruption Handling** | Manual implementation | Built-in VAD support |
| **Handoff Style** | Declarative | Imperative |
| **Scalability** | API-dependent | WebRTC infrastructure |

## Selection Criteria

**Choose OpenAI SDK when:**

- Working primarily within OpenAI ecosystem
- Accepting higher latency tolerance
- Preferring simpler initial setup
- Needing text transcript transparency
- Starting with text-based logic adding voice

**Choose LiveKit when:**

- Minimizing latency is critical
- Requiring robust interruption handling
- Needing provider flexibility
- Building "room"-based applications
- Prioritizing scalability for concurrent connections

## Key Takeaway

The OpenAI Agents SDK provides an accessible entry point for developers already invested in OpenAI's tooling, emphasizing "Python-first orchestration" with declarative agent definition. However, applications demanding minimal latency, seamless barge-in capabilities, and maximum flexibility benefit from WebRTC-based frameworks. The optimal choice depends on specific project requirements and tolerance for infrastructure complexity.
