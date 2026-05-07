---
title: "Build Your Own Open Source Copilot with Pieces"
url: "https://dev.to/getpieces/build-your-own-open-source-copilot-with-pieces-2bcm"
author: "Pieces"
category: "enterprise-clones"
---

# Build Your Own Open Source Copilot with Pieces
**Author:** Pieces
**Published:** February 6, 2024

## Overview
Pieces OS Client platform for creating custom AI coding assistants that can switch between local and cloud LLMs with context integration.

## Key Concepts

### Available Models
- Local: Mistral AI, Llama 2 (CPU/GPU)
- Cloud: GPT-3.5/4, Gemini, Palm 2

### Code Example
```typescript
const input: Pieces.QGPTStreamInput = {
  question: {
    query,
    relevant: relevanceOutput.relevant,
    model: mistralcpu!.id
  }
};
```

### SDKs Available
TypeScript, Python, Kotlin, Dart

### GitHub Repositories
- https://github.com/pieces-app/pieces-copilot-vanilla-typescript-example
- https://github.com/pieces-app/opensource
