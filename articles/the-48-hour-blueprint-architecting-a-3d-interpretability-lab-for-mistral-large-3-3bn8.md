---
title: "The 48-Hour Blueprint: Architecting a 3D Interpretability Lab for Mistral Large 3"
url: "https://dev.to/soumia_g_9dc322fc4404cecd/the-48-hour-blueprint-architecting-a-3d-interpretability-lab-for-mistral-large-3-3bn8"
author: "Soumia"
category: "llm-eval-alignment"
---
# The 48-Hour Blueprint: Architecting a 3D Interpretability Lab for Mistral Large 3
**Author:** Soumia  **Published:** March 2, 2026

## Overview
OurMind.io is a multi-sensory interpretability visualization platform built in 48 hours at a hackathon. Rather than treating large language models as simple chatbots, the creators conceptualize them as a "Society of Minds" with shifting personas responding to different prompts.

## Key Concepts

### Core Concept: Society of Minds
The project separates LLMs into distinct "Social Agents" (personas) that activate based on prompt type:
- **Analytical** persona: activates for logical/mathematical prompts
- **Creative** persona: activates for open-ended/artistic prompts
- **Technical** persona: activates for code/engineering prompts

### Architecture: Two-Phase Design

**Phase 1: Visual Stage (Frontend)**
- Technology: React + Three.js/Spline
- A JavaScript function maps Mistral's metadata (e.g., Tone: 0.8, Structure: Grid) to Spline 3D States and ElevenLabs audio files
- Functions as a geometry viewer not a traditional chat interface

**Phase 2: Social Agent Interrogation (Backend)**
Three case studies force Mistral 3 to output JSON metadata:
1. Moral Dilemma (tests ethical reasoning)
2. Creative Abstract (tests fluidity)
3. Logical Paradox (tests structural logic)

### 48-Hour Execution Plan

**Day 1 (Science phase):**
- Finalize Spline geometries and voice profiles for three personas
- Run case study prompts against Mistral to extract activation metadata

**Day 2 (Exhibition phase):**
- Hardcode extracted JSON into frontend
- Create vision video (90% of judging criteria)
- Polish documentation

### Future Development
- Neuron-activation heatmaps showing actual firing patterns
- Interactive "Persona Switchboard" for manual persona switching
- Governance dashboard with "Verifiable Persona Signature" for corporate AI auditing

### Philosophy
"We aren't building another tool to generate content. We're building a tool to understand the character of the content generator." Interpretability requires making the invisible visible — not just what the model outputs, but what internal states drive those outputs.
