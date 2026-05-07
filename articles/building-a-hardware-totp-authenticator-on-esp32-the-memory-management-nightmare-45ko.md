---
title: "Building a Hardware TOTP Authenticator on ESP32: The Memory Management Nightmare"
url: "https://dev.to/makepkg/building-a-hardware-totp-authenticator-on-esp32-the-memory-management-nightmare-45ko"
author: "makepkg"
category: "esp32-hardware"
---
# Building a Hardware TOTP Authenticator on ESP32: The Memory Management Nightmare

**Author:** makepkg  **Published:** 2026-02-11

## Overview

The author constructed an open-source hardware two-factor authentication device using an ESP32 T-Display microcontroller. The primary challenge involved managing severe memory constraints when running Bluetooth Low Energy (BLE) and WiFi simultaneously on a device with only 520KB of RAM. The BLE stack alone consumes approximately 70KB of RAM — running both simultaneously leads to random crashes, memory fragmentation, and unexpected reboots.

## Key Concepts

- **Memory-Constrained Embedded Architecture**: ESP32 has 520KB RAM; BLE stack alone uses ~70KB
- **Mode Separation Strategy**: TOTP Mode (WiFi enabled for NTP sync, then disabled), Password Manager Mode (WiFi off, BLE independent), BLE Transmission (WiFi must be off first)
- **Heap Monitoring**: Using `ESP.getFreeHeap()` and `ESP.getMinFreeHeap()` to track memory
- **Stack Allocation vs Heap**: Replacing `String` class with `char[]` arrays prevents heap fragmentation
- **WiFi Cleanup**: Proper shutdown sequence required: `disconnect()` + `esp_wifi_deinit()`
- **FreeRTOS Task Sizing**: BLE task stack allocation set to 8192 bytes to prevent overflow
- **SecureGen Project**: Open-source hardware TOTP authenticator with AES-256 encryption, BLE HID keyboard, and web management interface

```cpp
// BAD - heap exhausted from simultaneous WiFi+BLE
void bad_approach() {
    WiFi.begin(ssid, password);
    BLEDevice::init("SecureGen");
    // 💥 Heap exhausted
}

// GOOD - mode-separated approach
void safe_approach() {
    if (mode == TOTP_MODE) {
        sync_time_via_ntp();
        WiFi.disconnect(true);
        WiFi.mode(WIFI_OFF);
    }
    if (need_ble_transmission) {
        ensure_wifi_off();
        init_ble_keyboard();
        send_password();
        deinit_ble_keyboard();
    }
}
```

```cpp
// Heap monitoring
void check_heap() {
    Serial.printf("Free heap: %d bytes\n", ESP.getFreeHeap());
    Serial.printf("Min free heap: %d bytes\n", ESP.getMinFreeHeap());
    if (ESP.getFreeHeap() < 20000) {
        emergency_cleanup();
    }
}
```

```cpp
// BLE task stack sizing
xTaskCreatePinnedToCore(
    ble_task,
    "BLE",
    8192,
    NULL,
    5,
    NULL,
    0
);
```

```cpp
// String handling - avoid heap fragmentation
// Bad (heap fragmentation):
String message = "Hello " + username + "!";

// Good (stack allocation):
char message[64];
snprintf(message, sizeof(message), "Hello %s!", username);
```

```cpp
// WiFi cleanup sequence
WiFi.disconnect(true);
WiFi.mode(WIFI_OFF);
delay(100);
esp_wifi_stop();
esp_wifi_deinit();
```

GitHub: https://github.com/Unix-like-SoN/SecureGen
