---
title: "Develop simple data logger using BNO055 and Jetson nano"
url: "https://dev.to/qooniee/develop-simple-data-logger-using-bno055-and-jetson-nano-np"
author: "Qooniee"
category: "jetson-robotics"
---
# Develop simple data logger using BNO055 and Jetson nano
**Author:** Qooniee  **Published:** 2022-05-06

## Overview
A Japanese automotive software engineer creates a sensor-based data logging system combining a Jetson Nano with an Adafruit BNO055 9-axis IMU to capture vehicle dynamics. Emerged from the developer's desire to work with sensor data without purchasing expensive hardware.

## Key Concepts
- 9DoF Sensor Capabilities: BNO055 measures orientation (Euler angles and quaternions), angular velocity, acceleration vectors, magnetic fields, and temperature
- Coordinate System Conversion: Transforming sensor-native coordinates to ISO vehicle coordinate standards
- Quaternion vs Euler Angles: Using quaternion-based calculations to avoid gimbal lock issues affecting direct Euler angle outputs
- Sampling Frequency Limitations: Practical constraints limiting the system to ~50Hz despite theoretical 100Hz capability
- Performance Analysis: Serial vs parallel processing execution time investigation
- Validation Testing: Lab tests against iPhone's phyphox application and actual vehicle measurements
- Key finding: Direct Euler angle outputs exhibited instability at ±45° roll/pitch; quaternion calculations proved significantly more stable

```python
import adafruit_bno055
import busio
import board

class MeasBNO055:
    def connect(self):
        i2c = busio.I2C(board.SCL, board.SDA)
        bno = adafruit_bno055.BNO055_I2C(i2c)
        return i2c, bno

    def get_data(self, bno):
        euler_z, euler_y, euler_x = [val for val in bno.euler]
        gyro_x, gyro_y, gyro_z = [val for val in bno.gyro]
        quaternion_1, quaternion_2, quaternion_3, quaternion_4 = bno.quaternion
```

```python
# Quaternion to Euler Conversion
def calcEulerfromQuaternion(self, _w, _x, _y, _z):
    sqw = _w ** 2
    sqx = _x ** 2
    sqy = _y ** 2
    sqz = _z ** 2
    yaw = 57.2957795131 * np.arctan2(2.0*(_x*_y+_z*_w),
                                      (sqx-sqy-sqz+sqw))
    pitch = 57.2957795131 * np.arcsin(-2.0*(_x*_z-_y*_w)/(sqx+sqy+sqz+sqw))
    roll = 57.2957795131 * np.arctan2(2.0*(_y*_z+_x*_w),
                                      (-sqx-sqy+sqz+sqw))
    return roll, pitch, yaw
```

```python
# Performance Testing with ThreadPoolExecutor
from concurrent.futures import ThreadPoolExecutor

def parallel_process(bno, n):
    sensors = ['euler', 'gyro', 'gravity', 'acceleration']
    with ThreadPoolExecutor(max_workers=n) as e:
        ret = e.map(get_all_data, params, chunksize=1)
```

## GitHub Repos
- https://github.com/cayk326/measurement_system
