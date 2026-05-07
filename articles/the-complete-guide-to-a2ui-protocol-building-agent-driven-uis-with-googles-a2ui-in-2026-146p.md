---
title: "The Complete Guide to A2UI Protocol: Building Agent-Driven UIs with Google's A2UI in 2026"
url: "https://dev.to/czmilo/the-complete-guide-to-a2ui-protocol-building-agent-driven-uis-with-googles-a2ui-in-2026-146p"
author: "cz"
category: "agent-ui-frameworks"
---

# The Complete Guide to A2UI Protocol: Building Agent-Driven UIs with Google's A2UI in 2026
**Author:** cz
**Published:** January 7, 2026

## Overview
A2UI (Agent to UI) is a declarative UI protocol by Google enabling AI agents to generate rich, interactive UIs rendering natively across platforms without executing arbitrary code. It uses an adjacency list model for flat component structures that are LLM-friendly.

## Key Concepts

### How A2UI Works
Agents send JSON messages describing UI components, clients render using native frameworks. Uses surfaceUpdate, dataModelUpdate, beginRendering, and deleteSurface message types.

### Component Structure (Adjacency List)
```json
{"surfaceUpdate": {"components": [
  {"id": "root", "component": {"Column": {"children": {"explicitList": ["greeting", "buttons"]}}}},
  {"id": "greeting", "component": {"Text": {"text": {"literalString": "Hello"}}}},
  {"id": "buttons", "component": {"Row": {"children": {"explicitList": ["cancel-btn", "ok-btn"]}}}}
]}}
```

### Data Binding with JSON Pointer
```json
{"text": {"path": "/user/name"}}
```

### Google Production Use
- Opal: AI mini-apps platform
- Gemini Enterprise: Custom business agents
- Flutter GenUI SDK: Cross-platform generative UI

### Standard Component Catalog
Layout (Row, Column, List), Display (Text, Image, Icon), Interactive (Button, TextField, CheckBox, DateTimeInput), Container (Card, Tabs, Modal)

### Platform Support
Web (Lit, Angular), Mobile/Desktop (Flutter GenUI SDK), React renderer coming Q1 2026
