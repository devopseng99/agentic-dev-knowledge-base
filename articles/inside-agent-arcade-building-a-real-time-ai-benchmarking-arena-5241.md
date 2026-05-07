---
title: "Inside Agent Arcade: Building a Real-Time AI Benchmarking Arena"
url: "https://dev.to/harishkotra/inside-agent-arcade-building-a-real-time-ai-benchmarking-arena-5241"
author: "Harish Kotra"
category: "ai-agent-game-development"
---

# Inside Agent Arcade: Building a Real-Time AI Benchmarking Arena

**Author:** Harish Kotra
**Published:** March 7, 2026

## Overview
Agent Arcade provides a dynamic, visual, interactive testing environment where users observe AI models solving puzzles in real-time, moving beyond static text evaluation benchmarks like MMLU and HumanEval.

## Key Concepts

### The Engine-Agent Loop (State Machine)
1. **Generate:** Engine creates puzzle state
2. **Prompt:** State converts to natural language for AI
3. **Inference:** Model provider sends prompt (Ollama or AIsa.one API)
4. **Validate:** Engine parses and validates JSON responses against game rules
5. **Iterate:** Failed solutions trigger retry with error context

### State Management with Zustand

```javascript
export const useStore = create<AppState>((set) => ({
  provider: 'ollama',
  selectedModel: null,
  leaderboard: JSON.parse(localStorage.getItem('leaderboard_runs') || '[]'),
}));
```

### Pixel Art Design System

```css
.pixel-border {
  @apply border-4 border-slate-800 shadow-[4px_4px_0px_0px_rgba(30,41,59,1)];
}
```

### Challenges
The primary technical obstacle involved connecting web frontends to local Ollama instances. Browser CORS restrictions block such requests. Solution: directing users to configure `OLLAMA_ORIGINS="*"`.

**GitHub Repository:** https://github.com/harishkotra/agent-arcade
