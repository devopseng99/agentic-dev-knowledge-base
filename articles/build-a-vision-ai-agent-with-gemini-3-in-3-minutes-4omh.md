---
title: "Build a Vision AI Agent with Gemini 3 in < 3 Minutes"
url: "https://dev.to/getstreamhq/build-a-vision-ai-agent-with-gemini-3-in-3-minutes-4omh"
author: "Sarah Lindauer"
category: "multimodal"
---

# Build a Vision AI Agent with Gemini 3 in < 3 Minutes

**Author:** Sarah Lindauer
**Published:** December 3, 2025
**Organization:** Stream

---

## Overview

Stream has introduced support for Google's Gemini 3 models within Vision Agents, an open-source Python framework for real-time voice and video AI applications. The article demonstrates how to create a fully functional vision-enabled voice agent in under three minutes.

---

## Key Takeaways

- Vision Agents enables quick deployment of AI agents that can see, reason, and communicate verbally
- Gemini 3 Pro Preview provides advanced multimodal understanding capabilities
- The implementation requires minimal setup and pure Python code
- The agent can analyze live video feeds from screens or webcams and respond naturally

---

## Getting Started (60 Seconds)

### Step 1: Initialize Project
```bash
uv init
uv venv && source .venv/bin/activate
```

### Step 2: Install Dependencies
```bash
uv add vision-agents
uv add "vision-agents[getstream, gemini, elevenlabs, deepgram, smart-turn]"
```

### Prerequisites
- Free Gemini API key from https://ai.google.dev
- Stream account from https://getstream.io/try-for-free/

---

## Minimal Working Example

```python
import asyncio
import logging

from dotenv import load_dotenv
from vision_agents.core import User, Agent, cli
from vision_agents.core.agents import AgentLauncher
from vision_agents.plugins import elevenlabs, getstream, smart_turn, gemini, deepgram

logger = logging.getLogger(__name__)

load_dotenv()

async def create_agent(**kwargs) -> Agent:
    """Create the agent with Gemini 3."""
    agent = Agent(
        edge=getstream.Edge(),
        agent_user=User(name="Friendly AI", id="agent"),
        instructions="You are a friendly AI assistant powered by Gemini 3. You are able to answer questions and help with tasks. You carefully observe a users' camera feed and respond to their questions and tasks.",
        tts=elevenlabs.TTS(),
        stt=deepgram.STT(),
        # Gemini 3 model
        llm=gemini.LLM("gemini-3-pro-preview"),
        turn_detection=smart_turn.TurnDetection(),
    )
    return agent

async def join_call(agent: Agent, call_type: str, call_id: str, **kwargs) -> None:
    """Join the call and start the agent."""
    # Ensure the agent user is created
    await agent.create_user()
    # Create a call
    call = await agent.create_call(call_type, call_id)

    logger.info("Starting Gemini AI Agent...")

    # Have the agent join the call/room
    with await agent.join(call):
        logger.info("Joining call")
        logger.info("LLM ready")

        await asyncio.sleep(5)
        await agent.llm.simple_response(text="Describe what you currently see")
        await agent.finish()  # Run till the call ends

if __name__ == "__main__":
    cli(AgentLauncher(create_agent=create_agent, join_call=join_call))
```

### Running the Agent
```bash
uv run gemini_vision_demo.py
```

Once launched, a Stream Video call opens in your browser. Grant permissions and request screen analysis with a command like: "Tell me what you see on my screen."

---

## Resources

- [Vision Agents GitHub Repository](https://github.com/GetStream/vision-agents)
- [Gemini Plugin on PyPI](https://pypi.org/search/?q=Vision+Agents)
- [Complete Documentation](https://visionagents.ai/integrations/gemini)
- [Stream Video Dashboard](https://getstream.io/video/)

---

## Summary

"Gemini 3 brings better reasoning and multimodal understanding" while Vision Agents simplifies building interactive voice and video experiences entirely through Python, eliminating the need for React or WebRTC boilerplate infrastructure.
