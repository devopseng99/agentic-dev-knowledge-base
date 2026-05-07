---
title: "Build a Wearable AI Device That Talks to Claude for Under $15"
url: "https://dev.to/onewallai/build-a-wearable-ai-device-that-talks-to-claude-for-under-15-4hhe"
author: "ONE WALL AI Publishing"
category: "esp32-hardware"
---
# Build a Wearable AI Device That Talks to Claude for Under $15

**Author:** ONE WALL AI Publishing  **Published:** 2026-04-01

## Overview

Assembling an affordable wearable AI device using the ESP32-S3 microcontroller for voice interaction with Claude's API, displaying responses on a compact OLED screen. Total component cost under $15.

## Key Concepts

- **ESP32-S3 Selection Rationale**: 8MB flash memory, native I2S audio support, built-in USB (no programmer needed), dual-core processing
- **INMP441 Microphone**: Digital I2S input preferred over analog alternatives for lower noise floor
- **OLED Display**: I2C protocol with 4-wire connection (VCC, GND, SDA, SCL)
- **Breadboard Assembly**: No soldering required for basic implementation
- **MicroPython**: Primary programming language for the project
- **Claude API Integration**: Sends voice-transcribed text to Anthropic's Claude API for conversational AI

## Cost Breakdown (~$12–17 total)

| Component | Source | Cost |
|-----------|--------|------|
| ESP32-S3 board | AliExpress/Amazon | $4–6 |
| INMP441 MEMS microphone | AliExpress | $2–3 |
| 0.96" OLED (SSD1306) | AliExpress | $2–3 |
| Small speaker | Local electronics | $1–2 |
| Breadboard + wires | AliExpress | $2–3 |

## Architecture

```
INMP441 Mic → I2S → ESP32-S3 → WiFi → Whisper STT API
                                              ↓
OLED Display ← ESP32-S3 ← WiFi ← Claude API
                    ↓
              I2S → MAX98357A → Speaker (TTS)
```

## MicroPython Workflow

1. Record audio chunk (2–5 seconds) via I2S
2. Send WAV data to Whisper transcription API
3. Forward transcribed text to Claude API
4. Display response on OLED
5. Optionally speak response via cloud TTS
