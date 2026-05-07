---
title: "Mission Accomplished: Building a Real-Time AI Spatial Agent | Vision Possible Hackathon"
url: "https://dev.to/swagatika_beura2/mission-accomplished-building-a-real-time-ai-spatial-agent-vision-possible-hackathon-the-40m5"
author: "Swagatika Beura"
category: "hackathons"
---

# Mission Accomplished: Building a Real-Time AI Spatial Agent | Vision Possible Hackathon
**Author:** Swagatika Beura
**Published:** March 1, 2026

## Overview
VisionMate AI is a mobility platform submitted to the Vision Possible: Agent Protocol Hackathon. It transforms passive camera feeds into active spatial hazard detection systems, measuring proximity threats for cyclists, e-scooter riders, and dashcam users.

## Key Concepts

### The "40% Rule" - Core Spatial Hazard Math

```python
def process_bounding_boxes(image, results):
    for box in results.boxes:
        x1, y1, x2, y2 = map(int, box.xyxy[0])
        vertical_span = (y2 - y1) / img_h

        if vertical_span > 0.4:
            status, color, thickness = "HAZARD", (0, 0, 255), 4
        elif vertical_span > 0.2:
            status, color, thickness = "MID", (0, 255, 255), 2
        else:
            status, color, thickness = "FAR", (0, 255, 0), 2
```

### Technical Stack
- Frontend: Streamlit with custom CSS
- Vision & Detection: Ultralytics YOLOv8, Stream Vision Agents SDK
- LLM: Google Gemini Realtime for conversational warnings
- Core: Python, OpenCV, NumPy
- Audio: Google Text-to-Speech (gTTS)
- Sub-30ms latency through WebRTC-based architecture

### GitHub Repository
- https://github.com/swagatika60/Vision-Agent

**Live App:** https://vision-agent.streamlit.app/
