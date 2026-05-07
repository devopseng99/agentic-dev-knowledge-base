---
title: "The Complete SOUL.md Template Guide -- Give Your AI Agent a Personality"
url: "https://dev.to/tomleelive/the-complete-soulmd-template-guide-give-your-ai-agent-a-personality-3php"
author: "Tom Lee"
category: "full-code-examples"
---

# The Complete SOUL.md Template Guide -- Give Your AI Agent a Personality
**Author:** Tom Lee
**Published:** February 24, 2026

## Overview
Comprehensive guide to SOUL.md, a markdown configuration file defining an AI assistant's personality, communication style, expertise, and operational boundaries. Compatible with Claude Code, Cursor, Windsurf, OpenClaw.

## Key Concepts

### Scope Options
- `~/SOUL.md` (global across all projects)
- `./SOUL.md` (project-specific)
- `./.soul/SOUL.md` (Soul Spec directory format)

### Soul Spec v0.5 Structure
- `soul.json` (metadata and compatibility)
- `SOUL.md` (core identity)
- `IDENTITY.md` (detailed expertise)
- `AGENTS.md` (multi-agent configurations)
- `RULES.md` (hard constraints)
- `CONTEXT.md` (project-specific context)

### Pre-Built Souls Registry (81+)
Install via `npx clawsouls install`:
- `clawsouls/react-ts-dev`
- `clawsouls/python-ml`
- `clawsouls/devops-aws`
- `clawsouls/tech-writer`
- `clawsouls/startup-cto`
- `clawsouls/security-auditor`
- `clawsouls/mori` (elderly care companion robot)

### Templates Provided
1. Basic Template -- identity, communication style, tech stack, rules
2. Full-Stack Developer -- frontend/backend expertise, code standards, git conventions
3. Business Analyst -- data-driven communication, metrics expertise
4. Creative Writer -- voice/tone, style guides

### Reported Impact
- 40% fewer clarification exchanges
- Consistent code style across AI-generated PRs
- First suggestions usable 80% of the time
- Reduced need for repetitive prompt engineering

### Best Practices
1. Start minimal, iterate based on gaps
2. Be specific in rules and preferences
3. Include examples of desired/undesired behavior
4. Explicitly state boundaries
5. Use conditional sections for context-dependent instructions
6. Version control the SOUL.md file

### Quick Start
```bash
touch SOUL.md
# Copy and customize a template
# Add tech stack and 3-5 rules
# Commit to version control
```

### Registry
https://clawsouls.ai
