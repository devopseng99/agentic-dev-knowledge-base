---
title: "Creating a 50 GB Swap File on Jetson AGX Orin (Root on NVMe)"
url: "https://dev.to/vonusma/creating-a-50-gb-swap-file-on-jetson-agx-orin-root-on-nvme-ijd"
author: "Sergio Andres Usma"
category: "jetson-robotics"
---
# Creating a 50 GB Swap File on Jetson AGX Orin (Root on NVMe)
**Author:** Sergio Andres Usma  **Published:** 2026-04-05

## Overview
Practical guide to creating a large swap file on NVIDIA Jetson AGX Orin when running the root filesystem on NVMe SSD. Important for running large AI models that exceed available unified memory, using swap as overflow storage.

## Key Concepts
- Unified memory architecture: CPU and GPU share same physical RAM
- Swap file as overflow for large model loading
- NVMe SSD swap performance vs SD card swap (critical difference)
- zram vs file-based swap tradeoffs
- Swap file creation on ext4/NVMe
- Model loading with swap: when it helps and when it doesn't
- Performance impact: inference speed with swap vs without
- Configuration for persistent swap at boot

```bash
# Create 50GB swap file on NVMe
sudo fallocate -l 50G /swapfile

# Set permissions
sudo chmod 600 /swapfile

# Format as swap
sudo mkswap /swapfile

# Enable swap
sudo swapon /swapfile

# Verify
swapon --show
free -h

# Make persistent across reboots
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Tune swappiness for AI workloads
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```
