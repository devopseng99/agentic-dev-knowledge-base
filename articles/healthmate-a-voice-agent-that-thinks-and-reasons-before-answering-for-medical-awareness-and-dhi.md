---
title: "HealthMate - A Voice Agent That Thinks and Reasons Before Answering for Medical Awareness and Decision Support"
url: "https://dev.to/manojkumar18/healthmate-a-voice-agent-that-thinks-and-reasons-before-answering-for-medical-awareness-and-dhi"
author: "Manoj Kumar Pendem"
category: "healthcare-ai-agent"
---

# HealthMate - A Voice Agent for Medical Awareness

**Author:** Manoj Kumar Pendem
**Published:** July 28, 2025

## Overview

HealthMate is a voice-activated AI assistant for accessible health information targeting underserved populations. It combines real-time voice streaming, speech recognition, and clinical reasoning to deliver safe medical guidance. Addresses the gap where 3.6 billion people lack access to basic healthcare.

## Key Concepts

### Technology Stack
- LiveKit: Real-time WebRTC voice streaming (~300ms latency)
- AssemblyAI: Speech-to-text with medical vocabulary support
- Gemini/GPT: LLM reasoning and interpretation
- ChromaDB: Vector database for medical knowledge retrieval
- FastAPI: Python backend
- React + Tailwind: Frontend

### System Architecture

1. User speaks query -> LiveKit captures audio
2. AssemblyAI converts speech to text with Voice Activity Detection
3. RAG + LLM processes the transcription
4. ChromaDB performs vector searches in curated medical database
5. Clinical reasoning layer applies safety checks
6. System returns voice-ready response

### AssemblyAI Configuration

```python
stt = assemblyai.STT(
    api_key=ASSEMBLYAI_API_KEY,
    end_of_turn_confidence_threshold=0.7,
    min_end_of_turn_silence_when_confident=160,
    max_turn_silence=2400,
)
```

### LLM Integration

```python
def webhook_llm_function(prompt: str) -> str:
    response = requests.post("http://localhost:8000/api/query",
                            json={"query": prompt})
    return response.json().get("answer", "No answer received.")
```

### Agent Setup

```python
agent = Agent(
    name="HealthMate Voice Agent",
    session_factory=lambda: AgentSession(
        stt=stt,
        llm=llm,
        tts=None
    ),
)
```

### Development Challenges and Solutions

| Challenge | Solution |
|-----------|----------|
| Voice cutoff timing | Tuned confidence thresholds and silence detection |
| Audio synchronization lag | Optimized buffer settings and thread management |
| Slow LLM responses | Loading states and response caching |
| CORS policy blocks | FastAPI CORS middleware |
| API key exposure | .env in .gitignore, rotated compromised credentials |
