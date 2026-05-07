---
title: "I Built an Agentic Ferrari in Rust… and Nobody's Driving It"
url: "https://dev.to/tacshade/i-built-an-agentic-ferrari-in-rust-and-nobodys-driving-it-57fe"
author: "Evan Green"
category: "immutable-arch-rust-flink"
---
# I Built an Agentic Ferrari in Rust… and Nobody's Driving It
**Author:** Evan Green  **Published:** February 23, 2026

## Overview
Tandem: a headless agent runtime in Rust (tandem-engine) with multi-client architecture (Tauri desktop, TUI, headless portal). Local-first design with SQLite + embedded vector search. Capability isn't adoption — the lesson from building a powerful but underused system.

## Key Concepts
Architecture:
- **tandem-engine (Rust)**: Orchestration, tools, memory, event streaming, state management
- **Desktop app (Tauri + React)**: Visual workflow planning and diff approval
- **TUI**: Terminal interface for same engine
- **Headless Portal**: Nine working examples

Why Rust: handles "boring but heavy" runtime work — state management, event streaming, tool routing, memory operations, document processing.

Execution modes per prompt:
- **Ask**: Questions without file modifications
- **Explore**: Safe codebase analysis
- **Immediate**: Quick, low-risk edits
- **Plan Mode**: Agent proposes staged execution with visual diffs requiring human approval
- **Coder**: Code generation focus
- **Orchestrate**: Multi-step workflow coordination

Local-First Design:
- Memory persists locally via SQLite with embedded vector search
- No external databases (no Postgres, no Pinecone)
- API keys encrypted with AES-256-GCM

**Source:** https://github.com/frumu-ai/tandem
