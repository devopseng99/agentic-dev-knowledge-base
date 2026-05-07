---
title: "DALL-E with Node.js"
url: "https://dev.to/djibrilm/dall-e-with-nodejs-5chb"
author: "djibril mugisho"
category: "ai-media-generation"
---
# DALL-E with Node.js
**Author:** djibril mugisho  **Published:** March 18, 2023

## Overview
This tutorial demonstrates integrating OpenAI's DALL-E image generation API into Node.js applications. The author covers account setup, API authentication, generating images from text prompts, creating image variations, and saving generated images locally.

## Key Concepts
- OpenAI API authentication and configuration
- Image generation from text prompts using DALL-E
- Creating variations of existing images
- Supported image dimensions (256x256, 512x512, 1024x1024)
- Image variation requirements (PNG format, square, <4MB)
- File I/O operations for storing generated images

```javascript
const express = require("express");
const openai = require('openai');
const bodyparser = require('body-parser');

const app = express();
app.use(bodyparser.json());

app.post('/createImage', async (req, res, next) => {
  try {
    const prompt = req.body.prompt;
    const config = new openai.Configuration({
      apiKey: "your API key",
    });
    const openaiApi = new openai.OpenAIApi(config);
    const createImage = await openaiApi.createImage({
      prompt: prompt,
      n: 1,
      size: "512x512",
    })
    return res.status(201).json({ imageUrl: createImage.data.data[0].url });
  } catch (error) {
    return res.status(500).json({ message: "internal server error" });
  }
})

app.listen(8080, () => {
  console.log('server started on port 8080');
})
```

```javascript
app.post('/createVariation', async (req, res, next) => {
  const config = new openai.Configuration({
    apiKey: "your API key",
  });
  const openaiApi = new openai.OpenAIApi(config);
  const image = path.join(__dirname, './image.png');
  const file = fs.createReadStream(image);

  try {
    const createVariation = await openaiApi.createImageVariation(
      file,
      2,
      "1024x1024",
    )
    const result = createVariation.data.data;
    return res.status(202).json({ imageUrl: result });
  } catch (error) {
    return res.status(500).json({ message: error.message, error: error });
  }
})
```

```javascript
const result = "your image URL";
const fetchFile = await fetch(result);
const responseBlob = await fetchFile.blob();
const arrayBuffer = await responseBlob.arrayBuffer();
const buffer = Buffer.from(arrayBuffer);
const filePath = path.join(__dirname, './' + new Date() + ".png");
const writeFileToDisc = fs.writeFileSync(filePath, buffer);
```

```bash
npm install express nodemon openai body-parser
```
