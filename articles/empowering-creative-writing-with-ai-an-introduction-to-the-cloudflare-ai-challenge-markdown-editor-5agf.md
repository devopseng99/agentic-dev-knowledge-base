---
title: "Empowering Creative Writing with AI: Cloudflare AI Challenge Markdown Editor"
url: "https://dev.to/pavelee/empowering-creative-writing-with-ai-an-introduction-to-the-cloudflare-ai-challenge-markdown-editor-5agf"
author: "Pawel Ciosek"
category: "hackathons"
---

# Empowering Creative Writing with AI: Cloudflare AI Challenge Markdown Editor
**Author:** Pawel Ciosek
**Published:** April 14, 2024

## Overview
A markdown editor with integrated AI capabilities for content creators, featuring multiple selectable language models, AI-powered title generation, and cover image generation via Stable Diffusion.

## Key Concepts

### Storage Abstraction
```typescript
export interface Storage<T> {
  get: (key: string) => Promise<T>;
  set: (key: string, value: string) => Promise<void>;
  remove: (key: string) => Promise<void>;
}
```

- AI models: Llama 2, Mistral, Falcon, Gemma variants
- Title generation: facebook/bart-large-cnn + nousresearch/hermes-2-pro-mistral-7b
- Cover generation: Stable Diffusion XL, DreamShaper
- Next.js on Cloudflare Pages with KV storage
- Philosophy: "Let's be pilots, and keep AI as co-pilot"

### GitHub Repository
- https://github.com/pavelee/cloudflare-challange-post-ai
