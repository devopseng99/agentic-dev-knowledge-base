---
title: "Building a Battery-Powered Pomodoro Timer with Deep Sleep"
url: "https://dev.to/rogier_van_den_berg/building-a-battery-powered-pomodoro-timer-with-deep-sleep-1h64"
author: "Rogier van den Berg"
category: "esp32-hardware"
---
# Building a Battery-Powered Pomodoro Timer with Deep Sleep

**Author:** Rogier van den Berg  **Published:** 2026-01-04

## Overview

A battery-efficient Pomodoro timer built on ESP32 using deep sleep and RTC memory to achieve months of battery life on a single 18650 cell. The timer tracks work/break intervals using the ESP32's ultra-low-power RTC domain even during deep sleep.

## Key Concepts

- **Deep Sleep for Battery Life**: ESP32 consumes 5–10µA in deep sleep vs 80–240mA active
- **RTC Memory**: 8KB survives deep sleep; stores timer state, session count, settings
- **RTC Timer Wake**: Configured to wake ESP32 at precise intervals without external RTC
- **E-Paper Display**: Bistable display retains image without power — perfect for battery projects
- **Button Wake**: EXT1 wake source on multiple GPIOs for user interaction without polling

## Deep Sleep Pattern

```cpp
#include "esp_sleep.h"
#include "esp_timer.h"

// State persists through deep sleep
RTC_DATA_ATTR int current_phase = 0;    // 0=work, 1=short break, 2=long break
RTC_DATA_ATTR int session_count = 0;
RTC_DATA_ATTR uint64_t phase_end_us = 0;

void setup() {
    // Check wake cause
    esp_sleep_wakeup_cause_t cause = esp_sleep_get_wakeup_cause();
    
    if (cause == ESP_SLEEP_WAKEUP_TIMER) {
        // Timer expired - advance phase
        advance_pomodoro_phase();
    } else if (cause == ESP_SLEEP_WAKEUP_EXT0) {
        // Button pressed - show status
        update_display();
    }
    
    // Sleep until next phase end
    uint64_t sleep_time = phase_end_us - esp_timer_get_time();
    esp_sleep_enable_timer_wakeup(sleep_time);
    esp_sleep_enable_ext0_wakeup(BUTTON_GPIO, 0);
    
    esp_deep_sleep_start();
}
```

## Battery Life Calculation

- Deep sleep current: 10µA
- Active time: ~200ms per wake
- Wake frequency: Every 25 min (work phase)
- Daily wakes: ~32
- Battery: 2000mAh 18650

**Estimated battery life: ~18 months**

## E-Paper Integration

```cpp
#include <GxEPD2_BW.h>

// E-paper only updates display when content changes
// Retains image during deep sleep with zero power
GxEPD2_BW<GxEPD2_154_D67, GxEPD2_154_D67::HEIGHT> display(
    GxEPD2_154_D67(EPD_CS, EPD_DC, EPD_RST, EPD_BUSY));
```
