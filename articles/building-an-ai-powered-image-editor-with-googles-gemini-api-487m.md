---
title: "Building an AI-Powered Image Editor with Google's Gemini API"
url: "https://dev.to/manthanank/building-an-ai-powered-image-editor-with-googles-gemini-api-487m"
author: "Manthan Ankolekar"
category: "ai-media-generation"
---
# Building an AI-Powered Image Editor with Google's Gemini API
**Author:** Manthan Ankolekar  **Published:** March 18, 2025

## Overview
The article documents construction of the Gemini Image Editor, a Node.js REST API enabling users to upload an image, describe modifications, and receive an AI-enhanced version leveraging Google's Gemini API for intelligent image transformation.

## Key Concepts
- AI-powered image modification via text prompts
- File upload handling with Multer middleware
- Google Generative AI SDK integration
- Base64 image encoding/decoding
- Express.js REST API architecture

```javascript
const app = require("./app");
const { port } = require("./config/env");
const fs = require("fs");

if (!fs.existsSync("uploads")) {
  fs.mkdirSync("uploads");
}

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
```

```javascript
async function modifyImage(prompt, imagePath) {
  const imageData = fs.readFileSync(imagePath);
  const base64Image = imageData.toString("base64");

  const contents = [
    { text: prompt },
    {
      inlineData: {
        mimeType: "image/png",
        data: base64Image,
      },
    },
  ];

  const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash-exp-image-generation",
    generationConfig: {
      responseModalities: ["Text", "Image"],
    },
  });

  try {
    const response = await model.generateContent(contents);
    for (const part of response.response.candidates[0].content.parts) {
      if (part.inlineData) {
        const imageData = part.inlineData.data;
        const buffer = Buffer.from(imageData, "base64");
        const outputPath = `uploads/modified_${Date.now()}.png`;
        fs.writeFileSync(outputPath, buffer);
        return outputPath;
      }
    }
  } catch (error) {
    console.error("Error modifying image:", error);
    throw new Error("Failed to modify image");
  }
}
```

- GitHub: https://github.com/manthanank/gemini-image-editor
