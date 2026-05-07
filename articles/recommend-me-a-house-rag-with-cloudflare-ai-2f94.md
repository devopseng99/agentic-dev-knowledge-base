---
title: "Recommend me a House - RAG with Cloudflare AI"
url: "https://dev.to/fahminlb33/recommend-me-a-house-rag-with-cloudflare-ai-2f94"
author: "Fahmi Noor Fiqri"
category: "cloudflare-vectorize"
---

# Recommend me a House - RAG with Cloudflare AI
**Author:** Fahmi Noor Fiqri
**Published:** April 14, 2024

## Overview
Q&A chat app for house recommendations using RAG with Cloudflare AI. Supports text and image queries with 100 house listings. Uses multiple AI models for a complete pipeline.

## Key Concepts

### AI Models
- Text Generation: `@cf/meta/llama-2-7b-chat-int8`
- Text Summarization: `@cf/facebook/bart-large-cnn`
- Text Embedding: `@cf/baai/bge-large-en-v1.5`
- Image-to-Text: `@cf/unum/uform-gen2-qwen-500m`
- Image Embedding: MobileNet v3 (TensorFlow.js)

### RAG Pipeline
1. Query Agent - Maintains context from previous prompts
2. Semantic Search - Embedding models query Vectorize
3. Answer Agent - Generates summaries using retrieved documents

### Stack
Backend: itty-router, Drizzle ORM, TensorFlow.js. Frontend: React, Radix UI, Tailwind. Cloudflare: Workers, Pages, AI, Vectorize, D1, R2.
