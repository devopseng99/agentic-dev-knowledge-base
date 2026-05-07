---
title: "Building a streaming AI companion in your own API"
url: "https://dev.to/samvanhoutte/building-a-streaming-ai-companion-in-your-own-api-4e3i"
author: "Sam Vanhoutte"
category: "flink-kafka-agents"
---

# Building a streaming AI companion in your own API
**Author:** Sam Vanhoutte
**Published:** May 2, 2026

## Overview
Architecture for a conversational AI assistant using SSE streaming through a custom API. Routes requests through own API for authentication, monitoring, and context enrichment rather than exposing Azure AI credentials to clients.

## Key Concepts
- Anti-hallucination check tracks surfaced IDs vs emitted IDs; only entities in both sets appear
- SSE streams text deltas continuously, final envelope contains validated text + structured card data
- AIProjectClient handles Azure auth via managed identity
- CompanionContextBuilder injects fresh system instructions each turn with location context
- Tools record accessible entity IDs for validation
- Pattern isolates Azure SDK in single class for future provider changes
