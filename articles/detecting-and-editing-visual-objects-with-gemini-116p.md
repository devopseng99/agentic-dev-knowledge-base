---
title: "Detecting and Editing Visual Objects with Gemini"
url: "https://dev.to/picardparis/detecting-and-editing-visual-objects-with-gemini-116p"
author: "picardparis"
category: "ai-image-video-generation"
---
# Detecting and Editing Visual Objects with Gemini
**Author:** picardparis  **Published:** 2026-03-03

## Overview
Demonstrates using Google's Gemini API for visual object detection and image editing — combining Gemini's multimodal understanding with image manipulation for practical developer workflows.

## Key Concepts

### Gemini's Visual Capabilities
Gemini can both understand and generate images, enabling:
- Object detection with bounding box coordinates
- Semantic image understanding
- Image editing via natural language instructions
- Visual question answering about image content

### Object Detection with Gemini

```python
import google.generativeai as genai
from PIL import Image
import json

genai.configure(api_key="YOUR_GEMINI_API_KEY")
model = genai.GenerativeModel("gemini-2.0-flash-exp")

def detect_objects(image_path: str) -> list:
    """Detect objects in image with bounding boxes."""
    img = Image.open(image_path)

    response = model.generate_content([
        """Detect all objects in this image.
        Return JSON array with format:
        [{"label": "object_name", "box_2d": [y_min, x_min, y_max, x_max]}]
        Coordinates as percentages 0-1000.""",
        img
    ])

    # Parse JSON from response
    text = response.text
    start = text.find('[')
    end = text.rfind(']') + 1
    return json.loads(text[start:end])

# Usage
objects = detect_objects("scene.jpg")
for obj in objects:
    print(f"{obj['label']}: {obj['box_2d']}")
```

### Image Editing with Gemini Imagen

```python
def edit_image_region(image_path: str, instruction: str, output_path: str):
    """Edit specific region of image using natural language."""
    model = genai.GenerativeModel("gemini-2.0-flash-preview-image-generation")
    img = Image.open(image_path)

    response = model.generate_content([
        f"Edit this image: {instruction}. Maintain the rest of the image unchanged.",
        img
    ])

    # Extract generated image from response
    for part in response.candidates[0].content.parts:
        if hasattr(part, 'inline_data'):
            import base64
            from io import BytesIO
            img_data = base64.b64decode(part.inline_data.data)
            edited = Image.open(BytesIO(img_data))
            edited.save(output_path)
            return output_path

    return None

# Usage
edit_image_region(
    "product.jpg",
    "Replace the white background with a wooden table surface",
    "product_edited.jpg"
)
```

### Visual Q&A Pipeline

```python
def answer_visual_question(image_path: str, question: str) -> str:
    """Answer questions about image content."""
    img = Image.open(image_path)
    response = model.generate_content([question, img])
    return response.text

# Examples
answer = answer_visual_question("store_shelf.jpg", "How many products are visible?")
color = answer_visual_question("product.jpg", "What color is the product label?")
damage = answer_visual_question("inspection.jpg", "Are there any visible defects?")
```

### Batch Visual Analysis

```python
from pathlib import Path
import concurrent.futures

def analyze_image_batch(image_dir: str, analysis_prompt: str) -> dict:
    """Analyze multiple images concurrently."""
    results = {}
    image_paths = list(Path(image_dir).glob("*.{jpg,png,webp}"))

    def analyze_single(path):
        img = Image.open(path)
        resp = model.generate_content([analysis_prompt, img])
        return str(path), resp.text

    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        for path, result in executor.map(analyze_single, image_paths):
            results[path] = result

    return results
```

### Pricing (Gemini 2.0 Flash)
- Input: $0.075/M tokens (images counted as tokens)
- Output: $0.30/M tokens
- Significantly cheaper than specialized vision APIs for high-volume use cases
