---
title: "Edge ML Has a Size Obsession"
url: "https://dev.to/david_aronchick_ea415de50/edge-ml-has-a-size-obsession-1pfh"
author: "David Aronchick"
category: "jetson-robotics"
---
# Edge ML Has a Size Obsession
**Author:** David Aronchick  **Published:** 2026-05-05

## Overview
Argues that the edge machine learning community is over-focused on minimizing model size at the expense of practical deployment factors. Challenges the assumption that smaller is always better and explores what actually matters for real-world edge AI deployments.

## Key Concepts
- Size obsession in TinyML/edge ML community
- Model size vs actual inference latency tradeoffs
- Hardware heterogeneity: different accelerators favor different model architectures
- Quantization correctness vs compression ratio
- Real-world deployment factors beyond model size: startup time, memory fragmentation, thermal effects
- Energy efficiency metrics as better optimization target than size
- Backlash size as arbitrary proxy for performance
- Better metrics: TOPS/W, latency at P99, accuracy under power budget
