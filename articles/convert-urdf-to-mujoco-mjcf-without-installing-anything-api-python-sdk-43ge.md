---
title: "Convert URDF to MuJoCo MJCF Without Installing Anything API + Python SDK"
url: "https://dev.to/ravindhar/convert-urdf-to-mujoco-mjcf-without-installing-anything-api-python-sdk-43ge"
author: "Ravindhar"
category: "robot-building"
---
# Convert URDF to MuJoCo MJCF Without Installing Anything API + Python SDK
**Author:** Ravindhar  **Published:** May 3, 2026

## Overview
The article presents RoboInfra, an API platform addressing challenges in converting URDF robot format files to MuJoCo's MJCF format. Existing conversion tools have documented limitations including loss of inertia tensor data and broken mesh path references. The solution enables conversion via REST API or Python SDK without local installation requirements.

## Key Concepts
- URDF-to-MJCF conversion challenges (buggy compilers, incomplete data handling)
- Multi-format support (also converts to Gazebo SDF)
- Full inertia tensor preservation
- Automated actuator generation
- CI/CD integration capability

```bash
curl -X POST .../api/urdf/convert-format?target=mjcf \
  -H "X-Api-Key: rk_..." -F "file=@robot.urdf"
```

```python
import roboinfra
client = roboinfra.Client("rk_...")
result = client.urdf.convert_format("robot.urdf", "mjcf")
with open("robot.xml", "w") as f:
    f.write(result.converted_xml)
```
