---
title: "Stop Paying for Vapi/Retell: Run your own AI Voice Agent in Python"
url: https://dev.to/blackdwarf/stop-paying-for-vapiretell-run-your-own-ai-voice-agent-in-python-1n4
author: BLACKDWARF
category: ai-agents-voice
---

# Stop Paying for Vapi/Retell: Run your own AI Voice Agent in Python

**Author:** BLACKDWARF
**Published:** May 3, 2026
**Modified:** May 3, 2026
**Tags:** #ai #framework #python #voiceai

---

## Overview

The article introduces Siphon, an open-source Apache 2.0 Python framework that enables developers to build voice AI agents without expensive third-party services. As the author states, "Building AI calling agents shouldn't require a commercial license or massive per-minute markups."

## Prerequisites

- Python 3.10+
- Twilio or Telnyx SIP Trunk
- LiveKit Credentials
- OpenAI API Key

---

## Step 1: Installation & Setup

Install via pip:

```bash
pip install siphon-ai
```

Create a `.env` file with required credentials:

```env
LIVEKIT_URL=wss://your-project.livekit.cloud
LIVEKIT_API_KEY=your_livekit_key
LIVEKIT_API_SECRET=your_livekit_secret
OPENAI_API_KEY=sk-yourkey
DEEPGRAM_API_KEY=yourkey
FROM_NUMBER=+15551234567
SIP_USERNAME=your_sip_user
SIP_PASSWORD=your_sip_pass
```

---

## Step 2: Defining the Agent

Use Siphon's plugin architecture to define agent behavior:

```python
from siphon.agent import Agent
from siphon.plugins import openai, cartesia, deepgram

agent = Agent(
    agent_name="Receptionist",
    llm=openai.LLM(),
    tts=cartesia.TTS(),
    stt=deepgram.STT(),
    system_instructions="You are a helpful dental receptionist. Help the user book an appointment."
)
```

---

## Step 3: Triggering Outbound Calls

Initiate SIP calls programmatically:

```python
import os
from dotenv import load_dotenv
from siphon.telephony.outbound import Call

load_dotenv()

call = Call(
    agent_name="Receptionist",
    sip_trunk_setup={
        "name": "telnyx-primary",
        "sip_address": "sip.telnyx.com",
        "sip_number": os.getenv("FROM_NUMBER"),
        "sip_username": os.getenv("SIP_USERNAME"),
        "sip_password": os.getenv("SIP_PASSWORD"),
    },
    number_to_call="+15550200",
)

call.start()
```

---

## Step 4: Handling Interruptions

The framework supports natural interruption handling through "voice activity detection," enabling users to interrupt the agent's speech seamlessly.

---

## Key Resources

- **GitHub:** https://github.com/blackdwarftech/siphon
- **Documentation:** https://siphon.blackdwarf.in/docs

---

## Key Takeaway

Siphon eliminates middleman fees by connecting directly to provider APIs, allowing developers to self-host voice agents with sub-500ms latency on their own infrastructure.
