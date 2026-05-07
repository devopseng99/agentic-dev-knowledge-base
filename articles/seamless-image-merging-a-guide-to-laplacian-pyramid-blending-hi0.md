---
title: "Seamless Image Merging: A Guide to Laplacian Pyramid Blending"
url: "https://dev.to/farzon/seamless-image-merging-a-guide-to-laplacian-pyramid-blending-hi0"
author: "Farzon Lotfi"
category: "3d-ai-generation"
---
# Seamless Image Merging: A Guide to Laplacian Pyramid Blending
**Author:** Farzon Lotfi  **Published:** 2026-05-01

## Overview
Laplacian Pyramid Blending creates seamless image collages by treating low-frequency data (lighting, color) separately from high-frequency details (sharp edges). Critical technique for photogrammetry texture atlasing and 3D reconstruction texture seam elimination.

## Key Concepts

### Problem
Simple alpha blending or cut-and-paste produce unnatural transitions and ghosting artifacts in image compositing—problematic for photogrammetry texture reconstruction.

### Solution: Laplacian Pyramid Blending
Uses Gaussian and Laplacian pyramids to blend images at multiple frequency scales.

### Building the Pyramids

**Gaussian Pyramid (REDUCE):**

```python
G = image.copy()
gaussian_pyramid = [G]
for i in range(6):  # Building 6 levels
    G = cv2.pyrDown(G)
    gaussian_pyramid.append(G)
```

**Laplacian Pyramid (EXPAND):**

```python
laplacian_pyramid = [gaussian_pyramid[5]]
for i in range(5, 0, -1):
    GE = cv2.pyrUp(gaussian_pyramid[i])
    L = cv2.subtract(gaussian_pyramid[i-1], GE)
    laplacian_pyramid.append(L)
```

### The Blending Process

Four key steps:
1. Build Laplacian pyramids for both images
2. Create a Gaussian pyramid for the mask
3. Combine pyramids using blending formula:

```
L_O(i,j) = G_R(i,j) * L_A(i,j) + (1 - G_R(i,j)) * L_B(i,j)
```

4. Collapse the combined pyramid to produce the final blended image

### Applications in 3D Reconstruction
Laplacian pyramid blending is foundational for:
- **Texture atlasing in photogrammetry:** Seamlessly merge texture patches from multiple camera views
- **NeRF/Gaussian splat preprocessing:** Improve multi-view consistency in training images
- **SLAM appearance maps:** Blend overlapping image patches in mapping systems
- **Panorama stitching:** Combine fisheye + pinhole camera outputs

### Resources
- GitHub Gist: https://gist.github.com/farzonl/55c74dc9815697c04e112f061758a694
- Google Colab: https://colab.research.google.com/gist/farzonl/55c74dc9815697c04e112f061758a694/laplacian_blend_example.ipynb
