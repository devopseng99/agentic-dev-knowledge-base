---
title: "Building a Voice-Enabled AI Coach with Real Esports Data"
url: "https://dev.to/hulyamasharipov/building-a-voice-enabled-ai-coach-with-real-esports-data-al4"
author: "Hulya"
category: "hackathons"
---

# Building a Voice-Enabled AI Coach with Real Esports Data
**Author:** Hulya
**Published:** January 28, 2026

## Overview
Zenith is an AI coaching tool analyzing professional League of Legends and VALORANT match data through conversational voice responses, using AWS Bedrock with Anthropic Claude fallback and GRID Esports API.

## Key Concepts

### Multi-Model Fallback
```python
async def get_coaching_response(self, prompt: str, context: dict) -> str:
    try:
        return await self.bedrock_client.invoke(prompt, context)
    except RateLimitError:
        return await self.anthropic_client.invoke(prompt, context)
```

### Pattern Detection
```python
class GankOutcome(Enum):
    SUCCESS_KILL = "success_kill"
    SUCCESS_FLASH = "success_flash"
    FAILURE_DEATH = "failure_death"
    FAILURE_COUNTER = "failure_counter"

class TimePeriod(Enum):
    PRE_6 = "pre_6"
    MID_GAME = "mid_game"
    LATE_GAME = "late_game"
```

### Voice Optimization
```python
if len(clean_text) > 500:
    truncated = clean_text[:500]
    last_period = truncated.rfind('.')
    if last_period > 300:
        clean_text = truncated[:last_period + 1]
```

Tech: Next.js 16, React 19, Python 3.12, FastAPI, AWS Bedrock, ElevenLabs turbo, GRID Esports API, PyCharm + Junie
