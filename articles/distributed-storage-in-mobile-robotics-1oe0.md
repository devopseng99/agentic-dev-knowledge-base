---
title: "Distributed Storage in Mobile Robotics"
url: "https://dev.to/reductstore/distributed-storage-in-mobile-robotics-1oe0"
author: "anthonycvn"
category: "jetson-robotics"
---
# Distributed Storage in Mobile Robotics
**Author:** anthonycvn  **Published:** 2025-11-17

## Overview
Explores storage architecture challenges in mobile robotics where multiple robots generate continuous high-bandwidth sensor data across distributed locations. Covers strategies for managing this data efficiently while enabling ML training workflows.

## Key Concepts
- Storage challenges: high-bandwidth sensor streams (cameras, LiDAR) from multiple robots
- Edge storage vs centralized storage tradeoffs
- ReductStore as embedded time-series database for robot data
- FIFO quota management for continuous recording on limited onboard storage
- Selective replication: only transferring labeled or interesting data to cloud
- Integration with ROS2 bag recording workflow
- HTTP API for cross-platform data access
- Metadata and label annotation during recording
- Training data pipeline from robot storage to ML training infrastructure
