---
title: "Build an Offline ESP32 Voice Assistant (Speech-to-Text Without Internet)"
url: "https://dev.to/david_thomas/build-an-offline-esp32-voice-assistant-speech-to-text-without-internet-12em"
author: "David Thomas"
category: "esp32-hardware"
---
# Build an Offline ESP32 Voice Assistant (Speech-to-Text Without Internet)

**Author:** David Thomas  **Published:** 2026-04-24

## Overview

Creating a voice recognition system on an ESP32 microcontroller that operates independently of internet connectivity. The project leverages machine learning models to process audio locally, converting spoken commands into actionable text without cloud services.

## Key Concepts

- **Offline Processing**: All audio analysis and speech recognition occurs on the device itself
- **Edge Impulse Platform**: Handles dataset preparation, model training, and optimization for microcontroller deployment
- **Real-time Inference**: Processes audio in chunks with confidence scoring to prevent false triggers
- **Wake-Word Detection**: User says "Marvin" (activation) → device listens → user speaks command → immediate execution
- **INMP441 Microphone**: Digital I2S MEMS microphone for audio capture
- **LED Status Indicators**: Visual feedback for listening state and command recognition
- **No Cloud Dependency**: Works in offline environments, basements, tunnels, air-gapped systems

## Hardware Components

- ESP32 board (any variant with sufficient flash)
- INMP441 microphone module (I2S digital)
- LED indicators for status feedback
- USB cable for programming

## Workflow

1. Record audio samples for each command ("on", "off", target keywords)
2. Upload dataset to Edge Impulse Studio
3. Train INT8 quantized model in cloud
4. Export as Arduino library
5. Flash to ESP32 via Arduino IDE
6. Run inference loop on device

## Learning Outcomes

- Embedded machine learning fundamentals
- Audio signal processing (sampling, windowing, MFCC)
- Real-time inference on constrained hardware
- Hardware-software integration
- TFLite Micro deployment pipeline
