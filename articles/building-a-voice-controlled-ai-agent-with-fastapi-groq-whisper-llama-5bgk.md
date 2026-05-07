---
title: "Building a Voice-Controlled AI Agent with FastAPI, Groq Whisper & LLaMA"
url: "https://dev.to/sneha_dhir_649d9b22406fa6/building-a-voice-controlled-ai-agent-with-fastapi-groq-whisper-llama-5bgk"
author: "Sneha Dhir"
category: "ai-agent-fastapi"
---

# Building a Voice-Controlled AI Agent with FastAPI, Groq Whisper & LLaMA

**Author:** Sneha Dhir
**Published:** April 12, 2026

## Overview
Full-stack voice AI system enabling spoken commands for file creation, code generation, and text summarization. Processes audio through speech-to-text conversion, intent classification, and tool execution.

## Key Concepts

### Five Intent Categories
- create_file, write_code, summarize, general_chat, compound

### Performance Benchmarks
| Component | Task | Response Time |
|-----------|------|---|
| Groq Whisper Large v3 | 5-second audio | 180ms |
| Groq LLaMA 3.3 70B | Intent classification | 420ms |
| Groq LLaMA 3.3 70B | Code generation | 1200ms |
| Local Whisper Base (CPU) | 5-second audio | 65,000ms |

Groq cloud services are 150 to 350 times faster than CPU-based local alternatives.

## Code Examples

### Installation

```bash
pip install fastapi uvicorn python-dotenv groq python-multipart
```

### .env Configuration

```
GROQ_API_KEY=your_key_here
LLM_PROVIDER=groq
STT_PROVIDER=groq
```
