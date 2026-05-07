---
title: "Cloudflare Workers AI Has a Free API: Run AI Models at the Edge with Zero Infrastructure"
url: "https://dev.to/0012303/cloudflare-workers-ai-has-a-free-api-run-ai-models-at-the-edge-with-zero-infrastructure-2ibo"
author: "Alex Spinov"
category: "ai-agent-cloudflare-workers"
---

# Cloudflare Workers AI Has a Free API: Run AI Models at the Edge with Zero Infrastructure

**Author:** Alex Spinov
**Published:** March 28, 2026

## Overview
Workers AI is a Cloudflare service enabling developers to run AI models on edge networks without GPU provisioning. The free tier offers 10,000 neurons/day sufficient for approximately 100+ requests. Supports text generation, embeddings, image classification, image generation, translation, speech-to-text, and summarization.

## Key Concepts

Workers AI runs models at Cloudflare's edge, providing low-latency AI inference globally without managing any GPU infrastructure. Models include Llama 3.1 8B, BGE Base embeddings, ResNet-50, Stable Diffusion XL, M2M-100 translation, Whisper STT, and BART summarization.

## Code Examples

### Project Setup

```bash
npm create cloudflare@latest
```

### Text Generation with Llama

```typescript
const response = await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
  messages: [
    { role: 'system', content: 'You are a helpful assistant' },
    { role: 'user', content: 'What is Cloudflare Workers AI?' }
  ]
});
```

### Streaming Responses

```typescript
const stream = await env.AI.run('@cf/meta/llama-3.1-8b-instruct', {
  messages: [{ role: 'user', content: 'Tell me a story' }],
  stream: true
});

return new Response(stream, {
  headers: { 'content-type': 'text/event-stream' }
});
```

### Text Embeddings

```typescript
const embeddings = await env.AI.run('@cf/baai/bge-base-en-v1.5', {
  text: ['example sentence for embedding']
});
// Returns 768-dimension vectors for semantic search
```

### Image Classification

```typescript
const result = await env.AI.run('@cf/microsoft/resnet-50', {
  image: binaryImageData
});
```

### Image Generation

```typescript
const image = await env.AI.run('@cf/stabilityai/stable-diffusion-xl-base-1.0', {
  prompt: 'a futuristic city at sunset'
});
```

### Translation

```typescript
const translation = await env.AI.run('@cf/meta/m2m100-1.2b', {
  text: 'Hello, how are you?',
  source_lang: 'en',
  target_lang: 'es'
});
```

### Speech-to-Text

```typescript
const transcription = await env.AI.run('@cf/openai/whisper', {
  audio: audioBuffer
});
```

### REST API Access

```bash
curl https://api.cloudflare.com/client/v4/accounts/{account_id}/ai/run/@cf/meta/llama-3.1-8b-instruct \
  -H "Authorization: Bearer {API_TOKEN}" \
  -d '{"messages":[{"role":"user","content":"Hello"}]}'
```
