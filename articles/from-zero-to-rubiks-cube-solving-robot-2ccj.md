---
title: "From zero to Rubik's cube solving robot"
url: "https://dev.to/stevcooo/from-zero-to-rubiks-cube-solving-robot-2ccj"
author: "stevcooo"
category: "jetson-robotics"
---
# From zero to Rubik's cube solving robot
**Author:** stevcooo  **Published:** 2019-01-22

## Overview
Documents the full journey of building a Rubik's cube solving robot from scratch — covering computer vision for cube state detection, the solving algorithm, and the mechanical/servo system for physical manipulation.

## Key Concepts
- Computer vision for Rubik's cube face detection and color recognition
- OpenCV color detection for cube state capture
- Kociemba two-phase solving algorithm implementation
- Servo motor control for cube manipulation
- Mechanical design: 6-face manipulation arm
- Python integration between vision, solver, and hardware
- Timing optimization for fast solving
- Error recovery when vision misreads colors
- 3D printing mechanical components

```python
# Cube color detection with OpenCV
import cv2
import numpy as np

def detect_face_colors(image):
    # Convert to HSV for better color detection
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    color_ranges = {
        'white':  ([0, 0, 200], [180, 30, 255]),
        'yellow': ([20, 100, 100], [30, 255, 255]),
        'red':    ([0, 120, 70], [10, 255, 255]),
        'orange': ([10, 100, 100], [20, 255, 255]),
        'blue':   ([100, 120, 70], [130, 255, 255]),
        'green':  ([40, 40, 40], [80, 255, 255]),
    }

    colors = []
    for color_name, (lower, upper) in color_ranges.items():
        mask = cv2.inRange(hsv, np.array(lower), np.array(upper))
        if cv2.countNonZero(mask) > 100:
            colors.append(color_name)
    return colors
```
