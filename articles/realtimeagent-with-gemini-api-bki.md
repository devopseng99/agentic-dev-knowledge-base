---
title: "RealtimeAgent with Gemini API"
url: "https://dev.to/ag2ai/realtimeagent-with-gemini-api-bki"
author: "AG2 Blogger"
category: "gemini-api-agent"
---

# RealtimeAgent with Gemini API

**Author:** AG2 Blogger (Stella Xiang, Mark Sze, Tvrtko Sternak, Davor Runje)
**Published:** February 4, 2025

## Overview
AG2's RealtimeAgent now supports Gemini Multimodal Live API, enabling real-time audio processing in live conversational settings. Previously only OpenAI was supported; this extends the framework to Google's Gemini 2.0 multimodal capabilities.

## Key Concepts

### Why Gemini Integration Matters

- Previously AG2 only supported OpenAI-powered Realtime Agent
- Google launched Gemini 2.0 in December 2024 with multi-modal live APIs
- Enables "real-time processing of audio inputs in live conversational settings"
- Minimal developer friction for configuration

### Key Feature: Optimized for Realtime

Low-latency processing makes Gemini suitable for live applications. Combined with AG2's orchestration capabilities, developers can build systems responding in near real-time.

### Known Limitations

Audio truncation is not currently natively supported by Gemini. If a server generates a 10-second audio clip but only 5 seconds play, the server may not recognize the truncation. This affects applications requiring fine-grained audio playback control like interactive storytelling or call centers.

### Future Potential

1. **Customizable LLM Pipelines:** AG2's architecture enables orchestrating workflows involving Gemini and other LLMs (OpenAI, Cohere) for tailored solutions
2. **Expanding Model Ecosystem:** Supporting both OpenAI and Gemini reduces vendor lock-in, allowing teams to experiment with different models for specific needs
