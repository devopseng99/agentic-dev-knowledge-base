---
title: "Build a Motion-Triggered SMS Alert System with XIAO ESP32 S3 - No GSM Required"
url: "https://dev.to/david_thomas/build-a-motion-triggered-sms-alert-system-with-xiao-esp32-s3-no-gsm-required-4586"
author: "David Thomas"
category: "esp32-hardware"
---
# Build a Motion-Triggered SMS Alert System with XIAO ESP32 S3 - No GSM Required

**Author:** David Thomas  **Published:** 2026-04-09

## Overview

A motion-detection system using the Seeed Studio XIAO ESP32 S3 paired with an HC-SR04 ultrasonic sensor. Eliminates traditional GSM hardware and SIM cards by leveraging the ESP32's built-in Wi-Fi to transmit HTTP POST requests to Circuit Digest Cloud's API for SMS delivery.

## Key Concepts

- **No GSM Hardware**: Wi-Fi driven alerts instead of SIM cards and GSM shields
- **Cloud SMS API**: Circuit Digest Cloud handles authentication and message delivery globally
- **Distance Threshold**: HC-SR04 ultrasonic sensor monitors objects within 100cm range
- **Alert State Management**: Boolean flag prevents duplicate SMS notifications until intrusion event clears
- **XIAO ESP32 S3 Advantages**: Compact form factor (postage stamp size), dual-core, 8MB flash, integrated Wi-Fi/Bluetooth

```cpp
// Distance measurement with HC-SR04
float readDistance() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  duration = pulseIn(ECHO_PIN, HIGH);
  return duration * 0.034 / 2; // Convert to cm
}
```

## Alert Logic

```cpp
// Prevent duplicate SMS with state flag
bool alertActive = false;

void loop() {
  float distance = readDistance();
  if (distance < 100 && !alertActive) {
    sendSMSAlert(distance);
    alertActive = true;
  }
  if (distance >= 100 && alertActive) {
    alertActive = false; // Reset when clear
  }
}
```

## Use Cases

- Home security (entry points, window monitoring)
- Tank level monitoring
- Industrial safety zone alerts
- Agricultural perimeter protection
