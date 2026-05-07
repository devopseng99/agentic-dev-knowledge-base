---
title: "The 8 Best Platforms To Build Voice AI Agents"
url: "https://dev.to/getstreamhq/the-8-best-platforms-to-build-voice-ai-agents-4oel"
author: "Sarah Lindauer"
category: "voice-agents"
---

# The 8 Best Platforms To Build Voice AI Agents

**Author:** Sarah Lindauer
**Published:** March 3, 2026
**Organization:** Stream

---

## Article Overview

This comprehensive guide explores platforms for building voice-enabled AI agents that provide real-time conversational experiences. The article defines voice agents as "conversational AI assistant[s] capable of taking user instructions and responding with a human-like voice."

---

## What Is an AI Voice Agent?

Voice agents represent conversational AI systems that process spoken input and deliver audio responses using local or cloud-based language models. The article compares this functionality to ChatGPT's voice mode.

### Why Build a Voice Agent?

Primary use cases include:
- **Video AI:** Screen sharing and object recognition (e.g., Gemini Live)
- **Sales:** Customer follow-up and lead generation
- **Customer Support:** Call center automation
- **Personal Assistance:** Device interaction and appointment scheduling
- **Social Platforms:** Real-time voice responses
- **Gaming:** Character dialogue systems
- **Telecare:** Patient information collection

---

## The 8 Platforms

### 1. Stream Python AI SDK

**Key Features:**
- Multi-platform support (React, Swift, Android, Flutter, JavaScript, Python)
- Transcription, voice activity detection, and speech conversion
- Integration with OpenAI, Cartesia, Deepgram, and ElevenLabs
- WebRTC and OpenAI Real-Time API foundation

**Getting Started:**

```bash
python3 -m venv venv && source venv/bin/activate
```

Environment configuration (`.env`):
```
STREAM_API_KEY=your-stream-api-key
STREAM_API_SECRET=your-stream-api-secret
STREAM_BASE_URL=https://pronto.getstream.io/
OPENAI_API_KEY=sk-your-openai-api-key
```

Installation:
```bash
pip install --pre "getstream[plugins]"
# or using uv
uv add "getstream[plugins]" --prerelease=allow
```

**Client Initialization (Python):**

```python
from dotenv import load_dotenv
from getstream import Stream
from getstream.models import UserRequest
from uuid import uuid4

load_dotenv()
client = Stream.from_env()

user_id = f"user-{uuid4()}"
client.upsert_users(UserRequest(id=user_id, name="My User"))
user_token = client.create_token(user_id, expiration=3600)

bot_user_id = f"openai-realtime-speech-to-speech-bot-{uuid4()}"
client.upsert_users(UserRequest(id=bot_user_id, name="OpenAI Realtime Bot"))

call_id = str(uuid4())
call = client.video.call("default", call_id)
call.get_or_create(data={"created_by_id": bot_user_id})
```

**Speech-to-Speech Pipeline:**

```python
from getstream.plugins import OpenAIRealtime

sts_bot = OpenAIRealtime(
    model="gpt-4o-realtime-preview",
    instructions="You are a friendly assistant; reply concisely.",
    voice="alloy",
)

try:
    async with await sts_bot.connect(call, agent_user_id=bot_user_id) as connection:
        await sts_bot.send_user_message("Give a very short greeting to the user.")
except Exception as e:
    # Handle exception
finally:
    client.delete_users([user_id, bot_user_id])
```

---

### 2. OpenAI

**Capabilities:**
- Python Agents SDK and TypeScript SDK
- Multiple voice options (Alloy, Ash, Coral, Echo, Fable, Onyx, Nova, Sage, Shimmer)
- Realtime API with WebRTC or WebSockets support
- Tools, guardrails, agent handoff features
- Session management

**Getting Started (JavaScript/TypeScript):**

```javascript
import { RealtimeAgent, RealtimeSession } from '@openai/agents/realtime';

const agent = new RealtimeAgent({
  name: 'Assistant',
  instructions: 'You are a helpful assistant.',
});

const session = new RealtimeSession(agent);

await session.connect({
  apiKey: '<client-api-key>',
});
```

---

### 3. ElevenLabs

**Strengths:**
- Voice cloning, isolation, swapping capabilities
- Eleven V3 model for realistic text-to-speech
- Multi-language support

**Python Example:**

