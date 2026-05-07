---
title: "How I Built Vitale — A Multimodal Medical Storytelling Agent with Gemini 3.1 Pro"
url: "https://dev.to/d_saicharan_030505/how-i-built-vitale-a-multimodal-medical-storytelling-agent-with-gemini-31-pro-4ii2"
author: "D SAI CHARAN"
category: "healthcare-ai"
---
# How I Built Vitale — A Multimodal Medical Storytelling Agent with Gemini 3.1 Pro
**Author:** D SAI CHARAN  **Published:** March 15, 2026

## Overview
Vitale transforms medical reports into accessible narratives. Users upload PDF reports and receive warm, personalized storytelling with synchronized illustrations, voiceover audio, and video output—all streamed in real-time to the browser. Privacy-first: no data persistence; medical reports discarded after processing.

## Key Concepts
- Interleaved Output: Gemini 3.1 Pro generates text and image prompts simultaneously using custom tags `[NARRATE]` and `[ILLUSTRATE]`
- Multimodal Pipeline: Narration → TTS audio → Imagen 3 illustrations → Ken Burns video
- Privacy-First Design: no data persistence
- Theme Options: Child-friendly (watercolor cartoon) and adult (minimal flat design) narratives
- Backend: FastAPI on Google Cloud Run
- AI Models: Gemini 3.1 Pro, Imagen 3, Google Cloud TTS
- GitHub: https://github.com/SAI-CHARAN-D/Vitale
- Demo: https://vitale-981966808005.us-central1.run.app/

```
[NARRATE]Your heart health story begins...[/NARRATE]
[ILLUSTRATE]Watercolor illustration of friendly cartoon heart...[/ILLUSTRATE]
```

```yaml
- name: gcr.io/cloud-builders/gcloud
  args:
    - run
    - deploy
    - vitale
    - --set-secrets=GEMINI_API_KEY=GEMINI_API_KEY:latest
```
