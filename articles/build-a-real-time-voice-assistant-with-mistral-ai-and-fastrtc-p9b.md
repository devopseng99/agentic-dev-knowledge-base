---
title: "Build A Real-Time Voice Assistant with Mistral AI and FastRTC"
url: "https://dev.to/ifeanyi_idiaye_3f6d81ed8a/build-a-real-time-voice-assistant-with-mistral-ai-and-fastrtc-p9b"
author: "Ifeanyi Idiaye"
category: "mistral-ai-agent"
---

# Build A Real-Time Voice Assistant with Mistral AI and FastRTC

**Author:** Ifeanyi Idiaye
**Published:** March 9, 2025

## Overview
Build a real-time voice assistant using Mistral AI's LLM API and FastRTC, a Python library for real-time communication over WebRTC or WebSockets. The assistant converts speech to text, sends to Mistral, and streams the response back as audio.

## Key Concepts

### Installation

```bash
pip install mistalai fastrtc
```

### Environment Setup

```python
from mistralai import Mistral
from fastrtc import (ReplyOnPause, Stream, get_stt_model, get_tts_model)
from dotenv import load_dotenv
import os

load_dotenv()
```

### FastRTC Components
- **ReplyOnPause()** - Monitors audio, detects pauses as cue to reply
- **Stream()** - Streams the audio reply
- **get_stt_model()** - Access speech-to-text model
- **get_tts_model()** - Access text-to-speech model

### Core Voice Assistant Function

```python
api_key = os.environ["MISTRAL_API_KEY"]
model = "mistral-large-latest"
client = Mistral(api_key=api_key)

stt_model = get_stt_model()
tts_model = get_tts_model()

def echo(audio):
    prompt = stt_model.stt(audio)
    chat_response = client.chat.complete(
    model = model,
    messages = [
        {
            "role": "user",
            "content": f"{prompt}"
        },
      ]
    )

    for audio_chunk in tts_model.stream_tts_sync(chat_response.choices[0].message.content):
        yield audio_chunk

stream = Stream(ReplyOnPause(echo), modality="audio", mode="send-receive")
stream.ui.launch()
```

### Custom Voice with KokoroTTS

```python
from fastrtc import (ReplyOnPause, Stream, get_stt_model, get_tts_model, KokoroTTSOptions)

tts_model = get_tts_model(model="kokoro")

options = KokoroTTSOptions(
    voice="af_bella",
    speed=1.0,
    lang="en-us"
)
```

### Complete Project Code

```python
import os
from fastrtc import (ReplyOnPause, Stream, get_stt_model, get_tts_model, KokoroTTSOptions)
from dotenv import load_dotenv
from mistralai import Mistral

load_dotenv()

api_key = os.environ["MISTRAL_API_KEY"]
model = "mistral-large-latest"

client = Mistral(api_key=api_key)

options = KokoroTTSOptions(
    voice="af_bella",
    speed=1.0,
    lang="en-us"
)

stt_model = get_stt_model()
tts_model = get_tts_model(model="kokoro")

def echo(audio):
    prompt = stt_model.stt(audio)
    chat_response = client.chat.complete(
    model = model,
    messages = [
        {
            "role": "user",
            "content": f"{prompt}"
        },
      ]
    )

    for audio_chunk in tts_model.stream_tts_sync(chat_response.choices[0].message.content, options=options):
        yield audio_chunk

stream = Stream(ReplyOnPause(echo), modality="audio", mode="send-receive")
stream.ui.launch()
```
