---
title: "Indian Currency Recognition Using ESP32-CAM & Edge Impulse"
url: "https://dev.to/david_thomas/indian-currency-recognition-using-esp32-cam-edge-impulse-39a7"
author: "David Thomas"
category: "esp32-hardware"
---
# Indian Currency Recognition Using ESP32-CAM & Edge Impulse

**Author:** David Thomas  **Published:** 2026-02-27

## Overview

Building an offline machine learning system using an ESP32-CAM microcontroller to identify Indian rupee denominations in real-time. Combines TinyML with edge AI to perform currency recognition locally without cloud processing.

## Key Concepts

- **TinyML / Edge AI**: Running ML inference directly on microcontrollers
- **Offline Processing**: "No cloud processing required after deployment" — works without internet
- **Object Detection**: Identifying specific currency denominations through trained CNNs
- **Dataset Preparation**: 50+ images per denomination; consistent lighting and backgrounds required
- **Edge Impulse Studio**: Cloud-based ML training platform that exports Arduino library for ESP32-CAM
- **INT8 Quantization**: Required to fit model within ESP32's 520KB SRAM

## Hardware Components

| Component | Quantity | Purpose |
|-----------|----------|---------|
| ESP32-CAM | 1 | Image capture & inference |
| USB-to-Serial Converter | 1 | Programming (FTDI) |
| LEDs (4 colors) | 4 | Denomination indication |
| 100Ω Resistors | 4 | LED protection |
| Breadboard | 1 | Prototyping |

## ML Pipeline

1. **Dataset Collection**: Photograph each denomination (₹10, ₹20, ₹50, ₹100, ₹200, ₹500, ₹2000) with consistent lighting
2. **Edge Impulse Studio**: Upload images, annotate, train MobileNet v1/v2 model
3. **Export**: Download as Arduino library
4. **Deploy**: Flash via Arduino IDE to ESP32-CAM
5. **Inference**: Real-time classification at 1–3 FPS

## Practical Applications

- Assistive technology for visually impaired users
- Retail point-of-sale systems
- Automated currency counters and vending machines
- Smart ATM validation
