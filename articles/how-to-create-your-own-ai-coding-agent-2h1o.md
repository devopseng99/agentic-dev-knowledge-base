---
title: "How to Create Your Own AI Coding Agent"
url: https://dev.to/wyattdave/how-to-create-your-own-ai-coding-agent-2h1o
author: David Wyatt
category: ai-coding-agent-build
---

# How to Create Your Own AI Coding Agent

**Author:** David Wyatt
**Published:** April 6, 2026

## Overview

This article explores building a custom AI coding agent for niche development scenarios where general LLMs lack specialized knowledge. Wyatt developed an agent specifically for Power Platform Code Apps using vanilla JavaScript -- an area with minimal training data.

## Key Sections

### 1. Prompt Stack Overview

The article describes a hierarchical prompt structure:

- **Model System Prompt**: Highest level constraints (security, legality)
- **Application System Prompt**: Tools and patterns from the platform
- **Instruction.md**: Project-specific guidelines (naming, structure, principles)
- **Skill.md**: "Dynamic context" files for specific tasks (examples: frontend design, PowerPoint manipulation)
- **Your Prompt**: The actual user request with context

> "Instructions and Skills were created by Anthropic and designed for Claude Code, but other tools and models can use them too"

### 2. Platform Selection

Wyatt chose VS Code Extension development based on:
- Built-in GitHub Copilot authentication
- Integrated terminal access
- Custom UI capabilities
- No backend hosting required
- Free distribution via marketplace

### 3. Implementation Strategy

Three core advantages:

1. **Simplified UI**: Button-based pipeline abstracts Power Platform CLI commands (authentication, environment selection, deployment)
2. **System Prompts**: Specifically designed to prevent the LLM from defaulting to standard JavaScript patterns
3. **Skill Files**: Documented learnings from building multiple applications

The development approach was iterative: build apps, analyze LLM reasoning, document mistakes as instructions.

### 4. Critical Learnings

**Context Stack Management**

The major challenge: LLMs require resending all conversation history with each request. When using tools, this multiplies exponentially. Wyatt's diagram showed context being sent 5+ times in simple interactions.

**Solutions implemented:**

- Minimize system prompts and instruction files
- Send only necessary data using file trees
- Create decision logs tracking completed tasks and removing previous tool calls
- Separate projects into smaller tasks

**Model Performance**

> "Using Opus 4.6/GPT5.4 would deliver great results, but dropping to Auto or GPT4.1 would deliver terrible results"

Better models significantly impact agent quality.

**External Dependencies**

Relying on CLI tools and extensions creates risks (Wyatt encountered duplicate CLI installations causing failures). Solution: move functionality to deterministic code and UI when possible.

## Key Takeaway

"All I'm doing is learning from experience and then documenting it so that the agent knows what to do and what not to do." Effective AI agents require disciplined iteration, testing, and prompt refinement -- not inherently smarter models.

**Resource:** The agent is available free at the [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=PowerDevBox.codeappjsplus)
