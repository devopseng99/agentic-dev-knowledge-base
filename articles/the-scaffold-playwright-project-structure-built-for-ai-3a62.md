---
title: "The Scaffold: Playwright Project Structure Built for AI"
url: "https://dev.to/idavidov13/the-scaffold-playwright-project-structure-built-for-ai-3a62"
author: "idavidov13"
category: "templatized-software"
---
# The Scaffold: Playwright Project Structure Built for AI
**Author:** idavidov13  **Published:** March 1, 2026

## Overview
Introduces a pre-built Playwright project structure designed specifically to enable AI agents to build and maintain test automation frameworks. Provides standardized conventions, folder organization, and instruction files that guide both human developers and AI systems.

## Key Concepts
**Scaffold Definition**: A predefined project layout answering organizational questions before coding begins, similar to how city grids are planned before buildings are constructed.

**Folder Structure**:
- `pages/` — UI page objects and components
- `tests/` — Test scenarios organized by area
- `test-data/` — Dynamic factories and static JSON for edge cases
- `fixtures/` — Dependency injection wiring
- `enums/` — Centralized string constants
- `config/` — Environment URLs and settings
- `.claude/` — AI instruction files

**Core Patterns Included**:
- Page Object Model for UI abstraction
- Fixtures providing dependency injection
- Type-safe API testing with Zod validation
- Smart test data generation using Faker library
- Automated linting via ESLint and Prettier

**AI-Native Features**: The `.claude/` directory contains structured instruction files readable by Claude Code, Cursor, and GitHub Copilot, enabling AI agents to generate code aligned with project standards.

**Dev Container Support**: Docker configuration providing pre-configured Node, Playwright browsers, Python, and AI CLI tools.

```plaintext
pages/          → UI page objects and components
tests/          → Test scenarios, organized by area and type
test-data/      → Factories (dynamic) and static JSON (edge cases)
fixtures/       → Dependency injection: wires everything together
enums/          → No hardcoded strings anywhere
config/         → URLs and environment settings
.claude/        → AI instruction files: skills and the orchestrator
```

GitHub: https://github.com/idavidov13/Playwright-Scaffold-AI-Assisted-Development-Public
