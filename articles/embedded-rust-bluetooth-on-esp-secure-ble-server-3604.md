---
title: "Embedded Rust Bluetooth on ESP: Secure BLE Server"
url: "https://dev.to/omar_hiari/embedded-rust-bluetooth-on-esp-secure-ble-server-3604"
author: "Omar Hiari"
category: "esp32-hardware"
---
# Embedded Rust Bluetooth on ESP: Secure BLE Server

**Author:** Omar Hiari  **Published:** 2024-04-15

## Overview

Building a secure BLE GATT server on ESP32 using Rust with LE Secure Connections, MITM protection, and bonding. Covers the full security pairing flow for production-grade IoT devices that protect sensitive data over Bluetooth.

## Key Concepts

- **LE Secure Connections (LESC)**: ECDH-based pairing for forward secrecy — replaces legacy pairing
- **MITM Protection**: Numeric comparison or out-of-band verification prevents passive eavesdropping attacks
- **Bonding**: Persisting Long Term Keys (LTK) to avoid re-pairing on reconnection
- **Encryption Required**: Characteristic access restricted to encrypted, authenticated connections
- **BLE Attack Vectors**: Eavesdropping, MITM, replay attacks — all addressed by LESC

## Rust Secure BLE Configuration

```rust
use esp_idf_svc::bt::ble::gap::{SecurityConfig, SecurityLevel};

// Configure LE Secure Connections with MITM protection
let security = SecurityConfig {
    security_level: SecurityLevel::EncryptedMitm,
    key_size: 16,
    init_key: AuthReq::MITM | AuthReq::BOND,
    rsp_key: AuthReq::MITM | AuthReq::BOND,
    passkey_type: PasskeyType::NumericComparison,
};
```

## Characteristic Security Requirements

```rust
// Require encryption + authentication for sensitive reads
CharacteristicPermissions {
    read: Permission::EncryptedMitm,
    write: Permission::EncryptedMitm,
    ..Default::default()
}
```

## Why Secure BLE Matters for IoT

Default BLE pairing ("just works") provides no MITM protection. Anyone with a BLE sniffer (Ubertooth, Wireshark + BLE adapter, or even Flipper Zero) can capture traffic. LESC with MITM protection:
- Requires active attacker presence during pairing
- Makes passive recording useless (forward secrecy)
- Protects medical, security, and financial IoT data

## Series Navigation

- Part 3: BLE Client
- **Part 4: Secure BLE Server** (this article)
