---
title: "Cloudflare AI Challenge Submission: Image to Lyrics Generator"
url: "https://dev.to/floscode/cloudflare-ai-challenge-submission-imageharmony-e7o"
author: "Florian"
category: "hackathons"
---

# Cloudflare AI Challenge Submission: Image to Lyrics Generator
**Author:** Florian
**Published:** April 10, 2024

## Overview
ImageHarmony combines image analysis with AI-driven creative writing, accepting uploaded images and genre selections to generate original musical compositions through a multi-stage pipeline on Cloudflare Workers.

## Key Concepts
- Mistral: image analysis and visual descriptions
- Llama-2: lyric composition, keyword extraction, sentiment classification
- Whisper: audio input for Easter egg feature
- Three-step pipeline: image description -> keyword extraction -> genre-specific lyric generation
- "System role" prompting with personas (e.g., "pretend you are Wolfgang Amadeus Mozart")
- Single-file Cloudflare Workers implementation

### GitHub Repository
- https://github.com/flos-code/imageharmony

**Live Demo:** https://imageharmony.contact-44d.workers.dev/
