---
title: "Pose as Data: Building a Real-Time AI Physical Therapist with MediaPipe and GPT-4o"
url: "https://dev.to/beck_moulton/pose-as-data-building-a-real-time-ai-physical-therapist-with-mediapipe-and-gpt-4o-5ag5"
author: "beck_moulton"
category: "jetson-robotics"
---
# Pose as Data: Building a Real-Time AI Physical Therapist with MediaPipe and GPT-4o
**Author:** beck_moulton  **Published:** 2026-01-31

## Overview
Builds a real-time AI physical therapy assistant using MediaPipe for pose estimation and GPT-4o for exercise feedback. Converts body pose keypoints into structured data for AI analysis of form and movement quality.

## Key Concepts
- MediaPipe Pose: 33-landmark body pose estimation from single camera
- Converting pose keypoints to structured JSON for LLM analysis
- Real-time feedback loop: pose -> analysis -> voice feedback
- Joint angle calculation from 3D pose landmarks
- Exercise form classification and correction
- GPT-4o multimodal: sending pose data descriptions vs raw images
- Latency optimization for real-time use: async processing pipeline
- Application to physical therapy, sports coaching, and fitness

```python
import mediapipe as mp
import cv2
import numpy as np

mp_pose = mp.solutions.pose
mp_drawing = mp.solutions.drawing_utils

def extract_keypoints(image):
    with mp_pose.Pose(
        min_detection_confidence=0.5,
        min_tracking_confidence=0.5
    ) as pose:
        image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = pose.process(image_rgb)
        if results.pose_landmarks:
            landmarks = results.pose_landmarks.landmark
            keypoints = {
                "left_shoulder": [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER].x,
                                   landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER].y],
                "right_shoulder": [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER].x,
                                    landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER].y],
            }
            return keypoints
    return None
```