```python
from dotenv import load_dotenv
from elevenlabs.client import ElevenLabs
from elevenlabs import play
import os

load_dotenv()

elevenlabs = ElevenLabs(
  api_key=os.getenv("ELEVENLABS_API_KEY"),
)

audio = elevenlabs.text_to_speech.convert(
    text="The first move is what sets everything in motion.",
    voice_id="JBFqnCBsd6RMkjVDRZzb",
    model_id="eleven_multilingual_v2",
    output_format="mp3_44100_128",
)

play(audio)
```

---

### 4. Deepgram

**Features:**
- Text-to-speech, speech-to-speech, and speech-to-text models
- API playground for experimentation
- SDKs for Python, JavaScript, C#, and Go

**Setup:**

```bash
mkdir deepgram-agent-demo
cd deepgram-agent-demo
export DEEPGRAM_API_KEY="your_Deepgram_API_key_here"
pip install deepgram-sdk
```

---

### 5. Vapi

**Highlights:**
- Assistants for simple conversational services
- Workflows for complex multi-step processes
- Phone number integration for call operations
- 100+ language support

**React Implementation:**

```jsx
import Vapi from "@vapi-ai/web";
import { useState, useEffect } from "react";

export const vapi = new Vapi("YOUR_PUBLIC_API_KEY");

function VapiAssistant() {
  const [callStatus, setCallStatus] = useState("inactive");

  const start = async () => {
    setCallStatus("loading");
    await vapi.start("YOUR_ASSISTANT_ID");
  };

  const stop = () => {
    setCallStatus("loading");
    vapi.stop();
  };

  useEffect(() => {
    vapi.on("call-start", () => setCallStatus("active"));
    vapi.on("call-end", () => setCallStatus('inactive'));
    return () => vapi.removeAllListeners();
  }, [])

  return (
    <div>
      {callStatus === "inactive" ? (<button onClick={start}>Start</button>) : null}
      {callStatus === "loading" ? <i>Loading...</i> : null}
      {callStatus === "active" ? (<button onClick={stop}>Stop</button>) : null}
    </div>
  );
}
```

---

### 6. Play.ai

**Features:**
- Web and mobile voice app creation
- PlayNote feature for converting files to audio
- Extensive voice library

**API Call (Bash):**

```bash
curl -X POST 'https://api.play.ai/api/v1/tts/stream' \
  -H "Authorization: Bearer $PLAYAI_KEY" \
  -H "Content-Type: application/json" \
  -H "X-USER-ID: $PLAYAI_USER_ID" \
  -d '{
    "model": "PlayDialog",
    "text": "Hello! This is my first text-to-speech audio using PlayAI!",
    "voice": "s3://voice-cloning-zero-shot/baf1ef41-36b6-428c-9bdf-50ba54682bd8/original/manifest.json",
    "outputFormat": "wav"
  }'
```

---

### 7. Pipecat

**Capabilities:**
- Open-source framework for conversational AI
- Complex dialog systems and customer support agents
- Multimodal interactions (video, voice, images)
- Client SDKs for Web, iOS, Android, and C++

**Installation:**

```bash
pip install pipecat-ai
cp dot-env.template .env
```

---

### 8. Cartesia

**Strengths:**
- Developer-first platform
- 15+ language support
- Integration with LiveKit, Vapi, and Pipecat
- Sonic text-to-speech model

**API Call (cURL):**

```bash
curl -N -X POST "https://api.cartesia.ai/tts/bytes" \
        -H "Cartesia-Version: 2024-11-13" \
        -H "X-API-Key: YOUR_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{"transcript": "Welcome to Cartesia Sonic!", "model_id": "sonic-2", "voice": {"mode":"id", "id": "694f9389-aac1-45b6-b726-9d9369183238"}, "output_format":{"container":"wav", "encoding":"pcm_f32le", "sample_rate":44100}}' > sonic-2.wav
```

---

## Other Notable Platforms

- **LiveKit:** Video infrastructure platform
- **Kokoro TTS:** Hugging Face-hosted text-to-speech
- **Moonshine:** Open-source speech recognition
- **Bland AI, Retell AI, Synthflow AI:** Phone call operations
- **Chatterbox TTS:** Open-source text-to-speech

---

## Future Outlook

The article notes current limitations include high latencies and difficulty understanding voices in noisy environments. Future improvements will focus on interruption handling, noise detection, and reduced latency in speech interactions.
