---
title: "Network Optimization Tutorial For NVIDIA Jetson AGX Orin 64 GB"
url: "https://dev.to/vonusma/network-optimization-tutorial-for-nvidia-jetson-agx-orin-64-gb-a9e"
author: "Sergio Andres Usma"
category: "jetson-robotics"
---
# Network Optimization Tutorial For NVIDIA Jetson AGX Orin 64 GB
**Author:** Sergio Andres Usma  **Published:** 2026-04-05

## Overview
Covers network configuration and optimization for NVIDIA Jetson AGX Orin 64GB to maximize throughput for AI model downloads, container pulls, and multi-device AI communication in a lab or production environment.

## Key Concepts
- Ethernet vs WiFi performance considerations for Jetson
- Jumbo frames (MTU 9000) for high-throughput local network
- TCP buffer tuning for large file transfers
- Static IP assignment for reliable device addressing
- Container network optimization (Docker bridge vs host networking)
- GPU-Direct RDMA potential for Jetson networking
- SSH configuration for reliable remote management
- Bandwidth testing with iperf3

```bash
# Check current network interfaces
ip addr show
nmcli device status

# Configure static IP
nmcli con mod "Wired connection 1" \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "8.8.8.8 8.8.4.4" \
  ipv4.method manual

# Increase TCP buffer sizes
sudo sysctl -w net.core.rmem_max=134217728
sudo sysctl -w net.core.wmem_max=134217728
sudo sysctl -w net.ipv4.tcp_rmem="4096 87380 134217728"
sudo sysctl -w net.ipv4.tcp_wmem="4096 65536 134217728"

# Test network bandwidth
iperf3 -c 192.168.1.1 -t 30 -P 4
```
