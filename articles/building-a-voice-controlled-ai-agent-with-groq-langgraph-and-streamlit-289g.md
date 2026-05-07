---
title: "Building a Voice-Controlled AI Agent with Groq, LangGraph, and Streamlit"
url: "https://dev.to/shanttoosh_v/building-a-voice-controlled-ai-agent-with-groq-langgraph-and-streamlit-289g"
author: "Shanttoosh"
category: "groq-api-agent"
---

# Building a Voice-Controlled AI Agent with Groq, LangGraph, and Streamlit

**Author:** Shanttoosh
**Published:** April 14, 2026

## Overview
A transparent voice-controlled agent where you speak and the machine writes files and runs tools on your laptop, with every step visible. Uses Groq's APIs, LangGraph for orchestration, and Streamlit for the interface, with all filesystem operations constrained to a single `output/` folder.

## Key Concepts

### System Workflow
1. User records audio or uploads a clip
2. Groq Whisper (`whisper-large-v3-turbo`) transcribes the speech
3. LLM (`llama-3.1-8b-instant`) classifies intent into categories:
   - Create a file
   - Write code
   - Summarize text
   - Generate content
   - General conversation
4. LangGraph implements a state machine with optional human approval before filesystem operations
5. UI displays transcript, intent label, actions taken, and outcomes

### Why LangGraph Over Single Prompts
LangGraph structures the agent as nodes and edges over a typed `AgentState`. State tracks:
- Audio payload
- Transcript
- Classified intent
- Extracted details (filename, language, content)
- Human-in-the-loop flags
- Output strings for the UI

Compound commands like "summarize this and save it to summary.txt" become sequential steps where earlier outputs feed into later tool calls.

### Tools, Intents, and Sandboxing
The LLM never executes arbitrary commands; it suggests structured actions that Python interprets. Available tools:
- **Create file** and **write code** (filesystem access)
- **Summarize** (compress long passages or generate Markdown)
- **General chat** (everything else)

All paths use `pathlib` and are verified to remain under `output/`. Traversal attacks and malicious filenames are rejected. Secrets reside in `.env`.

### Error Handling
- Retries with exponential backoff for network failures
- Classifier defaults to `general_chat` on JSON parsing errors
- UI surfaces short messages rather than tracebacks

### Performance
- Short LLM calls: ~0.25 seconds post-warmup
- Whisper transcription of ~800 KB WAV: ~1 second median

### How to Run
Clone the repository, create a virtual environment, copy `.env.example` to `.env`, add `GROQ_API_KEY`, then execute `streamlit run app.py`.

**Repository:** https://github.com/shanttoosh/voice-controlled-ai-agent
