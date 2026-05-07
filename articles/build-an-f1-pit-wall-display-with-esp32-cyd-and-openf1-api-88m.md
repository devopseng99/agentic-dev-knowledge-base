---
title: "Build an F1 Pit Wall Display with ESP32 CYD and OpenF1 API"
url: "https://dev.to/devasservice/build-an-f1-pit-wall-display-with-esp32-cyd-and-openf1-api-88m"
author: "Developer Service"
category: "esp32-hardware"
---
# Build an F1 Pit Wall Display with ESP32 CYD and OpenF1 API

**Author:** Developer Service  **Published:** 2026-03-16

## Overview

Building a live Formula 1 race display using an ESP32-CYD microcontroller (320×240 touchscreen, ~€10) connected to the OpenF1 API. The project uses a two-tier architecture: a Python aggregator server processes complex race data, and the microcontroller acts as a lightweight display client. Attempting direct microcontroller integration reveals memory constraints that require architectural redesign.

## Key Concepts

- **Two-Tier Architecture**: Aggregator server on Raspberry Pi handles API complexity; ESP32-CYD handles rendering only
- **Memory Management**: MicroPython requires explicit `gc.collect()` before/after HTTP requests; explicit `del r` prevents heap exhaustion over multi-hour sessions
- **Data Transformation**: OpenF1 returns raw session logs (thousands of chronological entries); aggregator reconstructs current race state by grouping per driver and selecting most recent update
- **Display Layout**: ILI9341 display driver, XPT2046 touch controller; 10-row maximum, fixed 8×8 font with explicit coordinate placement
- **Update Trigger**: Redraw only on new lap or touch input (prevents flicker mid-race)
- **API Endpoints**: `/position`, `/stints`, `/intervals`, `/lap_times`, `/race_control`

```json
// Aggregated API response format
{
  "session": {
    "circuit_name": "Melbourne",
    "country_iso3": "AUS"
  },
  "latest_lap_number": 58,
  "total_laps": null,
  "current_standings": [
    {
      "position": 1,
      "driver_number": 63,
      "name_acronym": "RUS",
      "team_colour": "00D7B6",
      "tyre": "HARD",
      "stint_duration_laps": 47,
      "lap_time_or_gap": "1:23.351"
    }
  ],
  "fastest_lap": {
    "driver_number": 3,
    "duration_formatted": "1:22.091"
  }
}
```

```python
# Memory-safe HTTP request in MicroPython
def get_pitwall():
    try:
        gc.collect()          # Pre-request heap cleanup
        r = urequests.request("GET", PITWALL_URL, timeout=10)
        data = ujson.loads(r.content)
        r.close()
        del r                 # Explicit reference deletion
        gc.collect()          # Reclaim buffer memory
        return data
    except Exception as e:
        print("Error:", e)
        return None
```

GitHub: https://github.com/nunombispo/CYD-OpenF1
