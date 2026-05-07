---
title: "MicroPython on ESP32: Build a Smart Sensor in 15 Minutes Without Writing C!"
url: "https://dev.to/ekwoster/micropython-on-esp32-build-a-smart-sensor-in-15-minutes-without-writing-c-2bak"
author: "Yevhen Kozachenko"
category: "esp32-hardware"
---
# MicroPython on ESP32: Build a Smart Sensor in 15 Minutes Without Writing C!

**Author:** Yevhen Kozachenko  **Published:** 2025-10-12

## Overview

Rapid IoT development using MicroPython on an ESP32 microcontroller — building a REST API-enabled weather station combining a DHT11 temperature/humidity sensor with a microcontroller, with focus on speed and simplicity over traditional C-based embedded programming.

## Key Concepts

- **MicroPython Advantages**: Instant REPL access, rapid iteration, familiar Python syntax without compilation overhead
- **Traditional Embedded Challenges**: Low-level C/C++ complexity, slow development cycles, cryptic toolchains
- **Hardware Stack**: ESP32 board, DHT11/DHT22 sensor, micro-USB connectivity
- **Development Tools**: Thonny IDE, esptool.py for firmware flashing
- **REST API on MCU**: HTTP server running directly on ESP32 exposing sensor data
- **Webhook Integration**: POST sensor data to external services
- **Constraints**: ~512KB RAM limits, limited third-party library availability, no multi-threading (async supported)

```python
# WiFi Connection Setup (MicroPython)
import network
import socket
import time
from machine import Pin
import dht

sensor = dht.DHT11(Pin(4))

def connect_wifi(ssid, password):
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, password)
    while not wlan.isconnected():
        time.sleep(1)
```

```python
# REST API Response
response = f"""
HTTP/1.1 200 OK\r\n
{{
    "temperature": {temp},
    "humidity": {hum}
}}
"""
```

```python
# Webhook Integration
import urequests
urequests.post('https://example.com/api/sensor', json={
    "temperature": temp,
    "humidity": hum
})
```

```python
# HTML Dashboard Serving
html = """
<!DOCTYPE html>
<html>
  <head><title>Sensor</title></head>
  <body>
    <h1>Temperature: {temp} C</h1>
    <h2>Humidity: {hum}%</h2>
  </body>
</html>
"""
```

Resources:
- MicroPython: https://micropython.org/
- ESP32 MicroPython docs: https://docs.micropython.org/en/latest/esp32/quickref.html
- Thonny IDE: https://thonny.org/
