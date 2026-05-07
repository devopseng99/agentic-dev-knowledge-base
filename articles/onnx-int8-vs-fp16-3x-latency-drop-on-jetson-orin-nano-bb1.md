---
title: "ONNX INT8 vs FP16: 3x Latency Drop on Jetson Orin Nano"
url: "https://dev.to/tildalice/onnx-int8-vs-fp16-3x-latency-drop-on-jetson-orin-nano-bb1"
author: "TildAlice"
category: "jetson-robotics"
---
# ONNX INT8 vs FP16: 3x Latency Drop on Jetson Orin Nano
**Author:** TildAlice  **Published:** 2026-04-11

## Overview
Documents a performance comparison between INT8 and FP16 precision modes for neural network inference on NVIDIA's Jetson Orin Nano edge device. Converting from FP16 to INT8 quantization reduced object detection latency from 47ms to 15ms per frame — a 3x speedup enabling production-ready real-time inference on constrained hardware.

## Key Concepts
- Model Quantization Trade-offs: INT8 delivers substantial speed improvements but introduces accuracy variations depending on model architecture
- Architecture-Specific Performance: ResNet-based models tolerate quantization well (<2% mAP loss), while MobileNet variants occasionally show 14% false positive increases on small objects
- Hardware Context: Jetson Orin Nano specifications (1024 CUDA cores, 32 Tensor Cores, 15W power envelope) and how precision modes interact with tensor hardware
- Production Readiness: Distinction between benchmark averages and real-world accuracy degradation across model variants
- Latency results: FP16 = 47ms/frame, INT8 = 15ms/frame
- Tested on Jetson Orin Nano with ONNX Runtime
