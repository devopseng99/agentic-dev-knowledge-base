---
title: "Automating Image Generation with n8n and ComfyUI"
url: "https://dev.to/raphiki/automating-image-generation-with-n8n-and-comfyui-521p"
author: "Raphael Semeteys"
category: "ai-image-video-generation"
---
# Automating Image Generation with n8n and ComfyUI
**Author:** Raphael Semeteys  **Published:** 2025-09-07

## Overview
Third installment in the "Beyond the ComfyUI Canvas" series. Demonstrates connecting ComfyUI from code and no-code solutions using n8n, including both text-to-image and image-to-image workflows.

## Key Concepts

### What is n8n?
n8n is a workflow automation platform with a visual node-based editor. It operates on a fair-code, open-core model where self-hosting is permitted.

### Installation
- **Node.js:** `npx n8n`
- **Docker:** `docker volume create n8n_data` followed by Docker container setup

The web UI launches at `http://localhost:5678`.

### Text-to-Image Workflow Architecture
Four nodes comprise this workflow:
1. **Chat Trigger** – Captures initial user prompts
2. **AI Agent** – Transforms prompts into JSON Prompt Style Guides using LLM instructions
3. **OpenAI Chat Model** – Handles GPT connectivity
4. **n8n-nodes-comfyui** – Community node connecting to ComfyUI instances

### ComfyUI Community Node Setup
- **API URL:** `http://127.0.0.1:8188` (local) or remote instances
- **API Key:** Optional authentication credential
- **Output Format:** PNG or JPEG selection
- **Workflow JSON:** Export from ComfyUI using "File / Export (API)" menu

The system injects dynamic prompts via expressions like `$node["AI Agent"].data` into specific workflow nodes (e.g., CLIP Text Encode nodes).

### Image-to-Image Workflow
Three nodes handle transformation:
1. **n8n Form Trigger** – HTML form for image upload and modification instructions
2. **ComfyUI Image Transformer** – Community node using Kontext Edit model
3. **Form Ending** – Returns results and enables downloads

**Configuration Details:**
- **Input Type:** Binary (instead of URL or Base64)
- **Image Node ID:** Identifies the LoadImage node in exported workflows

### Example Transformation
- **Initial Image:** Standard landscape photograph
- **Transformation Prompt:** "Make the scene at night with full moon and moonlight"
- **Result:** Successfully modified image with night-time ambiance and lunar lighting

### Additional Capabilities
The n8n-nodes-comfyui package provides supplementary nodes:
- Dual Image Transformer
- Single Image to Video
- Dual Image Video Generator

## GitHub/Community Resources
- [n8n-nodes-comfyui](https://github.com/mason276752/n8n-nodes-comfyui)
- [n8n-nodes-comfyui-image-to-image](https://www.npmjs.com/package/n8n-nodes-comfyui-image-to-image)
- [n8n Documentation](https://docs.n8n.io/sustainable-use-license/)
