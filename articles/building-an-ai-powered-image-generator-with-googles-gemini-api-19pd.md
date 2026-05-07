---
title: "Building an AI-Powered Image Generator with Google's Gemini API"
url: "https://dev.to/manthanank/building-an-ai-powered-image-generator-with-googles-gemini-api-19pd"
author: "Manthan Ankolekar"
category: "ai-media-generation"
---
# Building an AI-Powered Image Generator with Google's Gemini API
**Author:** Manthan Ankolekar  **Published:** March 18, 2025

## Overview
This tutorial demonstrates building a REST API using Node.js and Express that leverages Google's Generative AI to create images from text prompts. The project showcases practical integration with the Gemini API for AI-powered creative applications.

## Key Concepts
- REST API design with Express.js
- Google Generative AI SDK integration
- Base64 image encoding and file system operations
- Environment variable management
- Error handling in asynchronous operations

```javascript
const app = require("./app");
const { port } = require("./config/env");

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
```

```javascript
const { generateImage } = require("../services/geminiService");

async function generateImageController(req, res) {
  const { prompt } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: "Prompt is required" });
  }

  try {
    const imagePath = await generateImage(prompt);
    res.status(200).json({ message: "Image generated successfully", imagePath });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

module.exports = { generateImageController };
```

```javascript
const { GoogleGenerativeAI } = require("@google/generative-ai");
const fs = require("fs");
const path = require("path");
const { geminiApiKey } = require("../config/env");

const genAI = new GoogleGenerativeAI(geminiApiKey);

async function generateImage(prompt) {
  const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash-exp-image-generation",
    generationConfig: { responseModalities: ['Text', 'Image'] }
  });

  try {
    const response = await model.generateContent(prompt);
    for (const part of response.response.candidates[0].content.parts) {
      if (part.inlineData) {
        const imageData = part.inlineData.data;
        const buffer = Buffer.from(imageData, 'base64');
        const filePath = path.join(__dirname, '../temp/generated_image.png');
        fs.writeFileSync(filePath, buffer);
        return filePath;
      }
    }
  } catch (error) {
    console.error("Error generating image:", error);
    throw new Error("Failed to generate image");
  }
}

module.exports = { generateImage };
```

- GitHub: https://github.com/manthanank/gemini-image-generator
