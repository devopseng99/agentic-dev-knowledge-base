---
title: "How to Generate AI Images, Videos, Music & Speech Programmatically with JavaScript"
url: "https://dev.to/sebyx07/how-to-generate-ai-images-videos-music-speech-programmatically-with-javascript-ggj"
author: "sebyx07"
category: "ai-media-generation"
---
# How to Generate AI Images, Videos, Music & Speech Programmatically with JavaScript
**Author:** sebyx07  **Published:** March 20, 2026

## Overview
This guide demonstrates how to programmatically generate AI media (images, videos, music, and speech) using a unified JavaScript/TypeScript SDK called `ai-media-cli`. Rather than managing separate APIs for each media type, the package provides a single TypeScript SDK that routes to 90+ models across multiple providers.

## Key Concepts

- **Unified API approach**: One SDK replaces managing multiple provider integrations
- **Async polling pattern**: Media generation requires polling for completion status
- **Model flexibility**: Swap between 91 models by changing a string parameter
- **Prompt engineering**: Specific, layered prompts produce higher quality outputs
- **Parallel processing**: Fire independent generations simultaneously to reduce wait time

```javascript
import { AIImageClient } from "ai-media-cli";

const client = new AIImageClient({
  apiKey: process.env.AI_IMAGE_API_KEY,
});

const generation = await client.generateMedia({
  prompt: "a product photo of wireless headphones on marble surface",
  model: "nano-banana-2",
  aspect_ratio: "1:1",
});

const result = await client.pollForCompletion(generation.generation_id);
const imageUrl = result.outputs?.[0]?.url;
```

```javascript
const generation = await client.generateMedia({
  prompt: "slow-motion ocean waves crashing on rocks at sunset",
  model: "kling-2-6-text-to-video-5s-audio",
  generation_type: "text-to-video",
  aspect_ratio: "16:9",
});

const result = await client.pollForCompletion(generation.generation_id);
```

```javascript
const generation = await client.generateMusic({
  prompt: "upbeat lo-fi hip hop, vinyl crackle, mellow piano chords",
  model: "V5",
  instrumental: true,
});
```

```javascript
const generation = await client.generateDialogue({
  dialogue: [
    { text: "Welcome back to the show.", voice: "Adam" },
    { text: "Thanks for having me.", voice: "Emily" },
  ],
  stability: 0.7,
  language_code: "en",
});
```

```bash
npm install -g ai-media-cli
ai-media-cli login YOUR_API_KEY
ai-media-cli generate -p "product flat lay, minimal" -m nano-banana-2 --wait
```

- GitHub: https://github.com/sebyx07/js-ai-image-cli
- NPM: https://www.npmjs.com/package/ai-media-cli
