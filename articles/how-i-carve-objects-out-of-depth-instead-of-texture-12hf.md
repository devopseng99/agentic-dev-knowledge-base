---
title: "How I Carve Objects Out of Depth Instead of Texture"
url: "https://dev.to/daniel_romitelli_44e77dc6/how-i-carve-objects-out-of-depth-instead-of-texture-12hf"
author: "Daniel Romitelli"
category: "3d-ai-generation"
---
# How I Carve Objects Out of Depth Instead of Texture
**Author:** Daniel Romitelli  **Published:** 2026-03-29

## Overview
A depth segmentation pipeline that operates on geometric structure rather than visual texture. The system processes depth maps to detect walls, windows, doors, and trim using RANSAC plane fitting and connected component analysis—requiring no RGB data.

## Key Concepts

### Pipeline Architecture
Browser → API route → GPU server, performing sequential operations:
- Thresholding
- Connected component analysis
- Surface discontinuity detection
- Hole handling
- Region labeling

### Key Code Example

The Next.js API route forwards depth payloads to a GPU service:

```javascript
export async function POST(request: NextRequest) {
  const body = await request.json();
  const gpuServerUrl = process.env.SAM3_SERVER_URL;
  const response = await fetch(`${gpuServerUrl}/segment/depth`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  return NextResponse.json(data);
}
```

### Geometric Testing
The system includes a `GeometryAnalysis` interface tracking:
- Surface flatness
- Depth peaks
- Complexity classification
- Confidence factors

The pipeline "refuses to collapse geometry into a yes-or-no answer," offering nuanced classifications: flat, angled, or multi-plane surfaces.

### Multi-Reference Validation
When both doors and windows are detected, the system compares scale estimates and warns if ratios fall outside 0.85–1.15 ranges, preferring doors as primary references.

### Low-Light Performance
The system's strength lies in zero-light scenarios where RGB fails but LiDAR depth maps remain readable, enabling structure extraction when traditional segmentation would fail completely.
