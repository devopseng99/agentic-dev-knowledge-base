---
title: "A Deep Dive Into ESP-CSI: Channel State Information on ESP32 Chips"
url: "https://dev.to/pratha_maniar/a-deep-dive-into-esp-csi-channel-state-information-on-esp32-chips-5el1"
author: "Pratha Maniar"
category: "esp32-hardware"
---
# A Deep Dive Into ESP-CSI: Channel State Information on ESP32 Chips

**Author:** Pratha Maniar  **Published:** 2025-11-19

## Overview

Channel State Information (CSI) on ESP32 chips enables WiFi-based passive sensing — detecting human presence, gestures, and activity through WiFi signal variations without cameras or additional sensors. A deep technical dive into Espressif's ESP-CSI library.

## Key Concepts

- **Channel State Information (CSI)**: Per-subcarrier amplitude and phase data from WiFi OFDM signal reception
- **WiFi Sensing**: Human movement disturbs WiFi signals; CSI captures this disturbance
- **ESP-CSI Library**: Espressif's open-source toolkit for CSI data collection on ESP32
- **Subcarriers**: ESP32 reports CSI for up to 52 OFDM subcarriers per packet
- **Applications**: Gesture recognition, fall detection, occupancy sensing, breathing rate monitoring

## How ESP-CSI Works

```c
// Enable CSI callback in ESP-IDF
wifi_csi_config_t csi_config = {
    .lltf_en = true,
    .htltf_en = true,
    .stbc_htltf2_en = true,
    .ltf_merge_en = true,
    .channel_filter_en = false,
    .manu_scale = false,
};

esp_wifi_set_csi_config(&csi_config);
esp_wifi_set_csi_rx_cb(wifi_csi_rx_cb, NULL);
esp_wifi_set_csi(true);
```

## CSI Data Structure

```c
void wifi_csi_rx_cb(void *ctx, wifi_csi_info_t *info) {
    // info->buf contains complex CSI data
    // Length varies by bandwidth: 128 bytes for 20MHz
    int8_t *csi_data = info->buf;
    
    // Each element is imaginary/real component pair
    for (int i = 0; i < info->len / 2; i++) {
        int8_t real = csi_data[i * 2];
        int8_t imag = csi_data[i * 2 + 1];
        float amplitude = sqrt(real*real + imag*imag);
        float phase = atan2(imag, real);
    }
}
```

## Security & Privacy Considerations

CSI-based WiFi sensing is passive — no opt-in required from sensed subjects. This creates:
- Privacy concerns in shared spaces
- Potential for covert activity monitoring
- Counter-surveillance via WiFi jammers or CSI spoofing

GitHub: https://github.com/espressif/esp-csi
