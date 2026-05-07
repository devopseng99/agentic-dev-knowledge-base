---
title: "Building a Voice-Controlled Web Agent for the Gemini Hackathon"
url: "https://dev.to/azaynul10/building-a-voice-controlled-web-agent-for-the-gemini-hackathon-and-how-i-beat-the-api-rate-limits-13m4"
author: "Zaynul Abedin Miah"
category: "gemini-api-agent"
---

# Building a Voice-Controlled Web Agent for the Gemini Hackathon

**Author:** Zaynul Abedin Miah
**Published:** March 16, 2026

## Overview
IAN (Intelligent Accessibility Navigator) is a multimodal AI Agent that browses the internet using only voice. Uses a dual-model architecture with Gemini 2.5 Native Audio for voice intent and Gemini 2.5 Flash for visual action via Playwright. Built for the Google Gemini Live Agent Challenge.

## Key Concepts

### Dual-Model Architecture

**Voice Intent (Gemini 2.5 Native Audio):**
- Raw audio streamed via WebSockets to backend
- Uses ADK's InMemorySessionService
- Detects Voice Activity, figures out user intent
- Outputs strict tags like `[NAVIGATE: search amazon for shoes]`

**Visual Action (Playwright Automation):**
- Headless Chromium takes screenshots
- Sends to gemini-2.5-flash (vision model)
- AI calculates exact (X, Y) coordinates of UI elements
- Playwright physically clicks and types -- completely ignores the DOM

### Beating Rate Limits

**Concurrency Explosion Fix:**
- asyncio.Lock() prevents ghost-browsers from spawning
- Built a 3.5-second "pacemaker" into the visual reasoning loop
- Forces exactly 15 actions per minute within free-tier API quotas

**Float32 Audio Fix:**
- Browsers capture in Float32 at 44.1kHz
- Gemini Native Audio requires 16kHz, 16-bit PCM
- Custom JavaScript processor to manually downsample and clamp audio chunks

### Key Insight
"Humans don't parse the DOM to use a website. We just look at the screen." -- This approach bypasses DOM parsing entirely, using visual AI to interact with web pages as a human would.
