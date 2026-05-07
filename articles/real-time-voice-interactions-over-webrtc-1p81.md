---
title: "Real-Time Voice Interactions over WebRTC"
url: https://dev.to/ag2ai/real-time-voice-interactions-over-webrtc-1p81
author: Mark Sze, Tvrtko Sternak, Davor Runje, Davorin Rusevljan
category: ai-agents-voice
---

# Real-Time Voice Interactions over WebRTC

**Authors:** Mark Sze, Tvrtko Sternak, Davor Runje, Davorin Rusevljan
**Published:** January 14, 2025
**Organization:** AG2

---

## Overview

This article demonstrates building real-time voice applications using WebRTC technology integrated with the RealtimeAgent framework. The approach leverages OpenAI's Realtime API to enable seamless, low-latency audio communication directly from web browsers.

## Why WebRTC?

WebRTC offers several advantages for real-time voice applications:

- **Low Latency:** "WebRTC's peer-to-peer design minimizes latency, ensuring natural, fluid conversations"
- **Adaptive Quality:** Dynamically adjusts audio based on network conditions
- **Secure by Design:** Uses DTLS and SRTP encryption protocols
- **Widely Supported:** Available across all major modern browsers

## Architecture Overview

The system uses a three-step process:

1. **Ephemeral Key Request:** Browser connects to backend via WebSockets to obtain a short-lived API key from OpenAI (expires after one minute)
2. **WebRTC Initialization:** Browser captures microphone input and establishes peer connection
3. **Real-time Communication:** Audio streams and DataChannel events flow between browser and OpenAI API

## Implementation Example: Voice-Enabled Translator

### Setup Instructions

**Clone Repository:**
```bash
git clone https://github.com/ag2ai/realtime-agent-over-webrtc.git
cd realtime-agent-over-webrtc
```

**Configure Environment:**
```bash
cp OAI_CONFIG_LIST_sample OAI_CONFIG_LIST
# Update api_key with your OpenAI credentials (must begin with sk-proj)
```

**Install Dependencies:**
```bash
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
```

**Start Server:**
```bash
uvicorn realtime_over_webrtc.main:app --port 5050
```

Access the application at `localhost:5050/start-chat`

### Client-Side WebRTC Code

**WebSocket Initialization:**
```javascript
ws = new WebSocket(webSocketUrl);

ws.onmessage = async event => {
    const message = JSON.parse(event.data);
    if (message.type === "ag2.init") {
        await openRTC(message.config);
        return;
    }
    if (dc) {
        dc.send(JSON.stringify(message));
    }
};
```

**WebRTC Setup:**
```javascript
async function openRTC(data) {
    const EPHEMERAL_KEY = data.client_secret.value;

    // Configure audio playback
    const audioEl = document.createElement("audio");
    audioEl.autoplay = true;
    pc.ontrack = e => audioEl.srcObject = e.streams[0];

    // Add microphone input
    const ms = await navigator.mediaDevices.getUserMedia({ audio: true });
    pc.addTrack(ms.getTracks()[0]);

    // Create DataChannel for events
    dc = pc.createDataChannel("oai-events");
    dc.addEventListener("message", e => {
        const message = JSON.parse(e.data);
        if (message.type.includes("function")) {
            ws.send(e.data);
        }
    });

    // SDP handshake with OpenAI
    const offer = await pc.createOffer();
    await pc.setLocalDescription(offer);

    const baseUrl = "https://api.openai.com/v1/realtime";
    const sdpResponse = await fetch(`${baseUrl}?model=${data.model}`, {
        method: "POST",
        body: offer.sdp,
        headers: {
            Authorization: `Bearer ${EPHEMERAL_KEY}`,
            "Content-Type": "application/sdp"
        },
    });

    const answer = { type: "answer", sdp: await sdpResponse.text() };
    await pc.setRemoteDescription(answer);
}
```

### Server-Side Implementation (FastAPI)

**App Initialization:**
```python
from fastapi import FastAPI
app = FastAPI()

@app.get("/", response_class=JSONResponse)
async def index_page():
    return {"message": "WebRTC AG2 Server is running!"}
```

**Static Files and Templates:**
```python
from pathlib import Path
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

website_files_path = Path(__file__).parent / "website_files"

app.mount(
    "/static", StaticFiles(directory=website_files_path / "static"), name="static"
)

templates = Jinja2Templates(directory=website_files_path / "templates")
```

**Chat Interface Endpoint:**
```python
@app.get("/start-chat/", response_class=HTMLResponse)
async def start_chat(request: Request):
    """Endpoint to return the HTML page for audio chat."""
    port = request.url.port
    return templates.TemplateResponse("chat.html", {"request": request, "port": port})
```

**WebSocket Handler:**
```python
from ag2 import RealtimeAgent

@app.websocket("/session")
async def handle_media_stream(websocket: WebSocket):
    """Handle WebSocket connections providing audio stream and OpenAI."""
    await websocket.accept()

    logger = getLogger("uvicorn.error")

    realtime_agent = RealtimeAgent(
        name="Weather Bot",
        system_message="Hello there! I am an AI voice assistant powered by Autogen and the OpenAI Realtime API.",
        llm_config=realtime_llm_config,
        websocket=websocket,
        logger=logger,
    )

    @realtime_agent.register_realtime_function(
        name="get_weather", description="Get the current weather"
    )
    def get_weather(location: Annotated[str, "city"]) -> str:
        logger.info(f"Checking the weather: {location}")
        return (
            "The weather is cloudy." if location == "Rome" else "The weather is sunny."
        )

    await realtime_agent.run()
```

## Key Takeaways

- WebRTC provides superior performance for real-time voice applications compared to WebSockets
- Ephemeral API keys enhance security by expiring after one minute
- The DataChannel enables bidirectional event communication alongside audio
- FastAPI simplifies backend setup for managing WebSocket signaling and agent orchestration
- Microphone access requires explicit user permissions in the browser

---

**Resources:**
- [GitHub Repository](https://github.com/ag2ai/realtime-agent-over-webrtc)
- [AG2 Documentation](https://docs.ag2.ai)
- [AG2 Discord Community](https://discord.com/invite/pAbnFJrkgZ)
