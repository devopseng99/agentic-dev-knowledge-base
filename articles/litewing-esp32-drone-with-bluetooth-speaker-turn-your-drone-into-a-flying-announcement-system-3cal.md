---
title: "LiteWing ESP32 Drone with Bluetooth Speaker | Turn Your Drone into a Flying Announcement System"
url: "https://dev.to/david_thomas/litewing-esp32-drone-with-bluetooth-speaker-turn-your-drone-into-a-flying-announcement-system-3cal"
author: "David Thomas"
category: "esp32-hardware"
---
# LiteWing ESP32 Drone with Bluetooth Speaker | Turn Your Drone into a Flying Announcement System

**Author:** David Thomas  **Published:** 2026-04-30

## Overview

Upgrading a LiteWing ESP32 drone with wireless audio capabilities. Integrates a Bluetooth audio module enabling the drone to stream and play sound from a smartphone while airborne — "no coding" and "no complex setup" required.

## Key Concepts

- **Dual-System Architecture**: Flight control operates independently from the audio streaming system without interference
- **Power Management**: Boost converter steps up battery voltage from 3.7V to 5V for audio components
- **Weight Constraints**: Added components must stay under 25 grams to maintain flight stability
- **Signal Chain**: Bluetooth module → PAM8403 amplifier → 2W 8Ω speaker
- **JDY-62 Module**: Bluetooth audio receiver that pairs as A2DP audio sink

## Hardware Components

- LiteWing ESP32 Drone (base platform)
- JDY-62 Bluetooth audio module
- PAM8403 audio amplifier (3W Class D)
- 2W 8Ω speaker
- Boost converter (3.7V → 5V, under 5g)
- Jumper wires

## Critical Design Constraint

The boost converter is non-negotiable: LiPo battery outputs 3.7V (3.2V–4.2V range) but PAM8403 requires stable 5V. Without it:
- Audio distortion at low battery
- Amplifier instability causing system restarts

## Troubleshooting Guide

| Problem | Cause | Solution |
|---------|-------|---------|
| System restarts | Power supply instability | Add higher-current boost converter |
| No audio | Pairing/wiring issue | Re-pair JDY-62, check speaker wiring |
| Flight instability | Weight imbalance | Reposition speaker for symmetric weight |

## Applications

- Event announcements from aerial vantage points
- Search-and-rescue communication systems
- Mobile public address (PA) systems
- Educational demonstrations
