---
title: "Build with Google's new A2UI Spec: Agent User Interfaces with A2UI + AG-UI"
url: "https://dev.to/copilotkit/a2ui-in-practice-build-agent-to-user-interfaces-using-a2a-ag-ui-3ng5"
author: "Bonnie"
category: "agent-ui-frameworks"
---

# Build with Google's new A2UI Spec: Agent User Interfaces with A2UI + AG-UI
**Author:** Bonnie
**Published:** December 16, 2025

## Overview
A comprehensive guide to building full-stack agent-to-user interface (A2UI) systems using the A2A protocol, AG-UI protocol, and CopilotKit framework, enabling agents to generate dynamic UI components like charts, forms, tables, and buttons on demand.

## Key Concepts

### What is A2UI?
A2UI is a new open-source UI Toolkit to facilitate LLM-generated UIs. Rather than agents responding with text alone, they can generate dynamic UI components on demand.

### Setup

```bash
git clone https://github.com/copilotkit/with-a2a-a2ui.git
echo "GEMINI_API_KEY=your_api_key_here" > .env
pnpm install
pnpm dev
```

### A2UI Schemas
Developers create A2UI schemas that validate agent responses and define UI templates. The implementation uses JSON schema examples with components like Column layouts, Lists, Cards, and Button elements.

### A2UI Composer Tool
An accessible UI generation tool at https://a2ui-editor.ag-ui.com/ allows developers to describe widgets and automatically generate corresponding A2UI JSON specifications.

### Agent Configuration
The RestaurantAgent class uses conditional prompt selection: UI mode incorporates full schemas and examples, while text mode uses simplified instructions. The agent supports both A2UI JSON and text responses via a use_ui boolean flag.

### Key Architecture
- A2UI defines the content (what UI to render via declarative JSON)
- AG-UI defines the transport (how to stream it to the client)
- CopilotKit provides the React rendering layer
