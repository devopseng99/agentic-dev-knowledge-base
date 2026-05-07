---
title: "Build an AI Math & Physics Agent with DeepSeek v3.2"
url: "https://dev.to/getstreamhq/build-an-ai-math-physics-agent-with-deepseek-v32-59dm"
author: "Sarah Lindauer"
category: "deepseek-ai-agent"
---

# Build an AI Math & Physics Agent with DeepSeek v3.2

**Author:** Sarah Lindauer
**Published:** December 10, 2025

## Overview
Build a voice-enabled math and physics tutoring agent using DeepSeek-V3.2 through OpenRouter with real-time audio/video streaming, text-to-speech, and intelligent turn detection.

## Key Concepts

### What You Build
- DeepSeek-V3.2 powered reasoning (via OpenRouter)
- Text-to-speech and speech-to-text (ElevenLabs)
- Real-time audio/video streaming (Stream)
- Intelligent turn detection (Smart-Turn)
- Vision Agents framework integration

### Step 1: Project Setup

```bash
uv init deepseek-physics-tutor
cd deepseek-physics-tutor

uv add vision-agents
uv add "vision-agents[getstream, openrouter, elevenlabs, smart-turn]"
```

### Step 2: Complete Code Implementation

```python
"""
DeepSeek V3.2 Maths and Physics Tutor
"""

import asyncio
import logging

from dotenv import load_dotenv

from vision_agents.core import User, Agent, cli
from vision_agents.core.agents import AgentLauncher
from vision_agents.plugins import (
    openrouter,
    getstream,
    elevenlabs,
    smart_turn,
)

logger = logging.getLogger(__name__)

load_dotenv()

async def create_agent(**kwargs) -> Agent:
    """Create the agent with OpenRouter LLM."""
    model = "deepseek/deepseek-v3.2-speciale"

    if "deepseek" in model.lower():
        personality = "Talk like a Maths and Physics tutor."
    elif "anthropic" in model.lower():
        personality = "Talk like a robot."
    elif "openai" in model.lower() or "gpt" in model.lower():
        personality = "Talk like a pirate."
    elif "gemini" in model.lower():
        personality = "Talk like a cowboy."
    elif "x-ai" in model.lower():
        personality = "Talk like a 1920s Chicago mobster."
    else:
        personality = "Talk casually."

    agent = Agent(
        edge=getstream.Edge(),
        agent_user=User(name="OpenRouter AI", id="agent"),
        instructions=f"""
        You are an expert in Maths and Physics. You help users solve Maths and Physics problems based on what they show you through their camera feed. Always provide concise and clear instructions, and explain the step-by-step process to the user so they can understand how you arrive at the final answer.
        {personality}
        """,
        llm=openrouter.LLM(model=model),
        tts=elevenlabs.TTS(),
        stt=elevenlabs.STT(),
        turn_detection=smart_turn.TurnDetection(
            pre_speech_buffer_ms=2000, speech_probability_threshold=0.9
        ),
    )

    return agent

async def join_call(agent: Agent, call_type: str, call_id: str, **kwargs) -> None:
    """Join the call and start the agent."""
    await agent.create_user()
    call = await agent.create_call(call_type, call_id)

    logger.info("Starting OpenRouter Agent...")

    with await agent.join(call):
        logger.info("Joining call")
        logger.info("LLM ready")
        await agent.edge.open_demo(call)
        await agent.finish()

if __name__ == "__main__":
    cli(AgentLauncher(create_agent=create_agent, join_call=join_call))
```

### Step 3: Environment Configuration

```bash
export OPENROUTER_API_KEY=sk-...
export ELEVENLABS_API_KEY=...
export STREAM_API_KEY=...
export STREAM_API_SECRET=...
export EXAMPLE_BASE_URL=https://pronto-staging.getstream.io
```

Execute with: `uv run main.py`

### Example Interaction
**User:** "Two forces of 8 N and 13 N act on an object at an angle of 25 degrees to each other. What is the magnitude of the resultant force?"
**Agent:** Uses the law of cosines: angle between vectors is 180 - 25 = 155 degrees, resultant force approximately 15.26 units.
