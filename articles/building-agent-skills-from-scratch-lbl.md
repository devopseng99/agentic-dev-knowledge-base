---
title: "Building Agent Skills from Scratch"
url: "https://dev.to/onlyoneaman/building-agent-skills-from-scratch-lbl"
author: "Aman"
category: "agent-tool-use"
---

# Building Agent Skills from Scratch

**Author:** Aman
**Published:** December 26, 2025

## Overview

Explains how to implement agent skills -- modular, loadable instruction sets that expand an AI agent's capabilities without bloating the system prompt. Skills are individual markdown files stored in a directory structure with YAML metadata and detailed instructions that load on-demand.

## Key Concepts

### Four-Step Process

1. **Discovery** -- Scan directories for SKILL.md files, parse frontmatter (name, description only)
2. **Tool Registration** -- Convert skills into OpenAI function calls the LLM can invoke
3. **Activation** -- When triggered, load complete skill content and add to conversation
4. **Execution** -- LLM follows those instructions for the specific task

### Why This Pattern Works

- **Context efficiency** -- Load only metadata upfront; fetch full content when needed
- **Modularity** -- Add/remove skills by managing files, no code changes
- **Clarity** -- Logs show exactly which skill activated
- **Reusability** -- Skills become shareable libraries across projects

### Critical Implementation Details

- **Lazy Loading** -- Don't pre-load all skills at startup; discover metadata, activate on demand
- **Function Naming** -- Use `activate_skill_*` prefix for clear logging
- **Message Format** -- Ensure proper nested structure for OpenAI tool_calls
- **Tool Looping** -- Keep tools available in every LLM call; skills may chain

### Common Pitfalls

- Loading everything upfront defeats modularity
- Vague skill descriptions confuse the LLM's selection
- Omitting tools after skill activation breaks chaining
- Unstructured skill content undermines LLM performance

### When Skills Make Sense

**Appropriate for:** Multi-domain agents, specialized workflows, team-shared patterns, context-limited scenarios
**Unnecessary for:** Single-purpose agents, focused prompts, prototypes
