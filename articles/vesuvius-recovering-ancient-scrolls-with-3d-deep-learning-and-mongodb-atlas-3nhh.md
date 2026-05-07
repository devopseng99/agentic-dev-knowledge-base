---
title: "Vesuvius - Recovering Ancient Scrolls with 3D Deep Learning and MongoDB Atlas"
url: "https://dev.to/hridya_siddu/vesuvius-recovering-ancient-scrolls-with-3d-deep-learning-and-mongodb-atlas-3nhh"
author: "Hridya Siddu"
category: "3d-ai-generation"
---
# Vesuvius - Recovering Ancient Scrolls with 3D Deep Learning and MongoDB Atlas
**Author:** Hridya Siddu  **Published:** 2026-04-28

## Overview
Vesuvius_ is an end-to-end machine learning system designed to detect papyrus surfaces in 3D CT scans of carbonized ancient scrolls from Herculaneum. The project integrates a 3D UNet segmentation model with MongoDB Atlas for persistence and analytics.

## Key Concepts

### The Problem
CT volumes are gigabytes of 3D data. You cannot load a full scroll into GPU memory at once. Additional challenges include class imbalance and noise in scanning data.

### Architecture
Four-stage pipeline:
1. Preprocessing
2. 3D UNet modeling
3. Inference using sliding-window patch strategy
4. Streamlit application layer

### Model Details
- 3D UNet following nnU-Net v2 framework
- 5 encoder/decoder stages with skip connections
- BCE + Dice loss function (50/50 blend)
- 300 epochs trained on Tesla P100 GPU

### MongoDB Integration
- Flexible document schema for evolving inference metrics
- Aggregation pipelines for multi-metric analytics using `$facet` operations
- Indexes on timestamp, model_file, and dice_score for query performance
- Dual-mode fallback (cloud or in-memory)

### Results
- Validation Dice Score: 0.812
- IoU (Jaccard): 0.698
- Peak memory usage: ~2.1 GB RAM

## GitHub Links
- https://github.com/sahasramain-byte/vesuvious_
