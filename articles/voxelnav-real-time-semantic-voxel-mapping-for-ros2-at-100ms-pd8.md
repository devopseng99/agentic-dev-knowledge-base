---
title: "VoxelNav: Real-time Semantic Voxel Mapping for ROS2 at 100ms"
url: "https://dev.to/aman_sachan_126d19c4a2773/voxelnav-real-time-semantic-voxel-mapping-for-ros2-at-100ms-pd8"
author: "Aman Sachan"
category: "robot-building"
---
# VoxelNav: Real-time Semantic Voxel Mapping for ROS2 at 100ms
**Author:** Aman Sachan  **Published:** April 30, 2026

## Overview
VoxelNav is a ROS2-native solution addressing limitations in existing SLAM implementations. As stated in the article, "existing SLAM solutions are either too slow, too expensive, or too dumb." VoxelNav achieves real-time semantic understanding on resource-constrained hardware like the Jetson Nano.

## Key Concepts
- **Real-time processing:** 100ms end-to-end latency on Jetson Nano
- **Semantic voxel grids:** Converts LiDAR/RGB-D sensor data into structured 3D representations
- **ROS2 integration:** Native node compatible with Nav2 costmap output
- **O(1) voxel hashing:** Constant-time lookups for performance
- **MobileNetV3 segmentation:** Object labeling (floors, walls, people, furniture, doors)
- **Sensor agnostic:** Works with any ROS2-compatible sensors

```bash
cd ~/ros2_ws/src
git clone https://github.com/AmSach/voxelnav.git
colcon build --packages-select voxelnav
ros2 launch voxelnav voxelnav.launch.py
```

```bash
cd voxelnav && colcon build
ros2 run voxelnav voxelnav_node
```

## Performance Benchmarks (Jetson Nano)

| Mode | Latency | Memory |
|------|---------|--------|
| Geometry only | 30ms | 50MB |
| Full semantic | 100ms | 150MB |

GitHub: https://github.com/AmSach/voxelnav
