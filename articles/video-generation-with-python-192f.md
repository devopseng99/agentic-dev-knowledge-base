---
title: "Video Generation with Python"
url: "https://dev.to/emigs1995/video-generation-with-python-192f"
author: "Emilia G."
category: "ai-media-generation"
---
# Video Generation with Python
**Author:** Emilia G.  **Published:** March 11, 2024

## Overview
The article demonstrates how to programmatically create customized videos using Python libraries. It addresses the challenge of generating videos at scale and shows practical solutions using MoviePy, SciPy, and ImageMagick.

## Key Concepts

- **MoviePy**: Python module for video editing (Python wrapper for FFMPEG and ImageMagick) providing cutting, concatenation, compositing, and effects capabilities
- **ImageMagick**: Open-source suite for digital image manipulation
- **SciPy**: Library for scientific computing with image processing modules
- **CompositeVideoClip**: Combines multiple clips into a single video
- **TextClip**: Creates stylized text overlays
- **ImageClip**: Renders image files as video elements

```python
import moviepy.editor as mpy
from moviepy.video.tools.segmenting import findObjects

WHITE = (255, 255, 255)
SCREEN_SIZE = (640, 480)
VERTICAL_SPACE=30
HORIZONTAL_SPACE=100
```

```python
SB_LOGO_PATH = "./static/StackBuildersLogo.jpg"
sb_logo = mpy.ImageClip(SB_LOGO_PATH).\
    set_position(('center', 0)).\
    resize(width=200)
```

```python
txt_clip = mpy.TextClip(
    "Let's build together",
    font="Charter-bold",
    color="RoyalBlue4",
    kerning=4,
    fontsize=30,
).set_position(("center", sb_logo.size[1] + VERTICAL_SPACE))
```

```python
CLOCKWISE_ANGLE = -90

def rotate(stars):
    return [
        star.rotate(lambda t: t * CLOCKWISE_ANGLE, expand=False)
        .fx(mpy.vfx.mask_color)
        .set_position(((i + 1) * HORIZONTAL_SPACE, sb_logo.size[1] + txt_clip.size[1] + VERTICAL_SPACE * 2))
        for i, star in enumerate(stars)
    ]
```

```python
final_clip = (
    mpy.CompositeVideoClip([sb_logo, txt_clip] + rotate(stars), size=SCREEN_SIZE)
    .on_color(color=WHITE, col_opacity=1)
    .set_duration(10)
)

final_clip.write_videofile("video_with_python.mp4", fps=10)
```

- GitHub: https://github.com/stackbuilders/blog-code/tree/main/python/python-video-generation
