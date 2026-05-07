---
title: "On Device Models and How They Work in the Browser Thanks to Web Assembly and WebGPU"
url: "https://dev.to/aileenvl/on-device-models-and-how-they-work-in-the-browser-thanks-to-web-assembly-and-webgpu-5bo6"
author: "aileenvl"
category: "huggingface-llm-agents"
---
# On Device Models and How They Work in the Browser Thanks to Web Assembly and WebGPU
**Author:** aileenvl  **Published:** 2024

## Overview
This article explores how AI models can run directly in web browsers using WebAssembly and WebGPU technologies, with Transformers.js as the key library enabling this capability. The article explains the technical architecture that makes client-side AI inference possible without sending data to external servers.

## Key Concepts
- WebAssembly (WASM) — enables near-native code execution speeds in the browser
- WebGPU — provides GPU acceleration for AI inference in browser environments
- ONNX Runtime — cross-platform format allowing models to run without framework dependencies
- Transformers.js — JavaScript library from Hugging Face that uses ONNX Runtime under the hood
- Privacy benefit — user data never leaves the browser, crucial for sensitive applications

## Technical Architecture

```
Hugging Face Hub (Python models)
         ↓
   Convert to ONNX format
         ↓
   Transformers.js library
         ↓
   ONNX Runtime Web
         ↓
   WebAssembly (CPU) or WebGPU (GPU)
         ↓
   Browser execution (fully local)
```

## Code Examples

### Basic Transformers.js Setup
```javascript
import { pipeline } from '@xenova/transformers';

// Sentiment analysis running entirely in browser
const classifier = await pipeline(
    'sentiment-analysis',
    'Xenova/distilbert-base-uncased-finetuned-sst-2-english'
);

const result = await classifier('I love running AI in the browser!');
console.log(result);
// [{ label: 'POSITIVE', score: 0.9998 }]
```

### WebGPU Accelerated Model
```javascript
import { pipeline, env } from '@xenova/transformers';

// Enable WebGPU acceleration
env.backends.onnx.wasm.proxy = false;

// Use WebGPU device for faster inference
const generator = await pipeline(
    'text-generation',
    'Xenova/gpt2',
    { device: 'webgpu' }
);

const output = await generator('The browser can now run AI', {
    max_new_tokens: 50
});
console.log(output[0].generated_text);
```

### Feature Detection
```javascript
// Check if WebGPU is available
if ('gpu' in navigator) {
    const adapter = await navigator.gpu.requestAdapter();
    if (adapter) {
        console.log('WebGPU available - using GPU acceleration');
    }
} else {
    console.log('WebGPU not available - falling back to WebAssembly');
}
```

## Benefits of On-Device Models
- Privacy — medical records, legal documents, personal data stay local
- Offline functionality — works without internet connection
- No API costs — no per-request pricing
- Low latency — no network round-trip
