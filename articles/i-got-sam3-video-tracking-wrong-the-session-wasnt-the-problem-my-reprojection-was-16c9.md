---
title: "I got SAM3 video tracking wrong: the session wasn't the problem—my reprojection was"
url: "https://dev.to/daniel_romitelli_44e77dc6/i-got-sam3-video-tracking-wrong-the-session-wasnt-the-problem-my-reprojection-was-16c9"
author: "Daniel Romitelli"
category: "3d-ai-generation"
---
# I got SAM3 video tracking wrong: the session wasn't the problem—my reprojection was
**Author:** Daniel Romitelli  **Published:** 2026-03-10

## Overview
Debugging SAM3 (Segment Anything Model) video tracking instability. The apparent flicker was not model instability but inconsistent coordinate system reprojection between frames. Key insight: streaming masks only look unstable when you keep moving the floor under them.

## Key Concepts

### The Core Problem
Video frames have two critical size dimensions:
- Preprocessing size (model input)
- Original frame size (display output)

When these drift between frames, the tracker receives masks in shifting coordinate systems, creating apparent instability.

### The Solution

**1. Session Management:** Create inference sessions once and reuse across frames; restart deliberately when necessary

**2. Consistent Reprojection:** Always reproject model outputs into `original_sizes` before streaming

**3. Mixed-Resolution Handling:** Explicitly manage frames of varying resolutions

**4. State Validation:** Check prerequisites before acting rather than assuming continuity

### Pipeline Bug Example

```python
# Pipeline returns nested list: result.images[0][0] is the PIL Image
if hasattr(result, "images") and len(result.images) > 0:
    img = result.images[0]
    # Unwrap nested list (RGB-X wraps each channel in an extra list)
    if isinstance(img, list) and len(img) > 0:
        img = img[0]
```

### Bounding Box Reprojection

```python
# Scale bbox if it's from a different resolution than the input image
bbox_right = bx + bw
bbox_bottom = by + bh
if bbox_right > img_w or bbox_bottom > img_h:
    scale_x = img_w / max(bbox_right, 1)
    scale_y = img_h / max(bbox_bottom, 1)
```

### Confidence Threshold Tuning
Critical discovery: lowering SAM3's internal confidence threshold was more effective than tracker adjustments:

- Initial: `confidence_threshold = 0.5` → zero segments
- First fix: Lowered to `0.25`
- Optimization: Lowered to `0.15`

"The tracker can't associate what the model refuses to emit."

### iOS Integration Note

```swift
// ARKit camera buffers are always landscape-left orientation.
// Rotate to portrait when device is upright so masks align with on-screen display.
```

### Key Analogy
"Tracking across frames with inconsistent reprojection is like trying to draw on tracing paper while someone keeps swapping the paper size when you blink."
