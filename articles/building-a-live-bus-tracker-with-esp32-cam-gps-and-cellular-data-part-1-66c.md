---
title: "Building a Live Bus Tracker with ESP32-CAM, GPS, and Cellular Data (Part 1)"
url: "https://dev.to/anhaj_uwaisulkarni/building-a-live-bus-tracker-with-esp32-cam-gps-and-cellular-data-part-1-66c"
author: "Anhaj Uwaisulkarni"
category: "esp32-hardware"
---
# Building a Live Bus Tracker with ESP32-CAM, GPS, and Cellular Data (Part 1)

**Author:** Anhaj Uwaisulkarni  **Published:** 2026-02-15

## Overview

Building a live public transit tracking system using ESP32-CAM for visual monitoring, NEO-6M GPS for location, and SIM800L for cellular data transmission. Enables real-time bus tracking without WiFi infrastructure dependency — works anywhere with cellular coverage.

## Key Concepts

- **ESP32-CAM + GPS + GSM**: Tri-component system combining vision, position, and cellular communication
- **SIM800L GPRS**: 2G/GPRS module for low-bandwidth GPS data transmission; cheaper than LTE for IoT telemetry
- **NEO-6M GPS**: Common UART GPS module outputting NMEA sentences
- **TinyGPS++ Library**: Arduino library for parsing NMEA GPS data
- **HTTP over GPRS**: Sending GPS coordinates to server via SIM800L AT commands
- **AT Commands**: SIM800L controlled via serial AT command set

## Hardware Architecture

```
ESP32-CAM ──── Camera (OV2640)
    │
    ├── UART1 ── NEO-6M GPS (9600 baud)
    │
    └── UART2 ── SIM800L (9600 baud)
                     │
                     └── SIM card → GPRS → Internet → Server
```

## GPS Parsing

```cpp
#include <TinyGPS++.h>
#include <HardwareSerial.h>

TinyGPSPlus gps;
HardwareSerial gpsSerial(1);

void setup() {
    gpsSerial.begin(9600, SERIAL_8N1, 33, 32); // RX=33, TX=32
}

void loop() {
    while (gpsSerial.available() > 0) {
        gps.encode(gpsSerial.read());
    }
    
    if (gps.location.isValid()) {
        float lat = gps.location.lat();
        float lng = gps.location.lng();
        Serial.printf("Lat: %.6f, Lng: %.6f\n", lat, lng);
    }
}
```

## SIM800L HTTP Transmission

```cpp
void send_to_server(float lat, float lng) {
    sim800.println("AT+HTTPINIT");
    delay(100);
    sim800.println("AT+HTTPPARA=\"CID\",1");
    sim800.printf("AT+HTTPPARA=\"URL\",\"http://tracker.example.com/update?lat=%.6f&lng=%.6f\"\r\n", lat, lng);
    sim800.println("AT+HTTPACTION=0");  // GET request
}
```

## Part 2 Preview

- Image capture on schedule or event trigger
- JPEG upload via GPRS (base64 encoded)
- Web dashboard with Google Maps integration
