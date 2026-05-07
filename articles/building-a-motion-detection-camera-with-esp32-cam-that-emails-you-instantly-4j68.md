---
title: "Building a Motion Detection Camera with ESP32-CAM That Emails You Instantly"
url: "https://dev.to/david_thomas/building-a-motion-detection-camera-with-esp32-cam-that-emails-you-instantly-4j68"
author: "David Thomas"
category: "esp32-hardware"
---
# Building a Motion Detection Camera with ESP32-CAM That Emails You Instantly

**Author:** David Thomas  **Published:** 2026-04-11

## Overview

An IoT security system combining a PIR motion sensor with an ESP32-CAM microcontroller. When movement is detected, the system automatically captures an image and sends it via email — eliminating constant manual surveillance.

## Key Concepts

- **PIR + Camera Integration**: Passive infrared sensor triggers camera capture; eliminates false triggers from non-motion events
- **HTTPS Email Delivery**: Secure transmission of captured JPEG to cloud email service
- **Automated Workflow**: Motion detected → capture image → transmit via HTTPS → email delivery
- **Real-World Applications**: Room security, restricted area monitoring, remote surveillance
- **Power Stability**: 5V power supply critical for ESP32-CAM stability; 3.3V insufficient

## System Architecture

```
PIR Sensor → GPIO trigger → ESP32-CAM
                                ↓
                         Camera capture (JPEG)
                                ↓
                        WiFi → HTTPS POST
                                ↓
                         Cloud email service
                                ↓
                         Email with image → Phone
```

## Hardware Components

- ESP32-CAM module (OV2640)
- HC-SR501 PIR motion sensor
- LED status indicator
- 5V 1A power supply
- Breadboard and wires

## PIR Sensor Tuning

- **Sensitivity pot**: Adjust detection range (3–7 meters typical)
- **Time delay pot**: Adjust re-trigger delay (5 seconds–5 minutes)
- **Pin mode**: Single trigger or repeat trigger

## Troubleshooting

- **Excessive PIR triggering**: Reduce sensitivity pot, shield from HVAC vents
- **Camera init failure**: Check power supply, verify camera ribbon connector
- **WiFi drops**: Use static IP, add capacitor across power rails
