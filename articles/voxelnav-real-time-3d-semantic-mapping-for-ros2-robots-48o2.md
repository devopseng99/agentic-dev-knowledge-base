---
title: "VoxelNav - Real-time 3D Semantic Mapping for ROS2 Robots"
url: "https://dev.to/aman_sachan_126d19c4a2773/voxelnav-real-time-3d-semantic-mapping-for-ros2-robots-48o2"
author: "Aman Sachan"
category: "robot-navigation"
---
# VoxelNav - Real-time 3D Semantic Mapping for ROS2 Robots
**Author:** Aman Sachan  **Published:** April 30, 2026

## Overview
VoxelNav enables robots to generate labeled 3D voxel maps by combining LiDAR and camera data. The system performs semantic understanding (identifying floors, walls, people, furniture, doors) and integrates with Nav2 for intelligent navigation decisions.

## Key Concepts
- O(1) voxel hashing for constant-time lookups
- MobileNetV3 segmentation for object labeling
- Nav2 costmap plugin integration
- 100ms latency performance on Jetson Nano hardware
- Supports any ROS2-compatible LiDAR and RGB-D cameras

```bash
cd voxelnav && colcon build
ros2 run voxelnav voxelnav_node
```

GitHub: https://github.com/AmSach/voxelnav
