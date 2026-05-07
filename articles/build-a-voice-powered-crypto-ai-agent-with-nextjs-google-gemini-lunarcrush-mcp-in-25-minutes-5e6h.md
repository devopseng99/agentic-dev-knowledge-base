---
title: "Build a Voice-Powered Crypto AI Agent with Next.js + Google Gemini + LunarCrush MCP in 25 Minutes"
url: "https://dev.to/dbatson/build-a-voice-powered-crypto-ai-agent-with-nextjs-google-gemini-lunarcrush-mcp-in-25-minutes-5e6h"
author: "Danilo Jamaal"
category: "web3-blockchain-agents"
---

# Build a Voice-Powered Crypto AI Agent with Next.js + Google Gemini + LunarCrush MCP in 25 Minutes
**Author:** Danilo Jamaal
**Published:** July 1, 2025

## Overview
Tutorial for creating a voice-controlled cryptocurrency analysis assistant combining Next.js, TypeScript, MCP integration with LunarCrush, Google Gemini for AI processing, and browser speech APIs for voice input/output.

## Key Concepts

### Architecture
The core API route (/api/analyze) orchestrates a seven-step pipeline: extract cryptocurrency symbols from natural language, initialize MCP client to LunarCrush, retrieve available tools, instruct Gemini to select analysis tools, execute tool calls concurrently, and synthesize findings into trading recommendations.

### Custom React Hooks
- useVoiceRecognition: Captures continuous speech input with browser speech recognition APIs
- useVoiceOutput: Provides synthesized speech responses with adjustable rate, volume, and voice selection

### UI Components
- AnalysisProgress: Multi-step animated progress tracker with estimated time remaining
- AnalysisResults: Formatted metrics cards, recommendation badges, and detailed analysis summaries
- Number formatting utilities scale large values into readable formats (e.g., "10M")
