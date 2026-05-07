---
title: "The AI That Never Forgets — My Vision Agents Hackathon Journey"
url: "https://dev.to/vaibhav_shukla_20/the-ai-that-never-forgets-my-vision-agents-hackathon-journey-34g"
author: "Vaibhav Shukla"
category: "hackathons"
---

# The AI That Never Forgets — My Vision Agents Hackathon Journey
**Author:** Vaibhav Shukla
**Published:** March 1, 2026

## Overview
ARGUS is a multimodal AI agent with temporal memory, real-time object tracking using YOLO26 Nano + ByteTrack, and voice interaction with sub-1-second latency. Built for the Vision Possible: Agent Protocol Hackathon.

## Key Concepts

### Temporal Memory Event Logging
```python
if old_zone != zone:
    self._log("moved", f"{class_name} (ID:{track_id}) moved from {old_zone} to {zone}")
```

### Performance Benchmarks
| Model | Latency | FPS |
|-------|---------|-----|
| YOLO26 Nano | 130ms/frame | 7.7 |
| YOLOv8 Nano | 138ms/frame | 7.2 |
| YOLO11 Small | 310ms/frame | 3.2 |

### Technical Stack
- Vision Agents SDK, YOLO26 Nano, ByteTrack
- Llama 3.3 via OpenRouter (reasoning)
- Deepgram (STT) + ElevenLabs (TTS)
- Stream Edge Network (transport)

### GitHub Repositories
- https://github.com/Vaibhav13Shukla/argus
- https://github.com/GetStream/Vision-Agents
