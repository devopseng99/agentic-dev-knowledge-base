---
title: "I Built a 15W Always-On AI Assistant Box - Here's What I Learned"
url: "https://dev.to/yankoaleksandrov/i-built-a-15w-always-on-ai-assistant-box-heres-what-i-learned-454e"
author: "Yanko Alexandrov"
category: "jetson-robotics"
---
# I Built a 15W Always-On AI Assistant Box - Here's What I Learned
**Author:** Yanko Alexandrov  **Published:** 2026-02-27

## Overview
Developer built ClawBox, a self-hosted AI assistant device running continuously on minimal power consumption using a Jetson Orin Nano Super. Addresses frustrations with cloud-based AI subscriptions by offering a privacy-focused, always-available alternative.

## Key Concepts
- Hardware: NVIDIA Jetson Orin Nano Super as the processing core
- 67 TOPS AI performance, 8GB LPDDR5 unified memory, 512GB NVMe SSD, 20W max power
- Power optimization: 15-20W consumption vs Mac Mini M4 (65W) vs Gaming PC RTX 4090 (450W)
- Cost analysis: Hardware one-time cost (€549) vs cloud subscriptions with 8-12 month break-even
- Software stack: OpenClaw platform with local AI capabilities
- Setup simplicity: Five-minute configuration without terminal requirements
- Data privacy: Elimination of cloud-based data transmission

Software stack components:
- Whisper (local speech-to-text)
- Kokoro (local text-to-speech)
- Llama 3.1 8B (~15 tokens/second)
- Browser automation capabilities
- Multi-platform messaging integration

Cost data (6-month period):
- Hardware (one-time): €549
- Electricity: €4.80
- Savings vs cloud VPS: ~€200+
