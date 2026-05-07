---
title: "I Turned My Old Android Phone Into an L2 Autonomous Driving System (Flutter + C++)"
url: "https://dev.to/sherinjosephroy/i-turned-my-old-android-phone-into-an-l2-autonomous-driving-system-flutter-c-12fd"
author: "Sherin Joseph Roy"
category: "3d-ai-generation"
---
# I Turned My Old Android Phone Into an L2 Autonomous Driving System (Flutter + C++)
**Author:** Sherin Joseph Roy  **Published:** 2026-04-13

## Overview
Zyra ADAS is a shadow-mode autonomous driving assistance system running entirely on an Android phone. Rather than cloud processing, this on-device perception engine combines Flutter UI with optimized C++ backends for real-time lane detection and object recognition.

## Key Concepts

### Architecture Design
The system bypasses Flutter's standard serialization overhead using `dart:ffi` to pass raw YUV camera frames directly into native code. MethodChannel serialization costs too much when processing video at high frame rates.

### C++ Engine Components
- YUV to RGB conversion and letterboxing
- YOLOv8n inference via NCNN with Vulkan acceleration
- Non-Maximum Suppression
- Classical lane detection (Canny + HoughLinesP)

### Performance
- Snapdragon 662 (2020 mid-range): ~105ms end-to-end inference
- Snapdragon 8 Gen 2 (flagship): 30 FPS sustained

### Depth and 3D Perception Elements
The system uses monocular depth cues for:
- Inverse perspective mapping for lane curvature estimation
- Object distance approximation via bounding box size heuristics
- Time-to-collision estimation from relative object velocity in frame

### Depth Pipeline Approach
Instead of a full depth estimation model (too slow on mobile), the system:
1. Estimates depth from apparent object size vs. known object dimensions
2. Uses lane geometry for ground plane estimation
3. Triangulates relative positions from optical flow vectors

This hybrid approach achieves practical 3D scene understanding without running a separate depth estimation network.

## GitHub Links
- https://github.com/Sherin-SEF-AI/Zyra-ADAS
