---
title: "Building a Voice-Controlled AI Agent with Groq and Streamlit"
url: "https://dev.to/minal43/building-a-voice-controlled-ai-agent-with-groq-and-streamlit-3bc3"
author: "Minal"
category: "agent-ui-frameworks"
---

# Building a Voice-Controlled AI Agent with Groq and Streamlit
**Author:** Minal
**Published:** April 12, 2026

## Overview
Four-step AI pipeline converting voice commands to executable actions: Whisper transcription, LLaMA 3.3 70B intent classification, tool execution, and Streamlit display with sandboxed file operations.

## Key Concepts

### Structured Intent Classification
```json
{
  "intent": "write_code",
  "confidence": "high",
  "filename": "factorial.py",
  "language": "python"
}
```

### Safe File Path Enforcement
```python
OUTPUT_DIR = Path("output")
file_path = OUTPUT_DIR / safe_filename(filename)
```

### Stack
- Whisper Large v3 for speech-to-text via Groq API
- LLaMA 3.3 70B for intent/generation at 200+ tokens/second
- Streamlit for UI with session memory for multi-turn conversations
- Human-in-the-loop confirmation before file-modifying operations
