---
title: "How I Designed a Camera Scoring System for VLM-Based Activity Recognition"
url: "https://dev.to/susanayi/embodied-ai-why-i-gave-my-home-robot-an-eye-in-the-sky-5fj6"
author: "susanayi"
category: "robot-perception"
---
# How I Designed a Camera Scoring System for VLM-Based Activity Recognition
**Author:** susanayi  **Published:** March 31, 2026

## Overview
Part 2 of a series on building training-free home robots. The article details a camera selection algorithm for zero-shot vision-language model (VLM) activity recognition. The author explains how to choose optimal viewpoints from twelve fixed ceiling cameras for recognizing user activities like drinking or reading.

## Key Concepts
- **VLM dependency:** "VLM accuracy is directly tied to image quality, and image quality is directly tied to viewpoint selection"
- **Three geometric factors:** visibility, angle, and distance scoring
- **Hard FOV gate:** excludes nodes outside the field of view before weighted calculation
- **Simulation-to-reality gap:** addresses calibration, user localization, and dynamic occlusion challenges

```python
function ScoreCamerasRanked(user, cameras, s_min=0.50):
    aimPos <- user.position + [0, 1.2, 0]
    qualified <- []

    for node in cameras:
        theta <- angle(node.forward, aimPos - node.position)
        if theta > node.FOV / 2:
            node.score <- 0
            continue
        v <- 1 if Linecast(node.position, aimPos) clear else 0
        alpha <- clamp(1 - theta / (node.FOV/2), 0, 1)
        d <- clamp(1 - dist(node.position, aimPos) / 10, 0, 1)
        node.score <- (v*0.5 + alpha*0.3 + d*0.2) * node.multiplier
        if node.score >= s_min:
            qualified.append(node)
    return sort(qualified, key=score, descending=True)
```
