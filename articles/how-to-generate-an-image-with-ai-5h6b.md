---
title: "How to generate an image with AI?"
url: "https://dev.to/edenai/how-to-generate-an-image-with-ai-5h6b"
author: "Eden AI"
category: "ai-image-video-generation"
---
# How to generate an image with AI?
**Author:** Eden AI  **Published:** 2023-08-16

## Overview
Introduction to AI image generation via unified API, covering the seven-step process from account setup through production monitoring. Eden AI provides a unified API across multiple image generation providers.

## Key Concepts

### What is AI Image Generation?
"Also known as text-to-image generation, image generation refers to the intriguing process of creating new visual content using powerful algorithms." Models (particularly diffusion models) are trained on vast datasets to generate realistic images from text descriptions.

### Seven-Step Implementation Process
1. Register for Eden AI API access (includes $10 free credits)
2. Select appropriate image generation provider
3. Compare outputs from different models
4. Integrate API into software using documentation
5. Make formatted API requests with text descriptions, resolution, and image count
6. Purchase additional credits as needed
7. Monitor performance and scalability

### Core Benefits of Unified API Approach
- Standardized JSON output across multiple providers
- Quick provider switching without code changes
- Simplified integration through response standardization
- Customizable parameters for specific use cases

### API Request Structure
```json
{
  "providers": "openai",
  "text": "A beautiful sunset over the ocean",
  "resolution": "512x512",
  "num_images": 1
}
```

### Supported Providers
Eden AI routes to: OpenAI DALL-E, Stability AI, Amazon Titan, and others via a single API endpoint.

### Use Cases
Applications across art, entertainment, design, and advertising industries. Common uses: product mockups, marketing visuals, concept art, social media content.

### References
- API documentation: docs.edenai.co
- Free tier: $10 credits on signup
