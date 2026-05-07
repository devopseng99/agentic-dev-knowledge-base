---
title: "Add a WiFi Camera to a LiteWing ESP32 Drone for Live Video Streaming"
url: "https://dev.to/david_thomas/add-a-wifi-camera-to-a-litewing-esp32-drone-for-live-video-streaming-1m77"
author: "David Thomas"
category: "esp32-hardware"
---
# Add a WiFi Camera to a LiteWing ESP32 Drone for Live Video Streaming

**Author:** David Thomas  **Published:** 2026-03-17

## Overview

Integrating a WiFi camera module into a LiteWing ESP32 drone for real-time video streaming during flight. The project showcases practical aerial modification for hobbyists and engineering students seeking custom FPV (First Person View) platforms.

## Key Concepts

- **Dual Wireless Networks**: Drone runs two independent networks — LiteWing's access point for flight control + camera's WiFi hotspot for video streaming
- **Hardware Simplicity**: Camera module requires only power (VCC/GND) — no data line integration with flight controller needed
- **Power Stability**: LiPo battery with higher C-rating prevents voltage drops causing video noise at full throttle
- **Dedicated WiFi Camera Module**: Toy drone-style WiFi cameras preferred over ESP32-CAM alternatives (simpler, more reliable under flight stress)
- **App Integration**: Smartphone connects to camera's WiFi network; views stream via "IP Camera" or "WebCam" apps

## Why Not ESP32-CAM?

| Feature | WiFi Camera Module | ESP32-CAM |
|---------|-------------------|-----------|
| Weight | ~15g | ~10g |
| Setup | Plug-and-play | Requires Arduino programming |
| Reliability | Higher (dedicated hardware) | Lower (more failure modes) |
| Video Quality | Better (dedicated ISP) | Acceptable |
| Control Integration | Separate network | Can integrate with flight controller |

## Weight Budget

For stable flight on LiteWing:
- Camera module: ~15g
- Boost converter (if needed): ~3g
- Mounting hardware: ~5g
- **Total addition: ~23g** (within 25g limit)

## Viewing Method

1. Connect smartphone to camera's WiFi hotspot
2. Open compatible IP camera viewer app
3. Enter camera's IP address (usually 192.168.1.1)
4. View MJPEG or H.264 stream in real-time
