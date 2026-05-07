---
title: "I Built a Smart Water Tank Automation System with ESP32 + AI in 3 Days — Full Breakdown"
url: "https://dev.to/murali/i-built-a-smart-water-tank-automation-system-with-esp32-ai-in-3-days-full-breakdown-4b47"
author: "Murali"
category: "esp32-hardware"
---
# I Built a Smart Water Tank Automation System with ESP32 + AI in 3 Days — Full Breakdown

**Author:** Murali  **Published:** 2026-04-18

## Overview

A complete 3-day build diary of a smart water tank automation system using ESP32, water level sensors, a relay-controlled pump, and AI-generated code assistance. Includes full breakdown of hardware, software, and the AI workflow that accelerated development.

## Key Concepts

- **HC-SR04 Ultrasonic**: Tank level measurement by echo time; distance = water level calculation
- **Relay Module**: Controls 12V pump via 3.3V ESP32 GPIO signal
- **AI Code Generation**: Used Claude/ChatGPT for boilerplate; manual debugging for hardware-specific issues
- **Telegram Bot**: Real-time alerts and manual control via Telegram API
- **Threshold Automation**: Pump turns on at low level, off at high level; hysteresis prevents rapid cycling
- **NVS Storage**: Stores thresholds and schedules in ESP32 non-volatile memory

## System Architecture

```
HC-SR04 (level sensor)
    ↓
ESP32 ──── Relay ──── 12V Pump
    │
    ├── WiFi ──── Telegram Bot (alerts + control)
    │
    └── OLED ──── Local display (level %, pump state)
```

## Core Control Logic

```cpp
// Hysteresis pump control
const int LOW_THRESHOLD = 20;   // % - turn pump ON
const int HIGH_THRESHOLD = 90;  // % - turn pump OFF
bool pump_running = false;

void control_pump(int level_pct) {
    if (!pump_running && level_pct < LOW_THRESHOLD) {
        digitalWrite(RELAY_PIN, HIGH);  // Pump ON
        pump_running = true;
        send_telegram_alert("Pump started - low water: " + level_pct + "%");
    }
    if (pump_running && level_pct >= HIGH_THRESHOLD) {
        digitalWrite(RELAY_PIN, LOW);   // Pump OFF
        pump_running = false;
        send_telegram_alert("Pump stopped - tank full: " + level_pct + "%");
    }
}
```

## Day-by-Day Breakdown

**Day 1**: Hardware assembly, sensor testing, relay verification
**Day 2**: WiFi + Telegram bot, threshold logic, OLED display
**Day 3**: Testing, hysteresis tuning, NVS parameter storage, enclosure

## AI Assistance Results

- Boilerplate code (WiFi, Telegram, OLED): AI wrote 80% correctly on first try
- Ultrasonic timing: Needed manual fix for ESP32-specific IRAM attributes
- Relay safety (debounce, minimum on/off time): AI missed this; added manually
