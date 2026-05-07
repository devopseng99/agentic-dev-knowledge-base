---
title: "New Bluetooth Low Energy (BLE) HID Keyboard & Mouse Libraries"
url: "https://dev.to/hijelHub/new-bluetooth-low-energy-ble-hid-keyboard-mouse-libraries-39p0"
author: "HijelHub"
category: "esp32-hardware"
---
# New Bluetooth Low Energy (BLE) HID Keyboard & Mouse Libraries

**Author:** HijelHub  **Published:** 2026-04-10

## Overview

Two newly developed libraries for Espressif's Arduino-ESP32 platform that wrap NimBLE-Arduino functionality, enabling developers to create Bluetooth Low Energy HID keyboard and mouse implementations. Extensively tested across multiple operating systems with integrated power-saving features.

## Key Concepts

- **BLE HID (Human Interface Device)**: Protocol for keyboards, mice, gamepads over Bluetooth Low Energy
- **NimBLE-Arduino Wrapper**: Abstracts the lower-level NimBLE stack for easier Arduino development
- **Cross-Platform Testing**: Verified on iOS 26.3, macOS Ventura, Android 16, Windows 11, Ubuntu
- **Power Optimization**: BLE radio deactivates during idle periods; supports ESP32 light and deep sleep modes
- **Device Creation and Emulation**: Can act as HID device (keyboard/mouse) or emulate them for testing
- **Use Cases**: Security research tools, accessibility devices, automation controllers, rubber ducky-style input injection

## Libraries

- **HijelHID_BLEKeyboard**: Full keyboard implementation with standard key codes, modifier keys, media keys
- **HijelHID_BLEMouse**: Mouse with movement, button clicks, scroll wheel

## Features

- HID Report descriptor generation
- Connection state management
- Pairing and bonding support
- Battery level reporting (BLE HID standard)
- Low-power idle mode
- Arduino-compatible API

GitHub (Keyboard): https://github.com/HijelHub/HijelHID_BLEKeyboard

GitHub (Mouse): https://github.com/HijelHub/HijelHID_BLEMouse

Tags: #arduino #esp32 #microcontroller #embedded #bluetooth #security
