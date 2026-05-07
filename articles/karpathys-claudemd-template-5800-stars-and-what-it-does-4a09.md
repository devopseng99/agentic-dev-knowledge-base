---
title: "Karpathy's CLAUDE.md Template: 5,800 Stars and What It Does"
url: "https://dev.to/max_quimby/karpathys-claudemd-template-5800-stars-and-what-it-does-4a09"
author: "Max Quimby"
category: "templatized-software"
---
# Karpathy's CLAUDE.md Template: 5,800 Stars and What It Does
**Author:** Max Quimby  **Published:** April 15, 2026

## Overview
A markdown configuration file (`CLAUDE.md`) created by the community (inspired by Andrej Karpathy's observations) achieved 5,828 GitHub stars in a single day, becoming the second most-starred repository globally on April 13, 2026. The file provides behavioral guidelines for Claude Code development.

## Key Concepts
**What CLAUDE.md Does**: A markdown file placed at a project root that Claude Code automatically reads to incorporate guidelines as persistent context. The official documentation notes approximately "150-200 instruction budget before compliance drops off."

**The Four Core Principles**:
1. **Think Before Coding** — Claude must state assumptions explicitly, surface multiple interpretations when ambiguous
2. **Simplicity First** — Minimum viable code only; no speculative features, unnecessary abstractions
3. **Surgical Changes** — Modify only what's necessary; distinguish between cleanup of introduced code vs pre-existing patterns
4. **Goal-Driven Execution** — Define measurable success criteria and verification steps before implementation

**Key Limitation**: The template operates at ~80% compliance rate and addresses code quality, not whether the feature being built is strategically correct.

```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

```bash
claude plugins install forrestchang/andrej-karpathy-skills
```

```markdown
# Project Context

## Stack
- Python 3.12, FastAPI, PostgreSQL
- Tests: pytest with fixtures in tests/conftest.py
- Linting: ruff, enforced in CI

## Key Patterns
- DB queries go through repository layer in app/repositories/
- All API responses use Pydantic response models in app/schemas/

---
<!-- Karpathy base principles below -->
```

GitHub: https://github.com/forrestchang/andrej-karpathy-skills
