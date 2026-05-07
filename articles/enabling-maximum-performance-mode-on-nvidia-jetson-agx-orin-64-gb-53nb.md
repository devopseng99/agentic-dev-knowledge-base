---
title: "Enabling Maximum Performance Mode on NVIDIA Jetson AGX Orin 64 GB"
url: "https://dev.to/vonusma/enabling-maximum-performance-mode-on-nvidia-jetson-agx-orin-64-gb-53nb"
author: "Sergio Andres Usma"
category: "jetson-robotics"
---
# Enabling Maximum Performance Mode on NVIDIA Jetson AGX Orin 64 GB
**Author:** Sergio Andres Usma  **Published:** 2026-04-05

## Overview
Step-by-step guide to configuring NVIDIA Jetson AGX Orin 64GB for maximum AI inference performance by setting the power mode, CPU/GPU clock frequencies, and enabling all available hardware accelerators.

## Key Concepts
- nvpmodel: NVIDIA power mode configuration tool
- MODE_MAXN: Maximum performance mode (all cores, max clocks)
- jetson_clocks: Script to maximize CPU, GPU, and memory clocks
- Thermal considerations when running at max performance
- Power consumption at MAXN: ~60W for AGX Orin 64GB
- Performance monitoring with tegrastats
- Persistent clock settings across reboots
- Trade-off between max performance and thermal throttling

```bash
# Check current power mode
sudo nvpmodel -q

# Set to maximum performance mode
sudo nvpmodel -m 0

# Maximize all clocks
sudo jetson_clocks

# Monitor performance and thermals
sudo tegrastats

# Check GPU frequency
cat /sys/devices/gpu.0/devfreq/17000000.gpu/cur_freq

# Make jetson_clocks persistent at boot
sudo jetson_clocks --store
sudo systemctl enable nvpmodel
```
