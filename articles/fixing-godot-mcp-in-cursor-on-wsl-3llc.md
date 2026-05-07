---
title: "Fixing Godot MCP in Cursor on WSL"
url: "https://dev.to/sym/fixing-godot-mcp-in-cursor-on-wsl-3llc"
author: "sym"
category: "gaming-agents"
---
# Fixing Godot MCP in Cursor on WSL
**Author:** Ryan Carter  **Published:** April 28, 2026

## Overview
Addresses three interconnected issues preventing godot-mcp from connecting in Cursor on WSL. The primary problem stems from Cursor being a Windows application unable to directly access Linux Node binaries. Solution: configure `mcp.json` to use `wsl.exe` as the command with the Node interpreter and absolute Linux path as arguments.

## Key Concepts
- **Architecture Mismatch**: Cursor runs natively on Windows but needs to invoke tools in WSL Linux environment — requires wsl.exe as bridge
- **Path Resolution**: Tildes (`~`) don't expand within JSON configuration files — must use absolute paths
- **JSON Syntax**: Comment syntax (`//`) breaks JSON parsing silently — common gotcha when copying configs from tutorials
- **WSL Bridge**: `wsl.exe` acts as an intermediary allowing Windows applications to execute Linux programs
- **Godot MCP**: Model Context Protocol server for Godot engine — allows AI agents to control the Godot editor
- **Prerequisite State**: Godot editor must be open with the project loaded for most MCP tools to function

```json
// BROKEN — tilde doesn't expand in JSON
{
  "args": ["~/game_dev/godot-mcp/build/index.js"]
}
```

```json
// BROKEN — comments are invalid JSON
{
  "env": {
    "DEBUG": "true"   // Optional: Enable detailed logging
  }
}
```

```json
// WORKING — use wsl.exe + absolute path + no comments
{
  "godot": {
    "command": "wsl.exe",
    "args": ["node", "/home/yourname/game_dev/godot-mcp/build/index.js"],
    "env": {
      "DEBUG": "true"
    },
    "disabled": false,
    "autoApprove": [
      "launch_editor",
      "run_project",
      "get_debug_output",
      "stop_project",
      "get_godot_version",
      "list_projects",
      "get_project_info",
      "create_scene",
      "add_node",
      "load_sprite",
      "save_scene"
    ]
  }
}
```

## GitHub Repository
https://github.com/Coding-Solo/godot-mcp
