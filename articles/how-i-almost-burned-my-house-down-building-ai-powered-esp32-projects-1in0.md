---
title: "How I Almost Burned My House Down: Building AI-Powered ESP32 Projects"
url: "https://dev.to/keventen/how-i-almost-burned-my-house-down-building-ai-powered-esp32-projects-1in0"
author: "KevinTen"
category: "esp32-hardware"
---
# How I Almost Burned My House Down: Building AI-Powered ESP32 Projects

**Author:** KevinTen  **Published:** 2026-04-20

## Overview

Honest lessons from building seven AI-powered ESP32 projects — including the real dangers of combining embedded hardware with AI-generated code. The author's near-disaster with a mains-powered relay project highlights why hardware safety cannot be skipped even when AI writes the code perfectly.

## Key Concepts

- **AI Code Generation for Embedded**: ChatGPT/Claude can write working ESP32 code, but doesn't know your physical wiring
- **Mains Voltage Danger**: AI-generated relay code may not include proper debouncing, snubber circuits, or opto-isolation
- **Relay Module Safety**: Mechanical relays require snubber capacitors for inductive loads (motors, solenoids)
- **Power Supply Issues**: AI models assume ideal power; real projects need decoupling capacitors, stable regulators
- **Hardware vs Software Bugs**: Software bugs crash your program; hardware bugs can start fires

## Seven Project Lessons

1. **LED Controller**: AI code works perfectly — safe, just verify GPIO current limits
2. **DHT22 Sensor**: Timing-critical protocol; AI-generated code sometimes gets delays wrong
3. **OLED Display**: I2C address conflicts; AI assumes default address (0x3C) which may be wrong
4. **Servo Motor**: PWM frequency matters; AI may generate correct code but wrong frequency for your servo
5. **Relay Module**: *The dangerous one* — AI ignored inductive kickback; snubber circuit saved the device
6. **ESP-NOW Remote**: Radio power regulations; AI doesn't warn about legal TX power limits
7. **BLE Keyboard**: HID descriptor details AI gets wrong on first try

## Safety Rules

```
1. NEVER connect mains voltage to ESP32 GPIO directly
2. Always use optocoupler-isolated relay modules
3. Add TVS diodes / snubbers for inductive loads
4. Decouple power rails (100nF + 10µF near each IC)
5. Fuse all mains-connected projects
6. Test with multimeter BEFORE powering with full load
```

## The Near-Miss

Relay was switching a 120V lamp. AI-generated code was electrically correct but didn't account for the lamp's inductive ballast. On power-off transient, the relay contact arced. Added RC snubber (100Ω + 100nF in series) across contacts — problem solved.
