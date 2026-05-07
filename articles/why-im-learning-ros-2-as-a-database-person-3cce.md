---
title: "Why I'm Learning ROS 2 as a Database Person"
url: "https://dev.to/mattstratton/why-im-learning-ros-2-as-a-database-person-3cce"
author: "Matty Stratton"
category: "robot-building"
---
# Why I'm Learning ROS 2 as a Database Person
**Author:** Matty Stratton  **Published:** May 1, 2026

## Overview
Matty Stratton, Head of Developer Advocacy at Tiger Data (TimescaleDB), documents his journey learning ROS 2 robotics from a database perspective. He identifies a critical gap: while rosbag2 excels at recording and replaying robot telemetry, there is "no real story for storing and querying ROS 2 telemetry at fleet scale."

## Key Concepts
- **The Problem:** Production robotics fleets need queryable telemetry across multiple units over time, but current recording formats prioritize replay over analysis
- **rosbag2 Limitations:** Optimized for sequential recording/replay; lacks query capabilities for fleet-wide analysis
- **TimescaleDB as Solution:** Time-series database suited for high-frequency sequential writes and historical analysis
- **Community Gap:** An open GitHub feature request naming TimescaleDB and InfluxDB has remained unaddressed since July 2024

## Project Plan
Publicly building a ROS 2 node that writes telemetry directly to TimescaleDB:
1. Local environment setup using TurtleBot3 simulation in Gazebo
2. rosbag2 format analysis
3. Schema design and type mapping
4. Live telemetry visualization in Grafana

GitHub: https://github.com/mattstratton/ros2-timescaledb-bridge
