---
title: "Huggingface.js: Quick-Guide to Getting Started"
url: "https://dev.to/digital-nomad/huggingfacejs-quick-guide-to-getting-started-2mg"
author: "Olu"
category: "huggingface-llm-agents"
---
# Huggingface.js: Quick-Guide to Getting Started
**Author:** Olu  **Published:** January 10, 2024

## Overview
This tutorial introduces Hugging Face, a community-driven platform for machine learning and AI. The author explains the platform's core offerings, benefits of joining, and provides a practical Node.js implementation example for image captioning tasks using the @huggingface/inference SDK.

## Key Concepts
- Hugging Face Platform — community-centered ML/AI hub for creating, fine-tuning, and deploying models
- Model Hub Resources — 350K+ pre-trained models, 75K+ datasets, 150K+ live demo spaces
- Core Features — model hosting, dataset management, inference API, model deployment
- Inference Library — JavaScript SDK for accessing Hugging Face models programmatically

## Code Examples

### Installation
```bash
npm init -y
npm i @huggingface/inference dotenv
```

### JavaScript/Node.js Image Captioning
```javascript
import { HfInference } from "@huggingface/inference"
import dotenv from "dotenv"

dotenv.config()

const HF_ACCESS_TOKEN = process.env.HF_ACCESS_TOKEN
const inference = new HfInference(HF_ACCESS_TOKEN)
const model = ""
const imageUrl = "https://ankur3107.github.io/assets/images/image-captioning-example.png"

const response = await fetch(imageUrl)
const imageBlob = await response.blob()

const results = await inference.imageToText({
   data: imageBlob,
   model: model,
})

console.log(results)
```

### Package Configuration
```json
{
  "main": "huggingface.js",
  "type": "module"
}
```

### Run
```bash
node huggingface.js
```
