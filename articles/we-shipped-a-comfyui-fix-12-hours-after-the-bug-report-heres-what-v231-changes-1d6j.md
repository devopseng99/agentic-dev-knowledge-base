---
title: "we shipped a ComfyUI fix 12 hours after the bug report. here's what v2.3.1 changes."
url: "https://dev.to/purpledoubled/we-shipped-a-comfyui-fix-12-hours-after-the-bug-report-heres-what-v231-changes-1d6j"
author: "David"
category: "ai-image-video-generation"
---
# we shipped a ComfyUI fix 12 hours after the bug report. here's what v2.3.1 changes.
**Author:** David  **Published:** 2026-04-11

## Overview
Rapid patch release for ComfyUI (Locally Uncensored v2.3.1), addressing three critical user-reported issues from v2.3.0 within 12 hours.

## Key Concepts

### Changes in v2.3.1

**1. In-App Ollama Installation**
The update streamlines setup by eliminating manual download steps. Users can now "click Install Ollama in the onboarding wizard, watch the progress bar (with real download speed and elapsed time), done."

**2. Configurable ComfyUI Port & Path**
Critical issue: ComfyUI's desktop app uses different port settings than its browser predecessor. Users reported connection failures within hours of v2.3.0's release. The fix allows configuration through Settings > ComfyUI (Image & Video) with a Connect button, replacing hardcoded values across the codebase.

**3. Install Progress Reporting**
Installation process now displays real step-by-step progress:
- Step 1/3: Clone repository
- Step 2/3: Install PyTorch
- Step 3/3: Install dependencies

Previously, the interface showed "Starting..." indefinitely due to backend-to-frontend communication failures.

**4. Provider Status Indicators**
Connection status now displays meaningful information:
- Green = connected and responding
- Red = connection failed
- Gray = not yet checked

### Lesson from Rapid Response
The article showcases the value of shipping fixes quickly after community bug reports. v2.3.0's feature-heavy rollout introduced regressions; v2.3.1 focused exclusively on stability.

## GitHub Repository
[PurpleDoubleD/locally-uncensored](https://github.com/PurpleDoubleD/locally-uncensored) — v2.3.1 Release
