---
title: "Smart Connectivity: Leveraging Wi-Fi and Bluetooth Coexistence in ESP32"
url: "https://dev.to/jane_white/smart-connectivity-leveraging-wi-fi-and-bluetooth-coexistence-in-esp32-45b2"
author: "Jane White"
category: "esp32-hardware"
---
# Smart Connectivity: Leveraging Wi-Fi and Bluetooth Coexistence in ESP32

**Author:** Jane White  **Published:** 2024-07-20

## Overview

The ESP32 features a single radio that multiplexes between Wi-Fi and Bluetooth using time-division coexistence (TDC). Understanding this architecture is critical for IoT applications requiring simultaneous WiFi and Bluetooth operation.

## Key Concepts

- **Single Radio Architecture**: ESP32 has one 2.4 GHz RF transceiver shared between WiFi and BLE
- **Time-Division Coexistence (TDC)**: Radio timeslots allocated between WiFi and BT — they don't truly run simultaneously
- **Coexistence Modes**: WiFi preferred, BT preferred, or balanced (configurable)
- **Throughput Impact**: Enabling BLE reduces WiFi throughput by 30–50%; vice versa
- **Interference on 2.4 GHz**: Both compete with each other and with Zigbee, other BT devices
- **BT Classic + BLE**: ESP32 supports both BT Classic (for A2DP audio, Wiimote) and BLE 4.2

## Coexistence Configuration

```c
// Configure coexistence preference
esp_coex_preference_t pref = ESP_COEX_PREFER_BALANCE;
esp_coex_preference_set(pref);

// Options:
// ESP_COEX_PREFER_WIFI    - WiFi gets priority slots
// ESP_COEX_PREFER_BT      - Bluetooth gets priority slots
// ESP_COEX_PREFER_BALANCE - Equal time division
```

## Memory Constraints

Running both WiFi and BLE simultaneously consumes ~250KB RAM:
- WiFi stack: ~100KB
- BLE stack: ~70KB
- Application: ~380KB remaining

## Design Recommendations

1. **For BLE-only**: Disable WiFi completely — saves ~100KB RAM, eliminates coexistence overhead
2. **For WiFi IoT with BLE config**: Use BLE only during setup phase; disable after
3. **For simultaneous**: Use BLE Balanced mode; accept ~30% throughput reduction on both
4. **For streaming audio**: Use BT Classic A2DP with WiFi disabled for clean audio

## Typical IoT Pattern

```
Boot → BLE advertising (for config)
    → Phone connects via BLE, sends WiFi credentials
    → BLE disabled → WiFi connected
    → Normal IoT operation (MQTT over WiFi)
```
