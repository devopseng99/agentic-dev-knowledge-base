---
title: "VID2IMG Pro – Video to Image Extraction & Anonymization Tool"
url: "https://dev.to/matetechnologie/vid2img-pro-video-to-image-extraction-anonymization-tool-48h4"
author: "Mate Technologies"
category: "3d-ai-generation"
---
# VID2IMG Pro – Video to Image Extraction & Anonymization Tool
**Author:** Mate Technologies  **Published:** 2026-01-09

## Overview
VID2IMG Pro is a local-first, high-performance video-to-image extraction framework designed for developers building computer vision, AI, photogrammetry, and privacy-aware media pipelines. Extracts frames from video for use in COLMAP, RealityCapture, Meshroom, and Metashape.

## Key Concepts

### Key Features

**Frame Extraction Engine**
- Supports MP4, AVI, and MOV formats
- Interval-based extraction using frame counting
- OpenCV-powered decoding for processing large video files

**Anonymization Capabilities**
- Automated face detection with Gaussian blur
- License plate detection with pixelation
- GDPR-compliant privacy design
- Extensible, modular anonymization logic

**360° Video Support**
- Equirectangular-safe processing
- Prevents seam distortion during processing
- Maintains spatial continuity

**Photogrammetry Mode**
- Lossless PNG output
- Sequential filenames (frame_00001.png format)
- Compatible with RealityCapture, Meshroom, Metashape, and COLMAP

### Technical Stack
- Built on OpenCV, NumPy, and Tkinter/ttkbootstrap
- Python 3.8+ required
- Cross-platform: Windows, macOS, Linux
- Portable Windows EXE available

### Design Principles
- Separation of GUI and processing logic
- Predictable output paths
- Synchronous local execution without external APIs or cloud dependencies
- Privacy-first design

### Use in Photogrammetry Pipelines
The photogrammetry mode is specifically designed to prepare video frames for structure-from-motion and multi-view stereo pipelines. Lossless PNG output preserves maximum detail for downstream 3D reconstruction.
