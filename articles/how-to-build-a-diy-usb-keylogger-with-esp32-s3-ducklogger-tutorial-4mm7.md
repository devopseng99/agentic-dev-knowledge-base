---
title: "How to Build a DIY USB Keylogger with ESP32-S3 (DuckLogger Tutorial)"
url: "https://dev.to/monazir/how-to-build-a-diy-usb-keylogger-with-esp32-s3-ducklogger-tutorial-4mm7"
author: "Monazir Muhammad Doha"
category: "esp32-hardware"
---
# How to Build a DIY USB Keylogger with ESP32-S3 (DuckLogger Tutorial)

**Author:** Monazir Muhammad Doha  **Published:** 2026-04-17

## Overview

Educational tutorial on building a USB keylogger using the ESP32-S3 microcontroller. The DuckLogger project demonstrates USB HID attack techniques for security research and penetration testing education. The ESP32-S3's native USB support enables it to act as a USB HID device (keyboard) while simultaneously sniffing USB traffic.

## Key Concepts

- **ESP32-S3 Native USB**: Built-in USB OTG support allows acting as HID device without external chip
- **USB HID Emulation**: Microcontroller presents itself as a keyboard to the host computer
- **Keylogger Functionality**: Captures and stores keystrokes to internal flash or transmits via WiFi
- **Security Research Tool**: Educational — demonstrates why physical access to a computer is critical security boundary
- **WiFi Exfiltration**: Logged keystrokes transmitted over WiFi to remote endpoint
- **DuckLogger Architecture**: Plug in → enumerate as HID keyboard → capture keystrokes → exfiltrate via WiFi

## Hardware Components

- ESP32-S3 DevKit (with native USB port)
- USB-C cable
- MicroSD card (optional, for local storage)

## Security Implications

This type of tool demonstrates why:
1. Physical security is a critical layer (lock your workstation)
2. USB device screening/whitelisting is important in enterprises
3. USB condoms (data blockers) protect against malicious USB devices
4. Hardware security keys should be used for authentication

## Educational Use Cases

- Penetration testing (authorized engagements only)
- Security awareness training demonstrations
- CTF (Capture The Flag) competitions
- Red team exercises

Note: This project is for educational and authorized security testing only. Deploying keyloggers without consent is illegal in most jurisdictions.
