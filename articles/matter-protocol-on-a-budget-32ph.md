---
title: "Matter protocol on a budget"
url: "https://dev.to/antigones/matter-protocol-on-a-budget-32ph"
author: "antigones"
category: "esp32-hardware"
---
# Matter protocol on a budget

**Author:** antigones  **Published:** 2025-01-11

## Overview

Implementing the Matter smart home protocol on budget ESP32 hardware — specifically the ESP32-C3 and ESP32-H2 which have native Matter support. Matter (formerly CHIP) enables interoperability between Apple Home, Google Home, Amazon Alexa, and Samsung SmartThings using a single device.

## Key Concepts

- **Matter Protocol**: Open-source IoT interoperability standard backed by Apple, Google, Amazon, Samsung
- **ESP32-H2**: Espressif's dedicated Matter/Thread/Zigbee chip — purpose-built for the new smart home stack
- **ESP32-C3**: Cheaper alternative; supports Matter over WiFi (not Thread)
- **Thread**: IPv6 mesh networking protocol for low-power devices; used with Matter
- **Commissioning**: Device onboarding process using QR code or NFC; pairs with any Matter controller
- **esp-matter SDK**: Espressif's official Matter SDK for ESP32 family

## Supported Protocols by Chip

| Chip | WiFi | Bluetooth | Thread | Zigbee | Price |
|------|------|-----------|--------|--------|-------|
| ESP32-C3 | 2.4G | BLE 5.0 | No | No | ~$2 |
| ESP32-C6 | WiFi 6 | BLE 5.0 | Yes | Yes | ~$3 |
| ESP32-H2 | No | BLE 5.0 | Yes | Yes | ~$2 |
| ESP32-S3 | 2.4G | BLE 5.0 | No | No | ~$4 |

## Minimal Matter Bulb (ESP-IDF)

```c
#include "esp_matter.h"

void app_main() {
    // Initialize Matter stack
    esp_matter::start(app_event_cb);
    
    // Create endpoint for Light Bulb
    esp_matter::endpoint::light_bulb::config_t light_config;
    esp_matter::endpoint_t *endpoint = 
        esp_matter::endpoint::light_bulb::create(
            esp_matter::node::get(), &light_config, 0, NULL);
    
    // Start commissioning (BLE advertising for Matter setup)
    esp_matter::attribute::callback_t cb = on_attribute_update;
    esp_matter::register_attribute_callback(cb, NULL);
}
```

## Budget Build

Complete Matter-enabled smart plug using ESP32-C6:
- ESP32-C6 module: $3
- BL0937 power monitoring IC: $0.50
- PCB from JLCPCB: $2 (for 5 boards)
- Enclosure: $1
- **Total: ~$6.50 per unit**
