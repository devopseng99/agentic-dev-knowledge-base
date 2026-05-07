---
title: "Creating a Custom Node for ComfyUI Using React + TS"
url: "https://dev.to/netanelben/creating-a-custom-node-for-comfyui-using-react-ts-20g0"
author: "Netanel Ben"
category: "ai-image-video-generation"
---
# Creating a Custom Node for ComfyUI Using React + TS
**Author:** Netanel Ben  **Published:** 2024-10-09

## Overview
Step-by-step guide to building a custom ComfyUI node with a React + TypeScript frontend, enabling rich UI components within ComfyUI workflows.

## Key Concepts

### ComfyUI Custom Node Architecture
Custom nodes consist of:
1. **Python backend** — defines node inputs/outputs and processing logic
2. **JavaScript/React frontend** — custom widget UI (optional but powerful)

### Python Node Backend

```python
# my_custom_node/__init__.py

class PromptEnhancerNode:
    """Enhance prompts using an external API."""

    CATEGORY = "Custom/Prompt"
    FUNCTION = "enhance_prompt"
    RETURN_TYPES = ("STRING",)
    RETURN_NAMES = ("enhanced_prompt",)

    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "prompt": ("STRING", {"multiline": True}),
                "style": (["realistic", "anime", "painterly", "cinematic"],),
                "strength": ("FLOAT", {"default": 0.7, "min": 0.0, "max": 1.0, "step": 0.1}),
            }
        }

    def enhance_prompt(self, prompt: str, style: str, strength: float) -> tuple:
        # Your logic here
        enhanced = f"{prompt}, {style} style, high quality, detailed"
        return (enhanced,)


# Register the node
NODE_CLASS_MAPPINGS = {
    "PromptEnhancerNode": PromptEnhancerNode
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "PromptEnhancerNode": "Prompt Enhancer"
}
```

### React TypeScript Frontend Widget

```typescript
// web/src/PromptEnhancerWidget.tsx
import React, { useState } from 'react';

interface Props {
  value: string;
  onChange: (value: string) => void;
}

export const StyleSelector: React.FC<Props> = ({ value, onChange }) => {
  const styles = ['realistic', 'anime', 'painterly', 'cinematic'];

  return (
    <div className="style-selector">
      {styles.map((style) => (
        <button
          key={style}
          className={`style-btn ${value === style ? 'active' : ''}`}
          onClick={() => onChange(style)}
        >
          {style}
        </button>
      ))}
    </div>
  );
};
```

```typescript
// web/src/extension.ts
import { app } from "../../scripts/app.js";
import React from "react";
import { createRoot } from "react-dom/client";
import { StyleSelector } from "./PromptEnhancerWidget";

app.registerExtension({
  name: "PromptEnhancer.Extension",
  async beforeRegisterNodeDef(nodeType, nodeData) {
    if (nodeData.name === "PromptEnhancerNode") {
      // Override the style widget with React component
      const onNodeCreated = nodeType.prototype.onNodeCreated;
      nodeType.prototype.onNodeCreated = function () {
        onNodeCreated?.apply(this, arguments);

        const styleWidget = this.widgets.find((w) => w.name === "style");
        if (styleWidget) {
          // Replace default dropdown with React component
          const container = document.createElement("div");
          styleWidget.draw = function (ctx, node, widget_width, y) {
            const root = createRoot(container);
            root.render(
              React.createElement(StyleSelector, {
                value: this.value,
                onChange: (v) => { this.value = v; }
              })
            );
          };
        }
      };
    }
  }
});
```

### File Structure

```
my_custom_node/
├── __init__.py          # Python node definition
├── requirements.txt     # Python dependencies
└── web/
    ├── package.json
    ├── tsconfig.json
    └── src/
        ├── extension.ts  # ComfyUI extension registration
        └── components/   # React components
```

### Building the Frontend

```bash
cd web
npm install
npm run build  # Outputs to web/dist/
```

### Installation
Copy the entire `my_custom_node/` folder to `ComfyUI/custom_nodes/`. ComfyUI auto-discovers and loads custom nodes on startup.

### Key Gotchas
- Python node must define `NODE_CLASS_MAPPINGS` and `NODE_DISPLAY_NAME_MAPPINGS`
- React widgets must be registered before the node renders in the graph
- Use `app.registerExtension()` not the deprecated `LiteGraph.registerNodeType()`
- Built JS must be in `web/` subdirectory relative to the `__init__.py`
