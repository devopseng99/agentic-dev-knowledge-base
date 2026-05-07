---
title: "JSON Style Guides for Controlled Image Generation with GPT-4o and GPT-Image-1"
url: "https://dev.to/worldlinetech/json-style-guides-for-controlled-image-generation-with-gpt-4o-and-gpt-image-1-36p"
author: "raphiki (Worldline Technology)"
category: "ai-media-generation"
---
# JSON Style Guides for Controlled Image Generation with GPT-4o and GPT-Image-1
**Author:** raphiki (Worldline Technology)  **Published:** May 8, 2025

## Overview
This tutorial demonstrates how structured JSON formatting can enhance AI image generation consistency and control. Rather than relying on natural language prompts alone, developers and designers can use organized JSON schemas to eliminate ambiguity and enable batch processing of visual specifications.

## Key Concepts

- **Structured Prompts:** JSON organizing image specifications into discrete fields
- **Consistency & Repeatability:** Machine-readable formats ensure predictable outputs across multiple generations
- **Separation of Concerns:** Content and style parameters kept distinct for easier iteration
- **Collaboration:** Shared format enables developers and designers to work together systematically

Parameters: scene, subjects (array), style, color_palette, lighting, mood, background, composition, camera settings, medium, textures, resolution, details, effects, and inspirations.

```json
{
  "scene": "a magical forest clearing",
  "subjects": [{"type": "fox", "description": "wearing a wizard hat"}],
  "style": "storybook illustration",
  "color_palette": ["forest green", "gold", "midnight blue"]
}
```

```json
{"type": "robot", "description": "silver body with glowing blue eyes", "position": "foreground"}
```

```json
{"angle": "eye-level", "distance": "medium shot", "lens": "wide-angle"}
```
