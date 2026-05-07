---
title: "I Built a Full Game Studio Inside OpenCode — 48 AI Agents, 100% Free"
url: "https://dev.to/traft_dc2e0ce4c23fbe25e07/i-built-a-full-game-studio-inside-opencode-48-ai-agents-100-free-3hck"
author: "Traft"
category: "ai-agent-game-development"
---

# I Built a Full Game Studio Inside OpenCode — 48 AI Agents, 100% Free

**Author:** Traft
**Published:** March 26, 2026

## Overview
A configuration package that transforms OpenCode into a structured game development environment with 48 specialized AI agents and 37 workflow skills, all running for free on OpenCode's Big Pickle model.

## Key Concepts

### Agent Hierarchy (48 total)
- **Tier 1 Directors:** Creative Director, Technical Director, Producer
- **Tier 2 Department Leads:** Game Designer, Lead Programmer, Art Director, Audio Director, Narrative Director, QA Lead, Release Manager
- **Tier 3 Specialists:** 22 additional roles including gameplay programmers, level designers, sound designers, and accessibility specialists
- **Engine Specialists:** Dedicated agents for Godot, Unity, and Unreal (5 agents per engine)

### Usage Examples

```
@game-designer "Design a combat system for my roguelike"
@lead-programmer "Review this ECS architecture"
@godot-shader-specialist "Write a 2D water shader with refraction"
@qa-tester "What are the edge cases in this save system?"
```

### Workflow Skills (37 slash commands)

- `/start` — New project setup
- `/sprint-plan` — Weekly task breakdown
- `/code-review` — Architectural review
- `/balance-check` — Game economy audit
- `/brainstorm` — Structured creative session
- `/release-checklist` — Pre-launch verification
- `/patch-notes` — Auto-generate from git history

### Installation

```bash
npm install -g opencode
git clone https://github.com/TraftG/opencode-game-studio
cd opencode-game-studio
cp -r .opencode/* ~/.config/opencode/
opencode
```

Every task follows a mandatory flow: "Question -> Options -> Decision -> Draft -> Approval." Agents must request permission before modifying files.
