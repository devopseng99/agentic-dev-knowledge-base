---
title: "Setting Up Raspberry Pi & Camera for AI Projects (Complete Command Guide)"
url: "https://dev.to/kenryikegbo/setting-up-raspberry-pi-camera-for-ai-projects-complete-command-guide-340g"
author: "Ikegbo Ogochukwu"
category: "robot-perception"
---
# Setting Up Raspberry Pi & Camera for AI Projects (Complete Command Guide)
**Author:** Ikegbo Ogochukwu  **Published:** May 4, 2026

## Overview
A comprehensive guide for configuring Raspberry Pi systems for computer vision and AI applications, covering system setup, remote access, camera configuration, and image processing workflows.

## Key Concepts
- Modern Raspberry Pi OS uses libcamera system (camera enabled by default)
- SSH provides command-line control; VNC enables full GUI access
- Legacy raspistill commands replaced by rpicam-* utilities
- Python + OpenCV integration for image manipulation

```bash
sudo apt update && sudo apt upgrade
```

```bash
hostname -I
ssh pi@192.168.43.25
```

```bash
rpicam-hello
rpicam-still -o test.jpg
rpicam-vid -t 5000 -o video.h264
```

```bash
for i in {1..10}; do rpicam-still -o img_$i.jpg; sleep 2; done
```

```python
import cv2
img = cv2.imread("test.jpg")
resized = cv2.resize(img, (224, 224))
cv2.imwrite("resized.jpg", resized)
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
```
