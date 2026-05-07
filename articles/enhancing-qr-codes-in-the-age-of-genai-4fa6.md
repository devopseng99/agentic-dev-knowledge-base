---
title: "Enhancing QR Codes in the Age of GenAI"
url: "https://dev.to/raphiki/enhancing-qr-codes-in-the-age-of-genai-4fa6"
author: "Raphael Semeteys"
category: "ai-image-video-generation"
---
# Enhancing QR Codes in the Age of GenAI
**Author:** Raphael Semeteys  **Published:** 2025-05-23

## Overview
Uses Stable Diffusion ControlNet to generate artistic QR codes that remain scannable while blending seamlessly with decorative imagery — a practical AI image generation use case for marketing and branding.

## Key Concepts

### The Problem with Standard QR Codes
Plain QR codes are visually unappealing. Brands want QR codes that match their aesthetic but remain functional and scannable.

### GenAI Solution: ControlNet + QR Code
The technique uses a QR code image as a control signal in ControlNet, allowing Stable Diffusion to generate an artistic image while embedding the QR code pattern into the visual.

### QR Code Generation

```python
import qrcode
from PIL import Image

def generate_qr_code(url: str, size: int = 512) -> Image.Image:
    """Generate high-contrast QR code for ControlNet input."""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_H,  # High = 30% recovery
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")
    return img.resize((size, size))

qr_img = generate_qr_code("https://example.com/product-page")
qr_img.save("qr_control.png")
```

### ComfyUI ControlNet Pipeline

The ComfyUI workflow uses:
1. Load QR code image as ControlNet input
2. Apply "brightness" ControlNet preprocessor (preserve dark/light pattern)
3. Set ControlNet weight: 1.3-1.5 (higher than typical for QR scanability)
4. Generate with thematic prompt

```python
# Programmatic approach via ComfyUI API
import requests
import json

workflow = {
    "1": {
        "class_type": "LoadImage",
        "inputs": {"image": "qr_control.png"}
    },
    "2": {
        "class_type": "ControlNetLoader",
        "inputs": {"control_net_name": "control_v1p_sd15_brightness.safetensors"}
    },
    "3": {
        "class_type": "ControlNetApply",
        "inputs": {
            "control_net": ["2", 0],
            "image": ["1", 0],
            "strength": 1.4  # Key: high strength for QR scanability
        }
    },
    # ... KSampler, VAE decode nodes
}

response = requests.post(
    "http://127.0.0.1:8188/prompt",
    json={"prompt": workflow}
)
```

### Prompt Strategy for Branded QR Codes

```python
prompts = {
    "forest_qr": "Dense magical forest, dappled sunlight through leaves, "
                 "vibrant greens and golds, photorealistic",
    "space_qr": "Nebula and stars, deep purple and blue, "
                "cosmic energy, digital art",
    "coffee_qr": "Steaming coffee on rustic table, warm browns, "
                 "cozy cafe atmosphere, photorealistic"
}
```

### Scanability Tuning
Key parameters:
- **ControlNet strength:** 1.2-1.6 (higher = more scannable but less artistic)
- **Error correction:** Always use HIGH (30% recovery) in QR generation
- **QR version:** Keep small (v1-v3); larger QR = more modules = easier to embed
- **Testing:** Test scan with multiple apps after generation

### Results
With proper tuning (strength ≈ 1.4, HIGH error correction), roughly 85% of generated artistic QR codes are scannable in good lighting. Post-processing with slight contrast enhancement improves scanability further.

### Practical Use Cases
- Brand marketing materials
- Product packaging
- Event posters and banners
- Restaurant menus
- Business card QR codes
