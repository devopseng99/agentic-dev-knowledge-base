---
title: "Robotic Arm: Assembly & Software Installation"
url: "https://dev.to/admantium/robotic-arm-assembly-software-installation-hnd"
author: "Sebastian"
category: "jetson-robotics"
---
# Robotic Arm: Assembly & Software Installation
**Author:** Sebastian  **Published:** 2023-03-30

## Overview
Documents assembling a 4-degree-of-freedom robotic arm kit for Raspberry Pi with a PCA9685 motor shield. Covers OS installation, system configuration, hardware troubleshooting, and software setup for controlling the arm via TCP or web interface.

## Key Concepts
- Raspbian OS version compatibility issues
- Raspberry Pi system optimization: SSH, WLAN, I2C/SPI/GPIO access
- I2C device detection and troubleshooting
- PWM servo motor control
- OLED display integration
- Remote arm control interfaces: TCP socket and Flask web server
- PCA9685 motor shield for 16-channel PWM control

```python
# OLED Display Test
from luma.core.interface.serial import i2c
from luma.core.render import canvas
from luma.oled.device import ssd1306
import time

serial = i2c(port=1, address=0x3C)
device = ssd1306(serial, rotate=0)

with canvas(device) as draw:
    draw.text((0, 20), "ROBOT", fill="white")

while True:
    time.sleep(10)
```

```python
# Servo Motor Control
import Adafruit_PCA9685
import time

pwm = Adafruit_PCA9685.PCA9685()
pwm.set_pwm_freq(50)

while 1:
    pwm.set_pwm(3, 0, 300)
    time.sleep(1)
    pwm.set_pwm(3, 0, 400)
    time.sleep(1)
```

## GitHub Repos
- https://github.com/adeept/adeept_rasparms
