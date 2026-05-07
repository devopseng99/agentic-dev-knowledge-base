---
title: "Why I Built My Own Markup Language for AI-Powered Video Editing"
url: "https://dev.to/idrees_a/why-i-built-my-own-markup-language-for-ai-powered-video-editing-5925"
author: "Idrees"
category: "ai-media-generation"
---
# Why I Built My Own Markup Language for AI-Powered Video Editing
**Author:** Idrees  **Published:** July 24, 2025

## Overview
The author developed Swimlane Markup Language (SWML), a JSON-style declarative format to enable LLMs to reliably generate video editing instructions. Rather than having AI models produce error-prone FFmpeg scripts, the system uses SWML as an intermediate representation that models handle effectively, then renders the output through Blender's Video Sequence Editor.

## Key Concepts
- LLMs perform better generating structured intermediate representations than executable code
- Modular architecture separating planning, composition, and rendering stages
- Plugin system for extensibility (Manim for animations, future image/audio generation)
- Composition logic managed declaratively rather than imperatively

**Tech Stack:** FastAPI, Blender's Video Sequence Editor (VSE), Manim, Gemini, ChatGPT, Python

- GitHub: https://github.com/idreesaziz/GPT_Editor_MVP
