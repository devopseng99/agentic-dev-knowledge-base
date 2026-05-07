---
title: "Build real-time conversational agents with Gemini 3.1 Flash Live"
url: "https://dev.to/googleai/build-real-time-conversational-agents-with-gemini-31-flash-live-27f6"
author: "Thor Schaeff"
category: "gemini-api-agent"
---

# Build real-time conversational agents with Gemini 3.1 Flash Live

**Author:** Thor Schaeff
**Published:** March 26, 2026

## Overview
Launching Gemini 3.1 Flash Live via the Gemini Live API in Google AI Studio, enabling developers to build real-time voice and vision agents that process the world around them and respond at the speed of conversation. This is a step change in latency, reliability and more natural-sounding dialogue.

## Key Concepts

### Enhanced Latency, Reliability and Quality

- **Higher task completion rates in noisy environments:** Significantly improved ability to trigger external tools and deliver information during live conversations by better discerning relevant speech from environmental sounds.
- **Better instruction-following:** Adherence to complex system instructions has been boosted significantly. Agent stays within operational guardrails even when conversations take unexpected turns.
- **More natural and low-latency dialogue:** Improved latency and more effective recognition of acoustic nuances like pitch and pace.
- **Multi-lingual capabilities:** Supports more than 90 languages for real-time multi-modal conversations.

### Expanding Ecosystem of Integrations

The Live API is built for production environments. Partner integrations for WebRTC scaling or global edge routing include:

- LiveKit -- Use the Gemini Live API with LiveKit Agents
- Pipecat by Daily -- Create a real-time AI chatbot using Gemini Live and Pipecat
- Fishjam by Software Mansion -- Create live video and audio streaming applications
- Vision Agents by Stream -- Build real-time voice and video AI applications
- Voximplant -- Connect inbound and outbound calls to Live API
- Firebase AI SDK -- Get started with the Gemini Live API using Firebase AI Logic

### Getting Started with the Live API

```python
import asyncio
from google import genai

client = genai.Client(api_key="YOUR_API_KEY")

model = "gemini-3.1-flash-live-preview"
config = {"response_modalities": ["AUDIO"]}

async def main():
    async with client.aio.live.connect(model=model, config=config) as session:
        print("Session started")
        # Send content...

if __name__ == "__main__":
    asyncio.run(main())
```
