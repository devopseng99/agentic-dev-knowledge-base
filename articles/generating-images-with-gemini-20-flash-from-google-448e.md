---
title: "Generating images with Gemini 2.0 Flash"
url: "https://dev.to/wescpy/generating-images-with-gemini-20-flash-from-google-448e"
author: "Wesley Chun"
category: "ai-media-generation"
---
# Generating images with Gemini 2.0 Flash
**Author:** Wesley Chun  **Published:** April 7, 2025

## Overview
This tutorial demonstrates how to leverage Google's Gemini 2.0 Flash model for image generation through the Gemini API. The piece walks developers through creating applications that generate images and accompanying captions using both Python and Node.js implementations.

## Key Concepts

- **Gemini 2.0 Flash capabilities:** Image generation with multimodal response support
- **API configuration:** Setting response modalities to include both text and image outputs
- **Free tier access:** Using the free Gemini API tier for experimentation
- **Multiple implementation approaches:** Environment variables vs. local configuration files for API key management

```python
from io import BytesIO
from PIL import Image
from google import genai
from settings import API_KEY

MODEL = 'gemini-2.0-flash-exp'
GENAI = genai.Client(api_key=API_KEY)
CONFIG = genai.types.GenerateContentConfig(
    response_modalities=['Text', 'Image'])
```

```javascript
import * as fs from 'node:fs';
import 'dotenv/config';
import { GoogleGenAI } from '@google/genai';

const MODEL = 'gemini-2.0-flash-exp';
const GENAI = new GoogleGenAI({ apiKey: process.env.API_KEY });
```

```javascript
const fs = require('fs');
require('dotenv').config();
const { GoogleGenAI } = require('@google/genai');
```

- GitHub: https://github.com/wescpy/google/blob/main/gemini/images
- Official Documentation: https://ai.google.dev/gemini-api/docs/image-generation
