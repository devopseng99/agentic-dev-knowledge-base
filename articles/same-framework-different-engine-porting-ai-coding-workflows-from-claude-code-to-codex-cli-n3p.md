---
title: "Same Framework, Different Engine: Porting AI Coding Workflows from Claude Code to Codex CLI"
url: https://dev.to/shinpr/same-framework-different-engine-porting-ai-coding-workflows-from-claude-code-to-codex-cli-n3p
author: Shinsuke KAGAWA
category: ai-coding-workflows
---

# Same Framework, Different Engine: Porting AI Coding Workflows from Claude Code to Codex CLI

**Author:** Shinsuke KAGAWA
**Date Published:** March 18, 2026
**Tags:** #ai #programming #productivity #tutorial

---

## Summary

The author successfully ported a sophisticated sub-agent workflow framework from Claude Code to Codex CLI with minimal migration effort. After waiting 8 months for Codex to support sub-agents, the actual port took just an afternoon -- revealing that well-designed workflows transcend platform-specific implementations.

## Key Insight

> "If you design workflows around agent roles and context separation rather than tool-specific features, your investment survives platform shifts"

## Core Architecture

The framework orchestrates 22 specialized sub-agents through 26 skills across a standardized workflow:

```
User Request -> requirement-analyzer [STOP] -> technical-designer
-> document-reviewer [STOP] -> work-planner -> task-decomposer
-> Per-task execution (executor -> quality-fixer -> git commit)
```

## Why Migration Was Effortless

Three foundational design choices enabled platform portability:

### 1. Natural Language as Interface
Agent behaviors defined in written instructions rather than platform-specific API calls, making guidance universally applicable across LLM systems.

### 2. Context Separation as Architecture
Each agent operates in a fresh context, preventing accumulated bias -- a pattern independent of any specific platform implementation.

### 3. Structured Handoffs Over Shared State
Agents communicate through artifacts (documents, JSON, task files) rather than shared memory, creating a file-based protocol agnostic to underlying infrastructure.

## Configuration Changes Only

| Aspect | Claude Code | Codex CLI |
|--------|-------------|-----------|
| Agent definitions | Markdown with YAML | TOML files |
| Skills location | `skills/` | `.agents/skills/` |
| Tool declarations | Explicit frontmatter | Inferred from sandbox |
| Config directory | `.claude/` | `.codex/` |

**Agent instructions remained unchanged.**

## Recipe Skills

The framework provides orchestration recipes:

- `$recipe-implement`: Full lifecycle development
- `$recipe-design`: Requirements to design documents
- `$recipe-build`: Autonomous task execution
- `$recipe-diagnose`: Problem investigation
- `$recipe-front-build`: React/TypeScript implementation
- `$recipe-fullstack-implement`: Cross-layer features

## Real-World Example: Login Feature

Implementation workflow demonstrated:
1. Requirement analysis with mandatory approval gate
2. Parallel design (backend + frontend agents running simultaneously)
3. Design review gate before proceeding
4. Autonomous execution with quality gates

Multiple agents worked in parallel contexts without interference, completing workflow from initialization to passing tests in a single session.

## Getting Started

```bash
npx codex-workflows install
```

**Resources:**
- Codex CLI version: [codex-workflows](https://github.com/shinpr/codex-workflows)
- Claude Code version: [claude-code-workflows](https://github.com/shinpr/claude-code-workflows)

## Takeaway

Investing in workflow design principles rather than platform-specific tooling creates sustainable automation infrastructure. The substantial agent instructions -- where intellectual effort concentrates -- transfer completely between platforms when foundational architecture prioritizes role-based separation and document-based communication over direct API integration.
