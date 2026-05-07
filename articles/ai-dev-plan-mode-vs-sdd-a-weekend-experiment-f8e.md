---
title: "AI Dev: Plan Mode vs. SDD — A Weekend Experiment"
url: "https://dev.to/maximsaplin/ai-dev-plan-mode-vs-sdd-a-weekend-experiment-f8e"
author: "Maxim Saplin"
category: "ai-agent-game-development"
---

# AI Dev: Plan Mode vs. SDD — A Weekend Experiment

**Author:** Maxim Saplin
**Published:** December 4, 2025

## Overview
Comparison of Spec-Driven Development (SDD) versus Cursor's Plan Mode. Three months prior, the author tested Kiro's SDD workflow generating 13,000 lines of Rust with 246 tests that proved unmaintainable. This weekend, he built a complete Flutter mobile app using Plan Mode with disciplined guardrails, shipping functional code in ~8 hours for $46.68 in tokens.

## Key Concepts

### Token Usage Breakdown
- Gemini 3 Pro: 42.7M tokens ($32.02)
- GPT 5.1: 9.7M tokens ($5.79)
- Claude 4.5 Opus: 9.0M tokens ($8.66)
- Additional models: $0.21
- **Total: $46.68**

### Plan Mode Advantages
- Acts as an "alignment ceremony" before implementation
- Maintains developer control and confidence
- Produces maintainable, understandable code
- Allows iterative refinement through `/summarize` commands

### SDD Drawbacks
- Over-engineers solutions with unnecessary complexity
- Creates unmaintainable test suites with unclear purpose
- Breaks CI/CD pipelines irreparably
- Causes loss of codebase comprehension

### Critical Lessons
- "Models often propose impossible or broken solutions...Always verify feasibility before implementation."
- Enforced documentation discipline through Cursor rules
- MCP integration challenges: expired auth tokens, tool bundle limitations, YAML formatting issues
