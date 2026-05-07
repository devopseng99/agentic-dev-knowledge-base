---
title: "Beyond the API: Integrating ComfyUI and Flowise via MCP"
url: "https://dev.to/raphiki/beyond-the-api-integrating-comfyui-and-flowise-via-mcp-pc7"
author: "Raphael Semeteys"
category: "ai-image-video-generation"
---
# Beyond the API: Integrating ComfyUI and Flowise via MCP
**Author:** Raphael Semeteys  **Published:** 2026-02-09

## Overview
Demonstrates building an MCP (Model Context Protocol) server for ComfyUI that connects to Flowise, enabling natural-language conversation-driven image generation. Part 4 of the "Beyond the ComfyUI Canvas" series.

## Key Concepts

### Architecture Decision: SSE Over Stdio
The implementation chose Server-Sent Events (SSE) transport instead of the standard Stdio approach. This enables network-decoupled operation, allowing Flowise (potentially in Docker) to communicate with ComfyUI running on a separate GPU machine.

### Governance-Driven Development (GDD)
A "Governance Pack" established non-negotiable rules around SOLID principles, security, input validation, and documentation for AI-assisted code generation.

### Workflow Configuration via Metadata
Instead of hardcoding workflows, the solution embeds MCP metadata in ComfyUI workflow files using Note Nodes. This makes workflows self-contained and portable. The server automatically sanitizes tool names to `snake_case` for MCP compliance (e.g., "Flux Generator" becomes `flux_generator`).

### The "LAST" Hack
To enable conversational image editing, the server maintains a pointer to the most recently generated image. When a user requests modifications, they reference "LAST," triggering the server to download the previous image, re-upload it to ComfyUI, and inject it into an editing workflow.

### Technical Stack
- **ComfyUI:** Local instance running Flux 2 Klein (4-step optimization)
- **Flowise:** Low-code LLM application platform with native MCP support
- **Chat Model:** ChatMistralAI
- **MCP Transport:** SSE (Server-Sent Events)
- **Tool Agent:** Flowise's Tool Agent node with Buffer Memory

```json
{
  "name": "image_flux2_text_to_image",
  "description": "Generates high-quality images using the Flux model",
  "parameters": [
    {
      "name": "prompt",
      "type": "string",
      "description": "The detailed description of the image to generate",
      "target": "MCP_Positive",
      "required": true
    },
    {
      "name": "seed",
      "type": "int",
      "description": "Random seed for reproducibility",
      "target": "MCP_Sampler",
      "required": false
    }
  ]
}
```

### System Prompt Guidelines
The Tool Agent is instructed to:
- Call `list_available_workflows` immediately if tools aren't visible
- Use the "LAST" protocol for image chaining and modifications
- Strictly comply with parameter types and avoid inventing parameters

### Future Improvements
- **Session Isolation:** Prevent users from overwriting each other's "LAST" image reference
- **TTL Cleanup:** Automatically delete generated images after expiration
- **Authentication:** Multi-user production deployment requirements

## GitHub Repository
[raphiki/ComfyUI-MCP-Server](https://github.com/raphiki/ComfyUI-MCP-Server) — Full code for the ComfyUI MCP Server and the Flowise template.
