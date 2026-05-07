---
title: "Getting Started with Moonshot AI's Kimi Code: An Autonomous Coding Agent for Your Terminal"
url: "https://dev.to/james_miller_8dc58a89cb9e/getting-started-with-moonshot-ais-kimi-code-an-autonomous-coding-agent-for-your-terminal-5ei9"
author: "James Miller"
category: "autonomous coding agent"
---

# Getting Started with Moonshot AI's Kimi Code: An Autonomous Coding Agent for Your Terminal

**Author:** James Miller
**Published:** February 5, 2026

## Overview

Moonshot AI's Kimi Code is an AI Agent capable of autonomous planning that runs directly in your terminal. Built on the K2.5 model, it supports multimodal input (images and video) and integrates with VSCode, Cursor, JetBrains, and Zed via ACP protocol.

## Key Concepts

### Installation

```bash
pip install uv
uv tool install --python 3.13 kimi-cli
kimi --version
```

### Core Workflows

1. **Feature Development** - Describe requirements in natural language, follows "Read -> Modify -> Verify" flow
2. **Troubleshooting** - Paste error logs, switch to "Thinking Mode" for complex logic using `k2-thinking` model
3. **Automation Tasks** - Batch operations like converting variable declarations, analyzing logs

### IDE Integration (JetBrains)

```bash
which kimi
```

```json
{
  "agent_servers": {
    "Kimi Code CLI": {
      "command": "/Users/YOUR_USERNAME/.local/bin/kimi",
      "args": ["acp"],
      "env": {}
    }
  }
}
```

### Key Features

- **@ Path Completion** - Type `@` to reference files (e.g., `@src/core/scheduler.py`)
- **Multimodal Input** - Supports clipboard image pasting for UI tasks
- **YOLO Mode** - `/yolo` enables automated execution without confirmation
- **`/init` Command** - Generates `AGENTS.md` file as a project manual for the AI
