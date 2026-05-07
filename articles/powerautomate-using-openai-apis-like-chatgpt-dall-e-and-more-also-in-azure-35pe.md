---
title: "#PowerAutomate – Using OpenAI APIs, like ChatGPT, Dall-E and more. Also in Azure!"
url: "https://dev.to/azure/powerautomate-using-openai-apis-like-chatgpt-dall-e-and-more-also-in-azure-35pe"
author: "El Bruno"
category: "ai-image-video-generation"
---
# #PowerAutomate – Using OpenAI APIs, like ChatGPT, Dall-E and more. Also in Azure!
**Author:** El Bruno  **Published:** 2023-04-04

## Overview
Demonstrates integrating OpenAI's image generation API into Power Automate workflows for no-code/low-code automation. Shows how to call DALL-E from Power Platform flows.

## Key Concepts

### Three-Step Power Automate Flow

**Step 1: HTTP Request Action**
Sends a POST request to OpenAI's image generation endpoint with parameters: text prompt, number of images, and desired dimensions.

**Step 2: First JSON Parse**
Processes the initial API response containing metadata and a data collection of generated images.

**Step 3: Second JSON Parse**
Extracts individual image URLs from the response collection using the `first()` function.

### Authentication Details
The HTTP request requires BASIC authentication where "the username is a space character (is required)" and "the password is the OpenAI Key."

### Request Body

```json
{
  "prompt": "A cute puppy playing soccer in the moon, looking at the camera, cartoon style",
  "n": 1,
  "size": "512x512"
}
```

### API Endpoint
`https://api.openai.com/v1/images/generations`

### Use Cases for Power Automate + DALL-E
- Auto-generate images for SharePoint pages
- Create visual assets when new products are added to lists
- Generate email header images based on content
- Automated social media visual creation
- Teams notifications with generated visual context

### Azure OpenAI Service
The article also covers using Azure-hosted OpenAI services (instead of OpenAI directly) for enterprise compliance — same API shape, different endpoint URL with Azure AD authentication.

### Resources
- Recording series: https://aka.ms/OpenAIPowerPlatformSeries
- Author's blog: ElBruno.com
