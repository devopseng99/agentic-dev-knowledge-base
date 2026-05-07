---
title: "Beyond Cameras: π RuView Transforms WiFi into a See-Through-Walls Sensing System"
url: "https://dev.to/githubopensource/beyond-cameras-p-ruview-transforms-wifi-into-a-see-through-walls-sensing-system-12o5"
author: "GitHubOpenSource"
category: "esp32-hardware"
---
# Beyond Cameras: π RuView Transforms WiFi into a See-Through-Walls Sensing System

**Author:** GitHubOpenSource  **Published:** 2026-04-16

## Overview

π RuView is an open-source project that uses WiFi Channel State Information (CSI) to detect human presence and movement through walls — essentially using WiFi signals as a radar. No cameras, no privacy invasion, just signal processing.

## Key Concepts

- **WiFi CSI Sensing**: Channel State Information captures per-subcarrier amplitude/phase changes caused by human movement
- **Through-Wall Detection**: 2.4 GHz WiFi penetrates common building materials; movement creates measurable signal disturbances
- **Non-Camera Privacy**: Detects presence without capturing identifiable images
- **Raspberry Pi + ESP32**: Pi acts as processing hub; ESP32 nodes collect CSI data from strategically placed WiFi links
- **Machine Learning Pipeline**: CSI data fed to lightweight ML model for activity classification
- **Applications**: Elderly fall detection, occupancy monitoring, smart home presence detection

## System Architecture

```
ESP32 Node 1 (TX) ──── WiFi Link ──── ESP32 Node 2 (RX)
                                           │
                                    CSI data stream
                                           │
                                   Raspberry Pi
                                           │
                                   ML Inference
                                           │
                                   Activity Classification:
                                   - No one present
                                   - Person stationary
                                   - Person walking
                                   - Fall detected
```

## CSI Collection on ESP32

```c
// esp-csi callback
void csi_callback(void *ctx, wifi_csi_info_t *info) {
    // Extract amplitude profile across 52 subcarriers
    int8_t *buf = info->buf;
    float amplitudes[52];
    for (int i = 0; i < 52; i++) {
        int8_t real = buf[i * 2];
        int8_t imag = buf[i * 2 + 1];
        amplitudes[i] = sqrtf(real*real + imag*imag);
    }
    // Send to Raspberry Pi via UART/WiFi
}
```

## Privacy Advantages

Unlike camera-based systems:
- No video footage stored
- Cannot identify individuals
- Works in complete darkness
- Cannot be used for voyeurism
