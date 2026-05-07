---
title: "Professional Inverse Kinematics on Arduino: Deep Dive into NocKinematics"
url: "https://dev.to/muhammadikhwanfathulloh/professional-inverse-kinematics-on-arduino-deep-dive-into-nockinematics-7hi"
author: "Muhammad Ikhwan Fathulloh"
category: "robot-building"
---
# Professional Inverse Kinematics on Arduino: Deep Dive into NocKinematics
**Author:** Muhammad Ikhwan Fathulloh  **Published:** April 21, 2026

## Overview
The article introduces NocKinematics, a lightweight C++ library implementing the FABRIK (Forward And Backward Reaching Inverse Kinematics) algorithm for microcontroller platforms. Unlike computationally expensive traditional methods, FABRIK offers low computational cost, fast convergence, and constraint handling — making it ideal for Arduino and ESP32 devices powering robotic arms and articulated mechanisms.

## Key Concepts
- **FABRIK Algorithm:** Industry-standard approach based on iterative point-finding rather than trigonometric functions or matrix inversions
- **Memory Optimization:** Avoids `std::vector` to prevent heap fragmentation; allocates memory once during initialization
- **Multi-Platform Support:** Compatible with Arduino Uno, Nano, Mega, ESP8266, and ESP32
- **N-Joint Capability:** Handles 2+ joints, scaling to snake robots or tentacles
- **Academic Foundation:** Built on research by Andreas Aristidou and Joan Lasenby (2011)

```cpp
#include <NocKinematics.h>

const int NUM_JOINTS = 4;
float boneLengths[NUM_JOINTS - 1] = { 10.0, 8.0, 5.0 };

NocKinematics::FABRIK* armSolver =
  new NocKinematics::FABRIK(boneLengths, NUM_JOINTS);
```

```cpp
armSolver->setBasePosition(NocCore::Vector3(0, 0, 0));

NocCore::Vector3 target(12.0, 5.0, 3.0);
bool success = armSolver->solve(target);
```

```cpp
for (int i = 0; i < NUM_JOINTS; i++) {
    NocCore::Vector3 pos = armSolver->getJointPosition(i);
    Serial.print("Joint "); Serial.print(i);
    Serial.print(": "); Serial.print(pos.x_val);
    Serial.print(", "); Serial.println(pos.y_val);
}
```

GitHub: https://github.com/Nocturnailed-Community/NocKinematics
