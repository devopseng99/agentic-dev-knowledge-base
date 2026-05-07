---
title: "SecureGen v2.0 + v2.1 — What We Built Over the Last Few Months"
url: "https://dev.to/makepkg/securegen-v20-v21-what-we-built-over-the-last-few-months-2m7k"
author: "makepkg"
category: "esp32-hardware"
---
# SecureGen v2.0 + v2.1 — What We Built Over the Last Few Months

**Author:** makepkg  **Published:** 2026-03-21

## Overview

Two major releases of SecureGen, an open-source hardware security device built on the LILYGO T-Display ESP32. The device functions as a TOTP/HOTP authenticator, encrypted password manager, and BLE HID keyboard with 8 layers of application-level security — operates entirely without cloud connectivity.

## Key Concepts

### v2.0.0 — Security Rewrite

- **AES-256-GCM Transport Encryption**: Replaced XOR with ECDH P-256 key exchange + HKDF-derived AES-256-GCM; works in air-gapped AP mode
- **PIN-Encrypted Device Key**: Master key encrypted via PBKDF2-HMAC-SHA256 (25,000 iterations); PIN never transmitted
- **Persistent PIN Lockout**: Five failed attempts permanently lock the device across reboots; counter survives power cycles in encrypted LittleFS
- **Secure Memory Wipe**: Before deep sleep, device zeroes all sensitive data — prevents cold boot attacks
- **HOTP Support**: RFC 4226 counter-based OTP alongside TOTP; works offline without time sync
- **QR Code Import/Export**: Scan QR codes directly into web cabinet; export keys to TFT screen; offline `decrypt_export.html` tool

### v2.1.0 — Stability & UX Improvements

- **DS3231 RTC Module Support**: Hardware clock (I2C) maintains ±2ppm accuracy independently; enables TOTP in air-gapped mode without NTP
- **Light Sleep Crash Fix**: Replaced `esp_light_sleep_start()` with pseudo-sleep (CPU clocked to 40 MHz) to eliminate GPIO0 crash on wake
- **Boot Mode System**: Three modes — WiFi, AP, Offline; 2-second startup override prompt; "Reboot with Web Server" button
- **Navigation Guard**: Blocks tab switching with toast notification until initialization completes
- **Multilingual Support**: English, Russian, German, Chinese (Simplified), Spanish via `tr()` string function

### Notable Bug Fixes
- HOTP display corruption from sentinel value logic error
- HOTP notification incorrectly showed "TOTP code copied"
- `/api/passwords/reorder` missing from tunnel dispatchers
- DOM ID misalignment during drag-and-drop key reordering

### Roadmap
- ECDH P-256 → X25519 migration (performance: ~400ms to ~80ms)
- T-Display S3 port (PSRAM, USB HID, larger display)
- Flash encryption and secure boot via sdkconfig
- ATECC608 secure element integration

Flash Tool: https://makepkg.github.io/SecureGen/flash

GitHub: https://github.com/makepkg/SecureGen
