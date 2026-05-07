---
title: "RADU: Processing & Interpreting ROS Movement Messages with Python"
url: "https://dev.to/admantium/radu-processing-interpreting-ros-movement-messages-with-python-1bin"
author: "admantium"
category: "jetson-robotics"
---
# RADU: Processing & Interpreting ROS Movement Messages with Python
**Author:** admantium  **Published:** 2022-04-25

## Overview
Part of the RADU robot series covering how to receive and interpret ROS movement messages (geometry_msgs/Twist) in Python, translating velocity commands into actual motor control signals for a differential drive robot.

## Key Concepts
- geometry_msgs/Twist message structure: linear.x and angular.z velocities
- Converting velocity commands to differential drive wheel speeds
- ROS2 subscriber node in Python (rclpy)
- Motor speed calculation from linear and angular velocity
- Velocity clamping for safety limits
- Timeout handling: stop motors if no command received
- Integration with hardware motor driver (GPIO/PWM)

```python
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist

class MovementController(Node):
    def __init__(self):
        super().__init__('movement_controller')
        self.subscription = self.create_subscription(
            Twist,
            '/cmd_vel',
            self.cmd_vel_callback,
            10
        )
        self.wheel_base = 0.2  # 20cm between wheels
        self.max_speed = 1.0

    def cmd_vel_callback(self, msg):
        linear = msg.linear.x
        angular = msg.angular.z

        # Differential drive kinematics
        left_speed = linear - (angular * self.wheel_base / 2)
        right_speed = linear + (angular * self.wheel_base / 2)

        # Clamp to max speed
        left_speed = max(-self.max_speed, min(self.max_speed, left_speed))
        right_speed = max(-self.max_speed, min(self.max_speed, right_speed))

        self.set_motors(left_speed, right_speed)
        self.get_logger().info(f'L:{left_speed:.2f} R:{right_speed:.2f}')

    def set_motors(self, left, right):
        pass  # Hardware-specific implementation
```
