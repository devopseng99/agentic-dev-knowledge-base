---
title: "I built a Desktop Pet Copilot that wanders around your screen and writes code"
url: "https://dev.to/rain9/tired-of-boring-ai-assistants-i-built-a-desktop-pet-copilot-that-wanders-around-your-screen-and-52pg"
author: "Rain9"
category: "building-ai-copilot"
---

# I built a "Desktop Pet" Copilot that wanders around your screen and writes code

**Author:** Rain9
**Published:** April 7, 2026

## Overview
CodeWalkers is an open-source desktop app combining nostalgic desktop pet functionality with AI coding assistance. Pixel-art characters wander your screen, providing integrated AI via GitHub Copilot CLI and Gemini CLI.

## Key Concepts

### Tech Stack
Tauri v2 + React + TypeScript

### Technical Challenges Solved
1. **Transparent Window Passthrough:** Combined requestAnimationFrame with pixel-level hit-testing and minimal background opacity (rgba(255,255,255,0.01))
2. **CLI Integration:** Rust backend hijacks std::process::Command to run real CLI tools, parsing ANSI escape codes into visual feedback
3. **Animation Performance:** DOM transform manipulation with ref and requestAnimationFrame for 60 FPS, avoiding React state

**Repository:** https://github.com/you-want/CodeWalkers
