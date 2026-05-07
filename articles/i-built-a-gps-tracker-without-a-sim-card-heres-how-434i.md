---
title: "I Built a GPS Tracker Without a SIM Card - Here's How"
url: "https://dev.to/david_thomas/i-built-a-gps-tracker-without-a-sim-card-heres-how-434i"
author: "David Thomas"
category: "esp32-hardware"
---
# I Built a GPS Tracker Without a SIM Card - Here's How

**Author:** David Thomas  **Published:** 2026-04-11

## Overview

An alternative GPS tracking solution that eliminates the need for GSM modules and SIM cards. Uses WiFi connectivity to transmit location data to the cloud — works via phone hotspot, home WiFi, or public WiFi networks.

## Key Concepts

- **WiFi-Based GPS**: Transmits location via WiFi instead of cellular — works through phone hotspot
- **Neo-6M GPS Module**: UART at 9600 baud, connected to ESP32-S3 GPIO 43/44 (TX/RX)
- **TinyGPSPlus Library**: Parses NMEA sentences from GPS module
- **GeoLinker Cloud**: Free tier includes 10,000 data points per API key, 10-second minimum interval
- **Offline Buffering**: ESP32 caches GPS data locally when WiFi disconnects, syncs on reconnection
- **Geofencing**: Haversine formula calculates distance from home coordinates; triggers SMS alert on boundary violation

## Hardware Components

- Seeed Studio XIAO ESP32-S3
- Neo-6M GPS module
- External patch antenna (improves satellite acquisition)
- Breadboard and jumper wires

## Geofencing Logic

```cpp
// Haversine-based geofence alert
if (dist > 50 && !alertSent) {
  sendSMS(latitude, longitude);
  alertSent = true;
}
if (dist <= 50 && alertSent) alertSent = false;
```

## Update Frequency

Data transmitted every 15 seconds over WiFi. For battery operation, use deep sleep between transmissions.

## Applications

- Vehicle monitoring through phone hotspots
- Asset protection with movement alerts
- Pet and child safety monitoring
- Elderly care with boundary notifications
- Low-cost fleet tracking (no SIM card fees)
