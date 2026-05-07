---
title: "Build a Talking Robot with Gemini Live and Reachy Mini"
url: "https://dev.to/googleai/build-a-talking-robot-with-gemini-live-and-reachy-mini-20e2"
author: "Thor Schaeff"
category: "robot-building"
---
# Build a Talking Robot with Gemini Live and Reachy Mini
**Author:** Thor Schaeff  **Published:** April 13, 2026

## Overview
This tutorial demonstrates creating an expressive conversational robot by combining Google's Gemini Live API with Pollen Robotics' Reachy Mini platform. The project enables real-time voice interactions where the robot responds with synchronized movements, dances, and emotional expressions.

## Key Concepts
- Full-duplex audio conversations via fastrtc WebRTC streaming
- Tool-based action system (dance, emotions, head tracking, camera)
- Layered motion blending (primary moves + secondary offsets + idle breathing)
- Profile-based personality customization
- Continuous video streaming (1 FPS)
- 60 Hz movement control loop

```python
async def receive(self, frame):
    pcm_bytes = audio_to_int16(frame).tobytes()
    await self.session.send_realtime_input(
        audio=types.Blob(data=pcm_bytes, mime_type="audio/pcm;rate=16000")
    )
```

```python
async def _run_live_session(self):
    async with client.aio.live.connect(model=..., config=...) as session:
        async for response in session.receive():
            if response.server_content and response.server_content.model_turn:
                for part in response.server_content.model_turn.parts:
                    audio_array = np.frombuffer(part.inline_data.data, dtype=np.int16)
                    await self.output_queue.put((24000, audio_array))
            if response.tool_call:
                await self._handle_tool_call(response)
```

```python
async def _video_sender_loop(self):
    while not self._stop_event.is_set():
        frame = self.deps.camera_worker.get_latest_frame()
        _, buffer = cv2.imencode(".jpg", frame, [cv2.IMWRITE_JPEG_QUALITY, 70])
        await self.session.send_realtime_input(
            video=types.Blob(data=buffer.tobytes(), mime_type="image/jpeg")
        )
        await asyncio.sleep(1.0)
```

```python
from reachy_mini_conversation_app.tools.core_tools import Tool

class SweepLookTool(Tool):
    name = "sweep_look"
    description = "Slowly look around the room in a sweeping motion."

    async def run(self, args, deps):
        return {"status": "done", "description": "Finished looking around"}
```

```shell
git clone https://github.com/pollen-robotics/reachy_mini_conversation_app.git
cd reachy_mini_conversation_app
uv venv --python python3.12 .venv
source .venv/bin/activate
uv sync
```

```shell
# Physical robot
reachy-mini-daemon

# Simulation mode
reachy-mini-daemon --simulation
```

```shell
reachy-mini-conversation-app
reachy-mini-conversation-app --gradio
reachy-mini-conversation-app --head-tracker mediapipe
reachy-mini-conversation-app --debug
```

GitHub: https://github.com/pollen-robotics/reachy_mini_conversation_app
GitHub (SDK): https://github.com/pollen-robotics/reachy_mini
