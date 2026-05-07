---
title: "Building a Voice-Controlled AI Agent with FastAPI, Groq & Streamlit"
url: "https://dev.to/ishan_naikele_74a5355f972/building-a-voice-controlled-ai-agent-with-fastapi-groq-streamlit-5g2l"
author: "Ishan Naikele"
category: "ai-agent-fastapi"
---

# Building a Voice-Controlled AI Agent with FastAPI, Groq & Streamlit

**Author:** Ishan Naikele
**Published:** April 13, 2026

## Overview
Two-component system where users communicate via voice to trigger file operations and code generation. FastAPI backend handles AI inference and file operations; Streamlit frontend manages audio input and result display.

## Key Concepts

### Processing Pipeline
1. Speech-to-text via Groq Whisper-large-v3
2. Intent classification via Llama-3.1-8b JSON routing
3. Execution of local tools for file creation, code writing, summarization, or chat

### Performance
- Speech-to-text: ~720ms
- Intent classification: ~380ms
- Code generation: ~950ms
- Summarization: ~1,350ms

## Code Examples

### System Prompt (Python)

```python
SYSTEM_PROMPT = """
You are a strict JSON routing agent.
Return ONLY valid JSON. No explanation. No markdown. No extra text.

Available intents:
- create_file  -> { filename, content }
- write_code   -> { filename, language, description }
- summarize    -> { text, save_to }
- chat         -> { message }

Always return: { "tasks": [ ...task objects... ] }
Each task: { "intent", "parameters", "confidence" }
Multiple commands -> multiple tasks in the list.
If unclear -> default to "chat".
"""
```

### File Safety Implementation (Python)

```python
OUTPUT_DIR = os.path.abspath("output")

def _safe_path(filename: str) -> str | None:
    target = os.path.abspath(os.path.join(OUTPUT_DIR, filename))
    if not target.startswith(OUTPUT_DIR + os.sep):
        return None
    return target
```
