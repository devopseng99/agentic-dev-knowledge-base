---
title: "Secure Boot on ESP32: Fortifying Your IoT Device Against Firmware Attacks"
url: "https://dev.to/bleadvertiser/secure-boot-on-esp32-fortifying-your-iot-device-against-firmware-attacks-52b4"
author: "Ble Advertiser"
category: "esp32-hardware"
---
# Secure Boot on ESP32: Fortifying Your IoT Device Against Firmware Attacks

**Author:** Ble Advertiser  **Published:** 2026-04-04

## Overview

Implementing ESP32 Secure Boot to prevent unauthorized firmware from running on production IoT devices. Without Secure Boot, anyone with physical access can flash malicious firmware — Secure Boot creates a hardware-enforced chain of trust from bootloader to application.

## Key Concepts

- **Secure Boot V2**: ECDSA-based signature verification of firmware before execution
- **Chain of Trust**: Bootloader signature → partition table signature → application signature
- **eFuse**: One-time-programmable fuses storing the trusted public key hash — cannot be changed after burning
- **Flash Encryption**: Complements Secure Boot by encrypting flash contents
- **JTAG Disable**: Should be disabled alongside Secure Boot to prevent debug bypass
- **Key Management**: ECDSA private key must be kept offline; only public key stored on device

## Secure Boot Enable (sdkconfig)

```
CONFIG_SECURE_BOOT=y
CONFIG_SECURE_BOOT_V2_ENABLED=y
CONFIG_SECURE_BOOTLOADER_ONE_TIME_FLASH=y
CONFIG_SECURE_BOOT_SIGNING_KEY="secure_boot_signing_key.pem"
```

## Key Generation

```bash
# Generate ECDSA key pair
espsecure.py generate_signing_key --version 2 secure_boot_signing_key.pem

# Sign firmware
espsecure.py sign_data --version 2 --keyfile secure_boot_signing_key.pem \
    firmware.bin -o firmware_signed.bin
```

## Flash Encryption (Combined with Secure Boot)

```
CONFIG_FLASH_ENCRYPTION_ENABLED=y
CONFIG_FLASH_ENCRYPTION_MODE_RELEASE=y
```

## Attack Scenarios Addressed

| Attack | Without Secure Boot | With Secure Boot |
|--------|-------------------|-----------------|
| Flash malicious firmware | Possible | Blocked (signature check) |
| Read firmware secrets | If unencrypted | Blocked (flash encryption) |
| JTAG debugging | Possible | Blocked (JTAG disabled) |
| Bootloader tampering | Possible | Blocked (chain of trust) |

## Warning: Irreversible Operations

Burning eFuses and enabling Secure Boot is IRREVERSIBLE. Test thoroughly on development hardware before production deployment.
