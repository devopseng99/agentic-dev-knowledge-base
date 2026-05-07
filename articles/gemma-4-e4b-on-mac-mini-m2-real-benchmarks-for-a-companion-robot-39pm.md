---
title: "Gemma 4 E4B on Mac Mini M2: Real Benchmarks for a Companion Robot"
url: "https://dev.to/desve/gemma-4-e4b-on-mac-mini-m2-real-benchmarks-for-a-companion-robot-39pm"
author: "Vladimir Desyatov"
category: "robot-building"
---
# Gemma 4 E4B on Mac Mini M2: Real Benchmarks for a Companion Robot
**Author:** Vladimir Desyatov  **Published:** April 12, 2026

## Overview
The article documents switching from Microsoft Phi-4-mini to Google Gemma 4 E4B as the AI backbone for AisthOS, an open-source companion robot. The author provides real-world performance metrics and qualitative comparisons, emphasizing improvements in language support, multimodal capabilities, and emotional understanding.

## Key Concepts
- **Model Migration:** Transitioning from 3.8B Phi-4-mini to 4.5B Gemma 4 E4B
- **Performance Metrics:** 16.2 tok/s generation speed on Mac Mini M2 with ~9.6 GB memory usage
- **Multimodal Integration:** Native vision/audio/video support vs. separate model requirements
- **Architecture:** WebSocket-connected ESP32 device with fallback API backends
- **Emotion Recognition:** Structured tag system driving physical display responses

```bash
ollama pull gemma4:e4b
```

```bash
curl -s http://127.0.0.1:11434/api/chat -d '{
  "model": "gemma4:e4b",
  "messages": [
    {"role": "system", "content": "You are Aisth, an AI companion. Always respond in Russian. Be warm and brief."},
    {"role": "user", "content": "How are you feeling today?"}
  ],
  "stream": false
}'
```

Emotion tag format: `[EMOTION:primary,intensity,valence,arousal,intent]`

GitHub: github.com/aisthos/aisthos-core
