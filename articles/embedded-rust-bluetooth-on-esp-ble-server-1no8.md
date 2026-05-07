---
title: "Embedded Rust Bluetooth on ESP: BLE Server"
url: "https://dev.to/omar_hiari/embedded-rust-bluetooth-on-esp-ble-server-1no8"
author: "Omar Hiari"
category: "esp32-hardware"
---
# Embedded Rust Bluetooth on ESP: BLE Server

**Author:** Omar Hiari  **Published:** 2024-03-25

## Overview

Building a BLE GATT server on ESP32 using Rust and the `esp-idf-svc` / `esp-idf-hal` crates. Demonstrates how Rust's memory safety guarantees apply to embedded Bluetooth development, creating a robust IoT device without common C memory bugs.

## Key Concepts

- **Rust on ESP32**: Using `esp-idf-svc` for WiFi/BLE services and `esp-idf-hal` for hardware abstraction
- **GATT Server**: Generic Attribute Profile server for exposing BLE services and characteristics
- **Service/Characteristic UUID**: Defining custom BLE services for IoT data exposure
- **Notify/Indicate**: Pushing data to connected BLE clients without polling
- **Rust Memory Safety**: No buffer overflows, no use-after-free in BLE callback handlers

## Rust BLE Server Setup

```rust
use esp_idf_svc::bt::{BtDriver, BleEnabled};
use esp_idf_svc::bt::ble::gap::{BleGap, AdvConfiguration};
use esp_idf_svc::bt::ble::gatt::server::{GattService, GattsDriver};

let bt = BtDriver::<BleEnabled>::new(&mut peripherals.modem, None)?;
let ble_gap = BleGap::new(&bt, Default::default())?;
let gatts = GattsDriver::new(&bt)?;
```

## GATT Service Definition

```rust
// Define a custom GATT service
const SERVICE_UUID: Uuid = Uuid::from_bytes([
    0x4f, 0xaa, 0x80, 0x0d, ...
]);

const CHAR_UUID: Uuid = Uuid::from_bytes([
    0x4f, 0xaa, 0x80, 0x01, ...
]);
```

## BLE Security in Rust

Rust's ownership model prevents:
- Data races in BLE callback handlers
- Double-free of GATT attribute data
- Use-after-free when connections drop
- Buffer overflows in characteristic write handlers

## Series Navigation

- Part 1: BLE Advertiser
- **Part 2: BLE Server** (this article)
- Part 3: BLE Client
- Part 4: Secure BLE Client
