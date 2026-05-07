---
title: "Teaching Machines to See (Part 1): Why Vision Is Hard"
url: "https://dev.to/sam_king_2c65e4cd10f8b9d6/teaching-machines-to-see-part-1-why-vision-is-hard-4nhb"
author: "Sam King"
category: "robot-perception"
---
# Teaching Machines to See (Part 1): Why Vision Is Hard
**Author:** Sam King  **Published:** March 23, 2026

## Overview
This article explores why computer vision is fundamentally challenging despite human ease in interpreting images. While humans effortlessly recognize objects, computers face significant obstacles because they perceive images as numerical matrices rather than meaningful scenes.

## Key Concepts
- Images as numerical matrices (pixel values 0-255)
- Image formation through camera lenses and sensors
- **Depth ambiguity:** inability to determine true 3D structure from 2D projections
- **Occlusion ambiguity:** hidden information from object overlap
- **Noise ambiguity:** variations from lighting conditions and environmental factors
- Solutions: contextual information, depth sensors, filtering, multi-frame averaging

Key insight: "Vision to a machine is not just about seeing, but about interpreting incomplete and ambiguous data."

Covers reading images and printing matrix representation using OpenCV, accessing pixel values in BGR format for colored images and grayscale values.
