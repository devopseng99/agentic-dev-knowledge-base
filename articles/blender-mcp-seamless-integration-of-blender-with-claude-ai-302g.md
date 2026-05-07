---
title: "Blender MCP: Seamless Integration of Blender with Claude AI"
url: "https://dev.to/mehmetakar/blender-mcp-seamless-integration-of-blender-with-claude-ai-302g"
author: "Mehmet Akar"
category: "3d-ai-generation"
---
# Blender MCP: Seamless Integration of Blender with Claude AI
**Author:** Mehmet Akar  **Published:** 2025-03-17

## Overview
Blender MCP connects Blender 3D software with Claude AI through the Model Context Protocol, enabling AI-assisted 3D modeling, scene creation, and object manipulation workflows.

## Key Concepts

### Key Features
- Two-way communication between Blender and Claude
- Object creation, deletion, and transformation
- Material and texture application
- Scene inspection with real-time data retrieval
- AI-generated models via Hyper3D Rodin
- Access to Poly Haven asset library

### Installation Requirements
- Blender 3.0 or newer
- Python 3.10 or higher
- UV package manager

### MCP Configuration
Configure in Claude AI Desktop via `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "blender": {
      "command": "uvx",
      "args": ["blender-mcp"]
    }
  }
}
```

### Usage Examples
Commands that work with Blender MCP:
- "Generate a dungeon scene with a dragon guarding gold"
- "Make this car red and metallic"
- "Create a beach scene using HDRIs and rock models from Poly Haven"
- "Add a 2-meter cube at the origin and apply a metal material"

### Cursor IDE Integration

```bash
uvx blender-mcp
```

### Why This Matters for 3D AI
Blender MCP represents the first-mover vision for connecting LLMs to 3D software. By treating Blender as an MCP server, Claude can directly call Blender Python API methods, enabling:
- Procedural mesh generation from natural language
- Scene composition with AI-selected asset combinations
- Automated UV unwrapping and material assignment
- Physics simulation setup via text commands

### Security Warning
Python code execution in Blender carries risk. Always save work before running AI-generated scripts and review commands before execution.
