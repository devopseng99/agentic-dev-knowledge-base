---
title: "How to build a captive portal in ESP32 with MicroPython"
url: "https://dev.to/devasservice/how-to-build-a-captive-portal-in-esp32-with-micropython-2dc1"
author: "Developer Service"
category: "esp32-hardware"
---
# How to build a captive portal in ESP32 with MicroPython

**Author:** Developer Service  **Published:** 2026-01-26

## Overview

Implementing a captive portal on an ESP32 microcontroller using MicroPython to configure Wi-Fi credentials without hardcoded settings, serial consoles, or companion apps. Enables seamless IoT device onboarding through a web-based interface — device acts as both temporary access point and Wi-Fi client.

## Key Concepts

- **Captive Portal**: Network redirection technique that automatically presents a configuration page when users connect to a device's temporary Wi-Fi network
- **Dual Wi-Fi Modes**: ESP32 simultaneously operates as both `AP_IF` (access point during setup) and `STA_IF` (client during normal operation)
- **DNS Redirection**: Custom DNS server intercepts all domain queries and responds with device IP, triggering "Sign in to network" popup on phones
- **HTTP Server**: Minimal web server serving configuration forms and handling POST submissions without external frameworks
- **Connection Lifecycle**: Checks for saved config at boot; if absent, enters setup mode; otherwise connects to user's network
- **Cross-Platform**: Works on iOS, Android, and Windows; ~70-80% auto-detection success rate for captive portal popup

```python
# wifi_ap.py - Create temporary access point
ap = network.WLAN(network.AP_IF)
ap.active(True)
ap.config(essid="MyDevice-Setup", authmode=network.AUTH_OPEN)
```

```python
# dns_server.py - Redirect all DNS queries to device IP
# UDP-based DNS packet parsing; responds with AP's IP (192.168.4.1)
# Handles standard DNS query format, spoofs A record responses
```

```python
# wifi_client.py - Connect to saved credentials
def connect_wifi(ssid, password, timeout=20):
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, password)
    start = time.time()
    while not wlan.isconnected():
        if time.time() - start > timeout:
            raise RuntimeError("Connection timeout")
        time.sleep(0.5)
    return wlan.ifconfig()[0]
```

```python
# http_server.py - Minimal web server for form handling
# Serves HTML config form, parses POST body
# Saves credentials to flash, triggers reconnect
# Explicit socket.close() prevents resource leaks on ESP32
```
