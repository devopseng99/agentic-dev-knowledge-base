---
title: "How TF I Made An AI for Motion Graphics"
url: "https://dev.to/therealgabry/how-tf-i-made-an-ai-for-motion-graphics-p28"
author: "Gabriele Bolognese"
category: "ai-media-generation"
---
# How TF I Made An AI for Motion Graphics
**Author:** Gabriele Bolognese  **Published:** July 25, 2025

## Overview
The article describes a web-based motion graphics editor that leverages AI assistants and agents to generate animations. Rather than building a full language model, the creator developed a system using OpenAI's GPT and Anthropic's Claude to orchestrate multi-stage animation creation through JSON-based shape definitions.

## Key Concepts

1. **Shape Generation via JSON** — Shapes are created as CSS canvas elements defined by JSON property files
2. **Assistant Model** — Single-task AI (OpenAI's Assistant) generates JSON shape specifications from user prompts
3. **Agent Orchestration** — Custom agent system coordinates multiple assistants to break down complex animation requests
4. **Design Composition** — AI calculates spatial positioning of shapes on a 3840×2160 canvas
5. **Animation Context** — Claude Sonnet 4.0 (with 200k+ context tokens) handles keyframe generation while maintaining animation coherence
6. **Token Optimization** — Training files guide AI on available tools to minimize expensive token consumption

Pricing Model: Free tier: $0.50 monthly credits (~40 design animations or ~8 animations for animation mode)
