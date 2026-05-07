---
title: "How I Built an Offline Voice Assistant for Smart Home on Raspberry Pi and Why I Ditched the Cloud"
url: "https://dev.to/dotradepro/how-i-built-an-offline-voice-assistant-for-smart-home-on-raspberry-pi-and-why-i-ditched-the-cloud-3aei"
author: "dotradepro"
category: "jetson-robotics"
---
# How I Built an Offline Voice Assistant for Smart Home on Raspberry Pi and Why I Ditched the Cloud
**Author:** dotradepro  **Published:** 2026-04-15

## Overview
Documents building a fully offline voice assistant for smart home control on Raspberry Pi, motivated by privacy concerns and cloud service reliability issues. Covers the full pipeline from wake word detection to device control.

## Key Concepts
- Privacy motivation: cloud assistants transmit all voice data to servers
- Reliability: offline system works during internet outages
- Wake word detection with Porcupine or OpenWakeWord
- Vosk for offline speech recognition (runs on Raspberry Pi)
- Intent parsing with simple rule-based NLP or local Rasa
- Home Assistant integration via local API
- Hardware requirements: Raspberry Pi 4 (4GB), USB microphone, speakers
- Response latency: 1-3 seconds vs cloud latency
- Smart home device control via MQTT

```python
# Vosk offline speech recognition
from vosk import Model, KaldiRecognizer
import pyaudio
import json

model = Model("vosk-model-small-en-us")
recognizer = KaldiRecognizer(model, 16000)

p = pyaudio.PyAudio()
stream = p.open(format=pyaudio.paInt16, channels=1, rate=16000, input=True, frames_per_buffer=8000)
stream.start_stream()

while True:
    data = stream.read(4000)
    if recognizer.AcceptWaveform(data):
        result = json.loads(recognizer.Result())
        text = result.get("text", "")
        if text:
            print(f"Recognized: {text}")
            # Process command
```
