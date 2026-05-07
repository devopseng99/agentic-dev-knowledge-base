---
title: "Build Voice AI Next.js Apps with OpenAI Realtime API Beta (WebRTC) & shadcn/ui"
url: "https://dev.to/cameronking4/build-voice-ai-nextjs-apps-with-openai-realtime-api-beta-webrtc-shadcnui-330a"
author: "Cameron King"
category: "voice-agents"
---

# Build Voice AI Next.js Apps with OpenAI Realtime API Beta (WebRTC) & shadcn/ui

**Author:** Cameron King
**Published:** December 21, 2024

---

## Overview

This article introduces developers to building voice-enabled AI assistants using OpenAI's Realtime API (announced in December 2024) integrated with Next.js and shadcn/ui components. The featured starter template simplifies the process of creating speech-to-speech applications.

## Key Features

The `shadcn-openai-realtime-api` repository provides:

- **WebRTC Audio Streaming:** Captures microphone input and streams audio data in real-time
- **OpenAI Realtime API Integration:** Processes audio inputs and generates natural speech responses
- **Tool Calling:** Includes example functions like `getCurrentTime`, `partyMode`, `changeBackground`, and `launchWebsite`
- **UI Components:** Leverages shadcn/UI and Tailwind CSS for rapid development

## Getting Started

**Clone and Install:**
```bash
git clone https://github.com/cameronking4/shadcn-openai-realtime-api.git
cd shadcn-openai-realtime-api
pnpm i && pnpm dev
```

**Environment Setup:**
```
OPENAI_API_KEY=sk-proj-...
```

## Additional Resources

The article mentions the `openai-realtime-blocks` repository, which offers pre-built, styled components designed for WebRTC integration. These include morphing globes, Siri recreations, ChatGPT animations, and 3D orbs.

**Live demos available at:**
- Main project: [openai-rt-shadcn.vercel.app](https://openai-rt-shadcn.vercel.app/)
- Component library: [openai-realtime-blocks.vercel.app](https://openai-realtime-blocks.vercel.app/)

## Key Takeaway

Developers can now quickly prototype voice AI applications by combining OpenAI's Realtime API with Next.js 15, reducing development time through pre-built components and WebRTC hooks.
