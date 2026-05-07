---
title: "Serving a Live Battery Dashboard from ESP32-C3 with Microdot and MicroPython"
url: "https://dev.to/devasservice/serving-a-live-battery-dashboard-from-esp32-c3-with-microdot-and-micropython-5hlo"
author: "Developer Service"
category: "esp32-hardware"
---
# Serving a Live Battery Dashboard from ESP32-C3 with Microdot and MicroPython

**Author:** Developer Service  **Published:** 2026-04-13

## Overview

Building a real-time battery monitoring dashboard that runs directly on an ESP32-C3 microcontroller. The project bridges the gap between functional prototypes and presentable projects by leveraging Microdot, a minimal web framework designed for resource-constrained environments. Monitors Li-ion battery charging via an INA219 power sensor, serving live voltage, current, and power readings through a browser-accessible dashboard on the local network.

## Key Concepts

- **Microdot Framework**: Lightweight web framework purpose-built for MicroPython; Flask-like ergonomics without heavy dependencies
- **INA219 Power Monitor**: I²C sensor measuring bus voltage and shunt voltage; current derived via Ohm's law on the shunt resistor
- **TP4056 Li-ion Charger**: Two-phase charging: constant current (until ~4.2V) then constant voltage with tapering current
- **Architectural Separation**: Hardware logic isolated in `sensor.py`, HTTP routes in `web.py`, Wi-Fi setup in `main.py`
- **Polling Pattern**: Browser-side JavaScript polls `/api/metrics` endpoint every second; no WebSockets required
- **Hardware**: ESP32-C3 Super Mini, INA219 (I²C), TP4056 charging module, 18650 Li-ion battery

```python
# sensor.py - Hardware abstraction
def read_metrics() -> dict:
    ina = _get_ina219()
    voltage_v = ina.bus_voltage_v()
    current_ma = ina.current_ma()
    power_mw = voltage_v * current_ma
    return {
        "voltage_v": voltage_v,
        "current_ma": current_ma,
        "power_mw": power_mw,
    }
```

```python
# web.py - Microdot routes
from microdot import Microdot, Response
from sensor import read_metrics

app = Microdot()

@app.route('/api/metrics')
def api_metrics(_request):
    try:
        metrics = read_metrics()
        metrics["ts_ms"] = _mono_ms()
        return metrics
    except Exception:
        return {"error": "sensor_unavailable"}, 503
```

```javascript
// Browser poll loop (JavaScript)
async function poll() {
  const r = await fetch('/api/metrics', { cache: 'no-store' });
  if (!r.ok) throw new Error('HTTP ' + r.status);
  const d = await r.json();
  voltageEl.textContent = d.voltage_v.toFixed(2) + ' V';
}
setInterval(poll, 1000);
```

```python
# main.py - Wi-Fi connection
def connect_wifi(ssid: str, password: str, timeout_s: int = 20) -> str:
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    if not wlan.isconnected():
        wlan.connect(ssid, password)
        start = time.time()
        while not wlan.isconnected():
            if time.time() - start > timeout_s:
                raise RuntimeError("Wi-Fi connect timeout")
            time.sleep(0.25)
    return wlan.ifconfig()[0]
```

GitHub: https://github.com/nunombispo/microdot-article
