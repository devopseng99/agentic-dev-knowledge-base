---
title: "MicroPython on a $3 Board: Real-Time IoT Dashboard with Zero Cloud Costs!"
url: "https://dev.to/ekwoster/micropython-on-a-3-board-real-time-iot-dashboard-with-zero-cloud-costs-11h9"
author: "Yevhen Kozachenko"
category: "esp32-hardware"
---
# MicroPython on a $3 Board: Real-Time IoT Dashboard with Zero Cloud Costs!

**Author:** Yevhen Kozachenko  **Published:** 2025-10-16

## Overview

Building a real-time IoT dashboard using MicroPython on an inexpensive ESP8266 microcontroller ($3 NodeMCU/WeMos D1 Mini). Eliminates cloud dependencies by leveraging embedded web servers and modern web protocols directly on the device.

## Key Concepts

- **Zero Cloud Costs**: HTTP server + WebSocket integration on the microcontroller itself
- **Real-Time Streaming**: Sensor data streams immediately to browser without cloud middleman
- **MicroPython Benefits**: Full Python control, minimal memory footprint (runs on 128KB RAM), rapid IoT prototyping
- **System Architecture**: HTTP server + WebSocket integration on MCU; browser connects directly to device IP
- **Limitations**: ~50KB usable RAM on ESP8266, no SSL/TLS (HTTP only, LAN use recommended), no WebSockets over TLS
- **uasyncio**: Asynchronous task execution on MicroPython for non-blocking sensor reads + HTTP serving
- **mpfshell**: File management tool for MicroPython devices

```
# Wiring Configuration
DHT11 -> ESP8266
VCC   -> 3.3V
GND   -> GND
DATA  -> D4 (GPIO2)
```

```python
# Async server implementation (MicroPython)
import network
import socket
import uasyncio as asyncio
from machine import Pin
import dht

loop = asyncio.get_event_loop()
loop.create_task(asyncio.start_server(serve_client, "0.0.0.0", 80))
loop.run_forever()
```

```bash
# Firmware Installation
pip install esptool
esptool.py --port /dev/ttyUSB0 erase_flash
esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash --flash_size=detect 0 <firmware-file>.bin
```
