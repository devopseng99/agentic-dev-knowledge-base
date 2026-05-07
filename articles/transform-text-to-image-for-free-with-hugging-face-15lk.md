---
title: "Transform Text to Image for Free with Hugging Face"
url: "https://dev.to/kiraaziz/transform-text-to-image-for-free-with-hugging-face-15lk"
author: "kiraaziz"
category: "huggingface-llm-agents"
---
# Transform Text to Image for Free with Hugging Face
**Author:** kiraaziz  **Published:** September 28, 2024

## Overview
The article demonstrates how to use Hugging Face's text-to-image models to generate images from text prompts. The author references their application "Light AI" as a practical implementation. The guide walks readers through account creation, model selection, testing, and API integration using the FLUX.1 model.

## Key Concepts
- Text-to-image generation using machine learning models
- Hugging Face platform and API access
- FLUX.1 model — recommended free option from black-forest-labs
- API authentication and JavaScript-based integration
- Image generation via POST request returning a Blob

## Code Examples

### JavaScript - API Query Function
```javascript
async function query(data) {
    const response = await fetch(
        "https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev",
        {
            headers: {
                Authorization: "Bearer hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                "Content-Type": "application/json",
            },
            method: "POST",
            body: JSON.stringify(data),
        }
    );
    const result = await response.blob();
    return result;
}

query({"inputs": "Astronaut riding a horse"}).then((response) => {
    // Use image blob
    const url = URL.createObjectURL(response);
    document.getElementById('image').src = url;
});
```
