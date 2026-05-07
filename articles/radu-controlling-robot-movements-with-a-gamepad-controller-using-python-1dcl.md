---
title: "RADU: Controlling Robot Movements with a Gamepad Controller using Python"
url: "https://dev.to/admantium/radu-controlling-robot-movements-with-a-gamepad-controller-using-python-1dcl"
author: "admantium"
category: "jetson-robotics"
---
# RADU: Controlling Robot Movements with a Gamepad Controller using Python
**Author:** admantium  **Published:** 2022-05-16

## Overview
Part of the RADU robot series, this article documents integrating a gamepad controller for teleoperation of a Raspberry Pi-based robot. Covers Python libraries for gamepad input and mapping buttons/axes to robot movement commands.

## Key Concepts
- Pygame library for gamepad/joystick input
- Gamepad axis and button mapping to robot movements
- Dead zone handling for analog sticks
- Differential drive control from joystick inputs
- ROS2 integration: publishing geometry_msgs/Twist from gamepad
- Non-blocking input processing for real-time control
- Safety features: automatic stop on controller disconnect
- Python threading for concurrent input and motor control

```python
import pygame
import time

pygame.init()
pygame.joystick.init()
joystick = pygame.joystick.Joystick(0)
joystick.init()

def get_movement():
    pygame.event.pump()
    axis_x = joystick.get_axis(0)  # Left stick horizontal
    axis_y = joystick.get_axis(1)  # Left stick vertical

    # Apply dead zone
    if abs(axis_x) < 0.1: axis_x = 0
    if abs(axis_y) < 0.1: axis_y = 0

    linear = -axis_y  # Forward/backward
    angular = -axis_x  # Left/right
    return linear, angular

while True:
    linear, angular = get_movement()
    left_speed = linear + angular
    right_speed = linear - angular
    # Send to motor driver
    time.sleep(0.05)
```
