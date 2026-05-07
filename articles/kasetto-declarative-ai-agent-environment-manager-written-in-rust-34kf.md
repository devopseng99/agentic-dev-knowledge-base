---
title: "kasetto - Declarative AI Agent Environment Manager, Written in Rust"
url: "https://dev.to/pivoshenko/kasetto-declarative-ai-agent-environment-manager-written-in-rust-34kf"
author: "Volodymyr Pivoshenko"
category: "AI agent Rust"
---

# kasetto - Declarative AI Agent Environment Manager, Written in Rust

**Author:** Volodymyr Pivoshenko
**Published:** April 11, 2026

## Overview
Kasetto solves the fragmentation problem when managing AI coding tools and their configurations across teams and machines. It provides declarative, reproducible AI agent environment management through a single YAML configuration, supporting 21 built-in presets including Claude Code, Cursor, Codex, and Windsurf.

## Key Concepts

### Features
- Single YAML configuration for entire setup
- Multi-agent support (21 built-in presets)
- Multi-source capability (GitHub, GitLab, Bitbucket, Codeberg)
- MCP server management with automatic merging
- Global and project scopes with lockfiles
- CI-friendly features (--dry-run, --json output)
- Single Rust binary with no runtime dependencies

### Configuration

```yaml
agent:
  - claude-code
  - cursor
  - codex

skills:
  - source: https://github.com/org/skill-pack
    skills: "*"
  - source: https://github.com/org/skill-pack-2
    skills:
      - product-design

mcps:
  - source: https://github.com/org/mcp-pack
```

### Core Commands
- `kst sync` - Install skills and MCP servers
- `kst list` - Browse installed skills
- `kst init` - Create configuration file
- `kst doctor` - Diagnose environment issues
- `kst clean` - Remove all installations

### Naming Origin
"Kasetto" means cassette in Japanese, symbolizing self-contained, portable reproducibility across any device.
