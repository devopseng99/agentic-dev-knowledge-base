---
title: "How I Built a Solar-Powered RS-485 Soil Sensor Node for Orchard Management"
url: "https://dev.to/shaunak_sayta/how-i-built-a-solar-powered-rs-485-soil-sensor-node-for-orchard-management-open-hardware-ffh"
author: "Shaunak Sayta"
category: "esp32-hardware"
---
# How I Built a Solar-Powered RS-485 Soil Sensor Node for Orchard Management (Open Hardware)

**Author:** Shaunak Sayta  **Published:** 2026-04-15

## Overview

An open-hardware soil sensor network for orchard management using ESP32 nodes communicating over RS-485 Modbus to industrial soil sensors. Solar powered with 18650 battery backup — designed for deployment in agricultural fields without power or WiFi infrastructure.

## Key Concepts

- **RS-485 Modbus**: Industrial serial protocol for daisy-chaining multiple soil sensors (up to 32 nodes per bus, 1.2km range)
- **Solar + Battery**: 6V/2W solar panel charges 18650 via TP4056; runs ESP32 in deep sleep between readings
- **Modbus RTU**: Industry-standard protocol for sensor communication — SDI-12 alternative for agricultural use
- **LoRa Backhaul**: Sensor data transmitted over LoRa to gateway when out of WiFi range
- **Deep Sleep Scheduling**: Wake every 15 minutes, read sensors, transmit, return to deep sleep
- **Open Hardware**: Full schematics and PCB layout on GitHub

## Hardware Architecture

```
Solar Panel (6V/2W)
    ↓
TP4056 Charger → 18650 Battery
    ↓
LDO Regulator (3.3V)
    ↓
ESP32-C3 ────── MAX485 RS-485 Driver ── Soil Sensor (Modbus RTU)
    │
    └─── SX1276 LoRa ── Long-range data backhaul
```

## Modbus Reading

```cpp
#include <ModbusMaster.h>

ModbusMaster node;

void setup() {
    Serial2.begin(9600, SERIAL_8N1, RX_PIN, TX_PIN);
    node.begin(1, Serial2);  // Slave address 1
}

float read_soil_moisture() {
    uint8_t result = node.readHoldingRegisters(0x0000, 2);
    if (result == node.ku8MBSuccess) {
        uint16_t raw = node.getResponseBuffer(0);
        return raw / 10.0;  // Convert to percentage
    }
    return -1.0;
}
```

## Power Budget

| State | Current | Duration |
|-------|---------|---------|
| Deep sleep | 50µA | 15 min |
| Active + WiFi/LoRa | 200mA | 5 sec |
| Average | ~28µA | - |

## Open Hardware License

Hardware design files (KiCad schematics + PCB):
- CC BY-SA 4.0 license
- Available on GitHub
