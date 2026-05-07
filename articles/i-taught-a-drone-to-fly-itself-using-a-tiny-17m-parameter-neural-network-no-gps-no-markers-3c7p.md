---
title: "We Taught a Drone to Fly Itself Using a Tiny 1.7M Parameter Neural Network, No GPS, No Markers"
url: "https://dev.to/sebastian_mocanu/i-taught-a-drone-to-fly-itself-using-a-tiny-17m-parameter-neural-network-no-gps-no-markers-3c7p"
author: "Sebastian Mocanu"
category: "drone-ai"
---
# We Taught a Drone to Fly Itself Using a Tiny 1.7M Parameter Neural Network, No GPS, No Markers
**Author:** Sebastian Mocanu  **Published:** April 3, 2026

## Overview
A PhD candidate demonstrates autonomous indoor drone flight using only a camera and a compact neural network, eliminating the need for GPS, expensive sensors, or fiducial markers. The research was presented as an oral presentation at ICCV 2025.

## Key Concepts
1. **Teacher-Student Architecture:** A numerically stable IBVS system (teacher) generates training data for a lightweight CNN (student)
2. **NSER-IBVS:** Numerically Stable Efficient Reduced Image-Based Visual Servoing — fixes classical instabilities
3. **Mask Splitter:** U-Net component ensuring consistent keypoint ordering across frames
4. **Sim-to-Real Transfer:** Digital twin using Parrot Sphinx + Unreal Engine 4 for training data generation
5. **Model Efficiency:** 1.7M parameters achieving 540 FPS inference (11x faster than teacher)

```bash
git clone --recursive https://github.com/SpaceTime-Vision-Robotics-Laboratory/nser-ibvs-drone.git
cd nser-ibvs-drone
python3 -m venv ./venv && source venv/bin/activate
pip install -r requirements.txt && pip install -e .
```

## Performance Metrics

| Metric | Teacher | Student |
|--------|---------|---------|
| Speed | 48 FPS | 540 FPS |
| Parameters | 4.78M | 1.7M |
| Sim Error | 29.76 px | 14.26 px |
| Real Error | 29.96 px | 33.33 px |

GitHub: https://github.com/SpaceTime-Vision-Robotics-Laboratory/nser-ibvs-drone
GitHub (Mask Splitter): https://github.com/SpaceTime-Vision-Robotics-Laboratory/mask-splitter
