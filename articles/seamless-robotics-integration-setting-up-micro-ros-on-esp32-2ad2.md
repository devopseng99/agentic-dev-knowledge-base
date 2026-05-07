---
title: "Seamless Robotics Integration: Setting Up micro-ROS on ESP32"
url: "https://dev.to/lonebots/seamless-robotics-integration-setting-up-micro-ros-on-esp32-2ad2"
author: "lonebots"
category: "jetson-robotics"
---
# Seamless Robotics Integration: Setting Up micro-ROS on ESP32
**Author:** lonebots  **Published:** 2023-06-12

## Overview
Walkthrough for setting up micro-ROS on an ESP32 microcontroller, enabling it to communicate with a ROS2 system. Bridges the gap between low-cost microcontrollers and the full ROS2 robotics middleware ecosystem.

## Key Concepts
- micro-ROS: ROS2 for resource-constrained microcontrollers
- ESP32 as a ROS2 node via micro-ROS agent
- UART/WiFi transport for micro-ROS communication
- Publisher and subscriber nodes on ESP32
- Arduino IDE integration for micro-ROS development
- Connecting ESP32 sensors to ROS2 topic graph
- micro-ROS agent running on host (Raspberry Pi or PC)
- Real-time sensor data publishing to ROS2 topics

```bash
# Install micro-ROS agent
pip3 install micro-ros-agent

# Run agent (UART)
ros2 run micro_ros_agent micro_ros_agent serial --dev /dev/ttyUSB0

# Run agent (WiFi UDP)
ros2 run micro_ros_agent micro_ros_agent udp4 --port 8888
```
