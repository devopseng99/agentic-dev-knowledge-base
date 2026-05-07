---
title: "Building Multi-Agent Conversations with WebRTC & LiveKit"
url: "https://dev.to/cloudx/building-multi-agent-conversations-with-webrtc-livekit-48f1"
author: "Roman Piacquadio"
category: "multi-agent-frameworks"
---

# Building Multi-Agent Conversations with WebRTC & LiveKit

**Author:** Roman Piacquadio
**Organization:** Cloud(x);
**Published:** April 10, 2025
**Last Updated:** May 5, 2025
**Tags:** #ai #voiceai #agents #openai

---

## Overview

This article explores designing sophisticated multi-stage voice AI interactions using WebRTC and the LiveKit Agents framework. Rather than simple question-answer bots, the approach enables multiple specialized AI agents to collaborate within a single conversational session, handling handoffs and shared state seamlessly.

## Problem Statement

Traditional STT -> LLM -> TTS API chains face significant limitations:

- **Latency Issues:** Sequential API calls accumulate delays between turns
- **Cost Concerns:** Multiple API requests per interaction multiply expenses
- **State Management Complexity:** Maintaining conversation history across different logical stages becomes difficult
- **Scalability Bottlenecks:** Single backend processes struggle with concurrent users and complex logic
- **Interaction Limitations:** Difficulty handling interruptions or smooth transitions between goals

## Solution Architecture

**WebRTC** provides direct, low-latency audio/video streaming between participants. **LiveKit** builds on this foundation with:

- Room management and participant signaling
- Optimized media streaming infrastructure
- The `livekit-agents` Python framework for voice AI orchestration
- Support for multiple agents within a single session with built-in handoff mechanisms

## Multi-Agent Flow Pattern

1. **Session Initialization:** User connects to LiveKit room; `AgentSession` created with shared `userdata`
2. **Agent 1 Execution:** First agent (e.g., IntroAgent) gathers specific information via voice
3. **Handoff Trigger:** LLM function call identifies completion; updates shared state
4. **Agent 2 Activation:** Next agent (e.g., StoryAgent) receives context and takes over interaction
5. **Continuation/Termination:** Subsequent agents process or conclude the session

## Code Implementation: Multi-Agent Storyteller

### Prerequisites

```bash
pip install "livekit-agents[openai,silero,deepgram]~=1.0rc" python-dotenv
```

### Environment Configuration

```ini
LIVEKIT_URL="wss://YOUR_PROJECT_URL.livekit.cloud"
LIVEKIT_API_KEY="YOUR_LK_API_KEY"
LIVEKIT_API_SECRET="YOUR_LK_API_SECRET"
OPENAI_API_KEY="sk-..."
DEEPGRAM_API_KEY="..."
```

### Core Components

**Shared State Definition:**

```python
from dataclasses import dataclass
from typing import Optional

@dataclass
class StoryData:
    name: Optional[str] = None
    location: Optional[str] = None
```

**IntroAgent Implementation:**

```python
from livekit.agents import Agent, RunContext
from livekit.agents.llm import function_tool

class IntroAgent(Agent):
    def __init__(self) -> None:
        super().__init__(
            instructions="Your name is Echo. Gather user name and location to personalize a story."
        )

    async def on_enter(self):
        self.session.generate_reply()

    @function_tool
    async def information_gathered(
        self,
        context: RunContext[StoryData],
        name: str,
        location: str,
    ):
        """Captures gathered information and triggers handoff."""
        context.userdata.name = name
        context.userdata.location = location

        story_agent = StoryAgent(name, location)
        return story_agent, "Let's start the story!"
```

**StoryAgent with Model Override:**

```python
from livekit.plugins import openai

class StoryAgent(Agent):
    def __init__(self, name: str, location: str, *, chat_ctx = None) -> None:
        super().__init__(
            instructions=f"Tell an interactive story incorporating {name} from {location}.",
            llm=openai.realtime.RealtimeModel(voice="echo"),
            tts=None,
            chat_ctx=chat_ctx,
        )

    async def on_enter(self):
        self.session.generate_reply()

    @function_tool
    async def story_finished(self, context: RunContext[StoryData]):
        """Concludes conversation and terminates session."""
        self.session.interrupt()
        await self.session.generate_reply(
            instructions=f"Say goodbye to {context.userdata.name}",
            allow_interruptions=False
        )
        job_ctx = get_current_job_context()
        await job_ctx.api.room.delete_room(
            api.DeleteRoomRequest(room=job_ctx.room.name)
        )
```

**Session Initialization:**

```python
from livekit.agents import AgentSession, JobContext
from livekit.plugins import deepgram, silero

async def entrypoint(ctx: JobContext):
    await ctx.connect()

    session = AgentSession[StoryData](
        vad=ctx.proc.userdata["vad"],
        llm=openai.LLM(model="gpt-4o-mini"),
        stt=deepgram.STT(model="nova-3"),
        tts=openai.TTS(voice="echo"),
        userdata=StoryData(),
    )

    await session.start(
        agent=IntroAgent(),
        room=ctx.room,
    )
```

## Key Advantages

- **Modularity:** Each agent focuses on specific tasks with independent instructions and model configurations
- **Clean State Pattern:** The `userdata` structure provides explicit shared information management
- **Elegant Handoffs:** Function tools create natural transition mechanisms between conversational stages
- **Low Latency:** Maintains real-time streaming benefits through WebRTC foundation
- **Mix-and-Match Models:** Different STT/TTS/LLM providers per agent (standard or real-time APIs)
- **Enterprise Scalability:** Built on production-grade LiveKit infrastructure

## Resources

- [LiveKit Agents Documentation](https://docs.livekit.io/agents)
- [Multi-Agent Example Repository](https://github.com/livekit/agents/blob/dev-1.0/examples/voice_agents/multi_agent.py)
- [Agent Playground Client](https://github.com/livekit/agents-playground/tree/main)
- [LiveKit Cloud Sign-Up](https://cloud.livekit.io)

---

**Key Takeaway:** This approach transforms voice AI from simple request-response interactions into sophisticated multi-stage conversations where specialized agents collaborate seamlessly through shared state and elegant handoff mechanisms.
